import { uniqBy } from 'common/collections';
import { classes } from 'common/react';
import { createSearch } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useSharedState } from '../backend';
import { Box, Button, Flex, Icon, Input, NumberInput, ProgressBar, Section, Stack } from '../components';
import { formatMoney, formatSiUnit } from '../format';
import { Window } from '../layouts';

const MATERIAL_KEYS = {
  "железо": "sheet-metal_3",
  "стекло": "sheet-glass_3",
  "серебро": "sheet-silver_3",
  "золото": "sheet-gold_3",
  "алмазы": "sheet-diamond",
  "плазма": "sheet-plasma_3",
  "уран": "sheet-uranium",
  "бананиум": "sheet-bananium",
  "титан": "sheet-titanium_3",
  "блюспейс кристалл": "polycrystal",
  "пластик": "sheet-plastic_3",
};

const COLOR_NONE = 0;
const COLOR_AVERAGE = 1;
const COLOR_BAD = 2;

const COLOR_KEYS = {
  [COLOR_NONE]: false,
  [COLOR_AVERAGE]: "average",
  [COLOR_BAD]: "bad",
};

const materialArrayToObj = materials => {
  let materialObj = {};

  materials.forEach(m => {
    materialObj[m.name] = m.amount; });

  return materialObj;
};

const partBuildColor = (cost, tally, material) => {
  if (cost > material) {
    return { color: COLOR_BAD, deficit: (cost - material) };
  }

  if (tally > material) {
    return { color: COLOR_AVERAGE, deficit: cost };
  }

  if (cost + tally > material) {
    return { color: COLOR_AVERAGE, deficit: ((cost + tally) - material) };
  }

  return { color: COLOR_NONE, deficit: 0 };
};

const partCondFormat = (materials, tally, part) => {
  let format = { "textColor": COLOR_NONE };

  Object.keys(part.cost).forEach(mat => {
    format[mat] = partBuildColor(part.cost[mat], tally[mat], materials[mat]);

    if (format[mat].color > format["textColor"]) {
      format["textColor"] = format[mat].color;
    }
  });

  return format;
};

const queueCondFormat = (materials, queue) => {
  let materialTally = {};
  let matFormat = {};
  let missingMatTally = {};
  let textColors = {};

  queue.forEach((part, i) => {
    textColors[i] = COLOR_NONE;
    Object.keys(part.cost).forEach(mat => {
      materialTally[mat] = materialTally[mat] || 0;
      missingMatTally[mat] = missingMatTally[mat] || 0;

      matFormat[mat] = partBuildColor(
        part.cost[mat], materialTally[mat], materials[mat]
      );

      if (matFormat[mat].color !== COLOR_NONE) {
        if (textColors[i] < matFormat[mat].color) {
          textColors[i] = matFormat[mat].color;
        }
      }
      else {
        materialTally[mat] += part.cost[mat];
      }

      missingMatTally[mat] += matFormat[mat].deficit;
    });
  });
  return { materialTally, missingMatTally, textColors, matFormat };
};

const searchFilter = (search, allparts) => {
  if (!search.length) {
    return;
  }
  const resultFilter = createSearch(search, part => (
    (part.name || "")
    + (part.desc || "")
    + (part.searchMeta || "")
  ));
  let searchResults = [];
  Object.keys(allparts).forEach(category => {
    allparts[category]
      .filter(resultFilter)
      .forEach(e => {
        searchResults.push(e);
      });
  });
  searchResults = uniqBy(part => part.name)(searchResults);
  return searchResults;
};

