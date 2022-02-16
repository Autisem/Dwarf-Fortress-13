import { capitalize } from 'common/string';
import { useBackend, useLocalState } from '../backend';
import { BlockQuote, Box, Button, NumberInput, Section, Table } from '../components';
import { Window } from '../layouts';

export const OreRedemptionMachine = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    unclaimedPoints,
    materials,
    alloys,
    diskDesigns,
    hasDisk,
  } = data;
  return (
    <Window
      title="Ore Redemption Machine"
      width={440}
      height={550}>
      <Window.Content scrollable>
        <Section>
          <BlockQuote mb={1}>
            Эта машина принимает только руду.<br />
            Гибтонит и шлак не принимаются.
          </BlockQuote>
          <Box>
            <Box inline color="label" mr={1}>
              Невостребованные очки:
            </Box>
            {unclaimedPoints}
            <Button
              ml={2}
              content="Забрать"
              disabled={unclaimedPoints === 0}
              onClick={() => act('Claim')} />
          </Box>
        </Section>
        <Section>
          {hasDisk && (
            <>
              <Box mb={1}>
                <Button
                  icon="eject"
                  content="Изъять диск"
                  onClick={() => act('diskEject')} />
              </Box>
              <Table>
                {diskDesigns.map(design => (
                  <Table.Row key={design.index}>
                    <Table.Cell>
                      Файл {design.index}: {design.name}
                    </Table.Cell>
                    <Table.Cell collapsing>
                      <Button
                        disabled={!design.canupload}
                        content="Загрузить"
                        onClick={() => act('diskUpload', {
                          design: design.index,
                        })} />
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </>
          ) || (
            <Button
              icon="save"
              content="Вставить диск"
              onClick={() => act('diskInsert')} />
          )}
        </Section>
        <Section title="Материалы">
          <Table>
            {materials.map(material => (
              <MaterialRow
                key={material.id}
                material={material}
                onRelease={amount => act('Release', {
                  id: material.id,
                  sheets: amount,
                })} />
            ))}
          </Table>
        </Section>
        <Section title="Сплавы">
          <Table>
            {alloys.map(material => (
              <MaterialRow
                key={material.id}
                material={material}
                onRelease={amount => act('Smelt', {
                  id: material.id,
                  sheets: amount,
                })} />
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};


const MaterialRow = (props, context) => {
  const { material, onRelease } = props;

  const [
    amount,
    setAmount,
  ] = useLocalState(context, "amount" + material.name, 1);

  const amountAvailable = Math.floor(material.amount);
  return (
    <Table.Row minHeight="24px">
      <Table.Cell>
        {capitalize(material.name)}
      </Table.Cell>
      <Table.Cell collapsing textAlign="right">
        <Box mr={2} color="label" inline>
          {material.value && material.value + ' кр'}
        </Box>
      </Table.Cell>
      <Table.Cell collapsing textAlign="right">
        <Box mr={2} color="label" inline>
          {amountAvailable} листов
        </Box>
      </Table.Cell>
      <Table.Cell collapsing>
        <NumberInput
          width="32px"
          step={1}
          stepPixelSize={5}
          minValue={1}
          maxValue={50}
          value={amount}
          onChange={(e, value) => setAmount(value)} />
        <Button
          disabled={amountAvailable < 1}
          content="Выдать"
          onClick={() => onRelease(amount)} />
      </Table.Cell>
    </Table.Row>
  );
};