export const ExosuitFabricator = (props, context) => {
  const { act, data } = useBackend(context);
  const queue = data.queue || [];
  const materialAsObj = materialArrayToObj(data.materials || []);
  const {
    materialTally,
    missingMatTally,
    textColors,
  } = queueCondFormat(materialAsObj, queue);
  const [displayMatCost, setDisplayMatCost] = useSharedState(
    context, 'display_mats', false);
  return (
    <Window
      title="Фабрикатор экзоскелетов"
      width={1100}
      height={640}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Stack fill>
              <Stack.Item grow>
                <Section fill title="Материалы">
                  <Materials />
                </Section>
              </Stack.Item>
              <Stack.Item>
                <Section fill title="Настройки">
                  <Button.Checkbox
                    onClick={() => setDisplayMatCost(!displayMatCost)}
                    checked={displayMatCost}>
                    Показывать стоимость
                  </Button.Checkbox>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item>
                <Section
                  fill
                  title="Категории"
                  buttons={(
                    <Button
                      content="Синхр."
                      onClick={() => act("sync_rnd")} />
                  )}>
                  <PartSets />
                </Section>
              </Stack.Item>
              <Stack.Item
                position="relative"
                grow={1}>
                <Box
                  fillPositionedParent
                  overflowY="scroll">
                  <PartLists
                    queueMaterials={materialTally}
                    materials={materialAsObj} />
                </Box>
              </Stack.Item>
              <Stack.Item width="420px">
                <Queue
                  queueMaterials={materialTally}
                  missingMaterials={missingMatTally}
                  textColors={textColors} />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const EjectMaterial = (props, context) => {
  const { act } = useBackend(context);
  const { material } = props;
  const {
    name,
    removable,
    sheets,
    ref,
  } = material;
  const [removeMaterials, setRemoveMaterials] = useSharedState(
    context, 'remove_mats_' + name, 1);
  if (removeMaterials > 1 && sheets < removeMaterials) {
    setRemoveMaterials(sheets || 1);
  }
  return (
    <>
      <NumberInput
        width="30px"
        animated
        value={removeMaterials}
        minValue={1}
        maxValue={sheets || 1}
        initial={1}
        onDrag={(e, val) => {
          const newVal = parseInt(val, 10);
          if (Number.isInteger(newVal)) {
            setRemoveMaterials(newVal);
          }
        }} />
      <Button
        icon="eject"
        disabled={!removable}
        onClick={() => act("remove_mat", {
          ref: ref,
          amount: removeMaterials,
        })} />
    </>
  );
};

const Materials = (props, context) => {
  const { data } = useBackend(context);
  const materials = data.materials || [];
  return (
    <Flex wrap>
      {materials.map(material => (
        <Flex.Item key={material.name} width="80px">
          <MaterialAmount
            name={material.name}
            amount={material.amount}
            formatsi />
          <Box mt={1} textAlign="center">
            <EjectMaterial material={material} />
          </Box>
        </Flex.Item>
      ))}
    </Flex>
  );
};

const MaterialAmount = (props, context) => {
  const {
    name,
    amount,
    formatsi,
    formatmoney,
    color,
    style,
  } = props;
  return (
    <Flex direction="column" textAlign="center">
      <Flex.Item>
        <Box
          className={classes([
            'sheetmaterials32x32',
            MATERIAL_KEYS[name],
          ])}
          style={style} />
      </Flex.Item>
      <Flex.Item color={color}>
        {formatsi && formatSiUnit(amount, 0)
          || formatmoney && formatMoney(amount)
          || amount}
      </Flex.Item>
    </Flex>
  );
};

const PartSets = (props, context) => {
  const { data } = useBackend(context);
  const partSets = data.partSets || [];
  const buildableParts = data.buildableParts || {};
  const [selectedPartTab, setSelectedPartTab] = useSharedState(
    context, 'part_tab', partSets.length ? buildableParts[0] : '');
  return partSets
    .filter(set => buildableParts[set])
    .map(set => (
      <Button
        key={set}
        fluid
        color="transparent"
        selected={set === selectedPartTab}
        onClick={() => setSelectedPartTab(set)}>
        {set}
      </Button>
    ));
};

const PartLists = (props, context) => {
  const { data } = useBackend(context);

  const getFirstValidPartSet = (sets => {
    for (let set of sets) {
      if (buildableParts[set]) {
        return set;
      }
    }
    return null;
  });

  const partSets = data.partSets || [];
  const buildableParts = data.buildableParts || [];

  const {
    queueMaterials,
    materials,
  } = props;

  const [
    selectedPartTab,
    setSelectedPartTab,
  ] = useSharedState(
    context,
    "part_tab",
    getFirstValidPartSet(partSets)
  );

  const [
    searchText,
    setSearchText,
  ] = useSharedState(context, "search_text", "");

  if (!selectedPartTab || !buildableParts[selectedPartTab]) {
    const validSet = getFirstValidPartSet(partSets);
    if (validSet) {
      setSelectedPartTab(validSet);
    }
    else {
      return;
    }
  }

  let partsList;
  // Build list of sub-categories if not using a search filter.
  if (!searchText) {
    partsList = { "Снаряжение": [] };
    buildableParts[selectedPartTab].forEach(part => {
      part["format"] = partCondFormat(materials, queueMaterials, part);
      if (!part.subCategory) {
        partsList["Снаряжение"].push(part);
        return;
      }
      if (!(part.subCategory in partsList)) {
        partsList[part.subCategory] = [];
      }
      partsList[part.subCategory].push(part);
    });
  }
  else {
    partsList = [];
    searchFilter(searchText, buildableParts).forEach(part => {
      part["format"] = partCondFormat(materials, queueMaterials, part);
      partsList.push(part);
    });
  }

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section fill>
          <Stack align="baseline">
            <Stack.Item>
              <Icon name="search" />
            </Stack.Item>
            <Stack.Item grow>
              <Input
                fluid
                placeholder="Искать..."
                onInput={(e, v) => setSearchText(v)} />
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill>
          {!!searchText && (
            <PartCategory
              name={"Результаты"}
              parts={partsList}
              forceShow
              placeholder="Нет подходящих элементов..." />
          ) || (
            Object.keys(partsList).map(category => (
              <PartCategory
                key={category}
                name={category}
                parts={partsList[category]} />
            ))
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const PartCategory = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    buildingPart,
  } = data;
  const {
    parts,
    name,
    forceShow,
    placeholder,
  } = props;
  const [
    displayMatCost,
  ] = useSharedState(context, 'display_mats', false);
  if (!forceShow && parts.length === 0) {
    return null;
  }
  return (
    <Section
      title={name}
      level={2}
      buttons={
        <Button
          disabled={!parts.length}
          color="good"
          content="Добавить всё"
          icon="plus-circle"
          onClick={() => act("add_queue_set", {
            part_list: parts.map(part => part.id),
          })} />
      }>
      {!parts.length && placeholder}
      {parts.map(part => (
        <Fragment key={part.name}>
          <Stack align="center">
            <Stack.Item>
              <Button
                disabled={(
                  buildingPart || part.format.textColor === COLOR_BAD
                )}
                color="good"
                icon="play"
                onClick={() => act("build_part", { id: part.id })} />
            </Stack.Item>
            <Stack.Item>
              <Button
                color="average"
                icon="plus-circle"
                onClick={() => act("add_queue_part", { id: part.id })} />
            </Stack.Item>
            <Stack.Item grow color={COLOR_KEYS[part.format.textColor]}>
              {part.name}
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="question-circle"
                tooltip={
                  'Время сборки: '
                  + part.printTime + 'с. '
                  + (part.desc || '')
                }
                tooltipPosition="left" />
            </Stack.Item>
          </Stack>
          {displayMatCost && (
            <Stack mb={2}>
              {Object.keys(part.cost).map(material => (
                <Stack.Item
                  key={material}
                  width="50px"
                  color={COLOR_KEYS[part.format[material].color]}>
                  <MaterialAmount
                    formatmoney
                    style={{
                      transform: 'scale(0.75) translate(0%, 10%)',
                    }}
                    name={material}
                    amount={part.cost[material]} />
                </Stack.Item>
              ))}
            </Stack>
          )}
        </Fragment>
      ))}
    </Section>
  );
};

const Queue = (props, context) => {
  const { act, data } = useBackend(context);
  const { isProcessingQueue } = data;
  const queue = data.queue || [];
  const {
    queueMaterials,
    missingMaterials,
    textColors,
  } = props;
  return (
    <Stack fill vertical>
      <Stack.Item grow>
        <Section
          fill
          scrollable
          title="Поток"
          buttons={(
            <>
              <Button.Confirm
                disabled={!queue.length}
                color="bad"
                icon="minus-circle"
                content="Очистить"
                onClick={() => act("clear_queue")} />
              {!!isProcessingQueue && (
                <Button
                  disabled={!queue.length}
                  content="Стоп"
                  icon="stop"
                  onClick={() => act("stop_queue")} />
              ) || (
                <Button
                  disabled={!queue.length}
                  content="Старт"
                  icon="play"
                  onClick={() => act("build_queue")} />
              )}
            </>
          )}>
          <Stack fill vertical>
            <Stack.Item>
              <BeingBuilt />
            </Stack.Item>
            <Stack.Item>
              <QueueList textColors={textColors} />
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
      {!!queue.length && (
        <Stack.Item>
          <Section title="Стоимость">
            <QueueMaterials
              queueMaterials={queueMaterials}
              missingMaterials={missingMaterials} />
          </Section>
        </Stack.Item>
      )}
    </Stack>
  );
};

const QueueMaterials = (props, context) => {
  const {
    queueMaterials,
    missingMaterials,
  } = props;
  return (
    <Stack wrap>
      {Object.keys(queueMaterials).map(material => (
        <Stack.Item key={material} textAlign="center">
          <MaterialAmount
            formatmoney
            name={material}
            amount={queueMaterials[material]} />
          {!!missingMaterials[material] && (
            <Box color="bad">
              {formatMoney(missingMaterials[material])}
            </Box>
          )}
        </Stack.Item>
      ))}
    </Stack>
  );
};

const QueueList = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    textColors,
  } = props;

  const queue = data.queue || [];

  if (!queue.length) {
    return (
      <>
        Ничего нет в потоке.
      </>
    );
  }

  return queue.map((part, index) => (
    <Stack key={part.name} wrap align="baseline">
      <Stack.Item>
        <Button
          icon="minus-circle"
          color="bad"
          onClick={() => act("del_queue_part", { index: index + 1 })} />
      </Stack.Item>
      <Stack.Item textColor={COLOR_KEYS[textColors[index]]}>
        {part.name}
      </Stack.Item>
    </Stack>
  ));
};

const BeingBuilt = (props, context) => {
  const { data } = useBackend(context);
  const {
    buildingPart,
    storedPart,
  } = data;

  if (storedPart) {
    const { name } = storedPart;
    return (
      <ProgressBar
        minValue={0}
        maxValue={1}
        value={1}
        color="average">
        <Stack>
          <Stack.Item grow>
            {name}
          </Stack.Item>
          <Stack.Item>
            Выход закрыт...
          </Stack.Item>
        </Stack>
      </ProgressBar>
    );
  }

  if (buildingPart) {
    const {
      name,
      duration,
      printTime,
    } = buildingPart;
    const timeLeft = Math.ceil(duration/10);
    return (
      <ProgressBar
        minValue={0}
        maxValue={printTime}
        value={duration}>
        <Stack>
          <Stack.Item grow>
            {name}
          </Stack.Item>
          <Stack.Item>
            {timeLeft >= 0 && (timeLeft + 'с') || 'Выдаём...'}
          </Stack.Item>
        </Stack>
      </ProgressBar>
    );
  }

  return null;
};
