import { toFixed } from 'common/math';
import { useBackend } from '../backend';
import { Box, Button, Flex, Icon, Knob, LabeledControls, LabeledList, RoundGauge, Section, Tooltip } from '../components';
import { formatSiUnit } from '../format';
import { Window } from '../layouts';

const formatPressure = value => {
  if (value < 10000) {
    return toFixed(value) + ' кПа';
  }
  return formatSiUnit(value * 1000, 1, 'Па');
};

export const Canister = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    portConnected,
    tankPressure,
    releasePressure,
    defaultReleasePressure,
    minReleasePressure,
    maxReleasePressure,
    pressureLimit,
    valveOpen,
    isPrototype,
    hasHoldingTank,
    holdingTank,
    holdingTankLeakPressure,
    holdingTankFragPressure,
    restricted,
  } = data;
  return (
    <Window
      width={300}
      height={275}>
      <Window.Content>
        <Flex direction="column" height="100%">
          <Flex.Item mb={1}>
            <Section
              title="Канистра"
              buttons={(
                <>
                  {!!isPrototype && (
                    <Button
                      mr={1}
                      icon={restricted ? 'lock' : 'unlock'}
                      color="caution"
                      onClick={() => act('restricted')} />
                  )}
                  <Button
                    icon="pencil-alt"
                    content="Переименовать"
                    onClick={() => act('relabel')} />
                </>
              )}>
              <LabeledControls>
                <LabeledControls.Item
                  minWidth="66px"
                  label="Давление">
                  <RoundGauge
                    size={1.75}
                    value={tankPressure}
                    minValue={0}
                    maxValue={pressureLimit}
                    alertAfter={pressureLimit * 0.70}
                    ranges={{
                      "good": [0, pressureLimit * 0.70],
                      "average": [pressureLimit * 0.70, pressureLimit * 0.85],
                      "bad": [pressureLimit * 0.85, pressureLimit],
                    }}
                    format={formatPressure} />
                </LabeledControls.Item>
                <LabeledControls.Item label="Регулятор">
                  <Box
                    position="relative"
                    left="-8px">
                    <Knob
                      size={1.25}
                      color={!!valveOpen && 'yellow'}
                      value={releasePressure}
                      unit="kPa"
                      minValue={minReleasePressure}
                      maxValue={maxReleasePressure}
                      step={5}
                      stepPixelSize={1}
                      onDrag={(e, value) => act('pressure', {
                        pressure: value,
                      })} />
                    <Button
                      fluid
                      position="absolute"
                      top="-2px"
                      right="-24px"
                      color="transparent"
                      icon="fast-forward"
                      onClick={() => act('pressure', {
                        pressure: maxReleasePressure,
                      })} />
                    <Button
                      fluid
                      position="absolute"
                      top="20px"
                      right="-24px"
                      color="transparent"
                      icon="undo"
                      onClick={() => act('pressure', {
                        pressure: defaultReleasePressure,
                      })} />
                  </Box>
                </LabeledControls.Item>
                <LabeledControls.Item label="Вентиль">
                  <Button
                    my={0.5}
                    width="55px"
                    lineHeight={2}
                    fontSize="11px"
                    color={valveOpen
                      ? (hasHoldingTank ? 'caution' : 'danger')
                      : null}
                    content={valveOpen ? 'Открыт' : 'Закрыт'}
                    onClick={() => act('valve')} />
                </LabeledControls.Item>
                <LabeledControls.Item
                  mr={1}
                  label="Port">
                  <Tooltip
                    content={portConnected
                      ? 'Подключен'
                      : 'Отключен'}
                    position="top"
                  >
                    <Box position="relative">
                      <Icon
                        size={1.25}
                        name={portConnected ? 'plug' : 'times'}
                        color={portConnected ? 'good' : 'bad'} />
                    </Box>
                  </Tooltip>
                </LabeledControls.Item>
              </LabeledControls>
            </Section>
          </Flex.Item>
          <Flex.Item grow={1}>
            <Section
              height="100%"
              title="Бак"
              buttons={!!hasHoldingTank && (
                <Button
                  icon="eject"
                  color={valveOpen && 'danger'}
                  content="Изъять"
                  onClick={() => act('eject')} />
              )}>
              {!!hasHoldingTank && (
                <LabeledList>
                  <LabeledList.Item label="Метка">
                    {holdingTank.name}
                  </LabeledList.Item>
                  <LabeledList.Item label="Давление">
                    <RoundGauge
                      value={holdingTank.tankPressure}
                      minValue={0}
                      maxValue={holdingTankFragPressure * 1.15}
                      alertAfter={holdingTankLeakPressure}
                      ranges={{
                        "good": [0, holdingTankLeakPressure],
                        "average": [holdingTankLeakPressure, holdingTankFragPressure],
                        "bad": [holdingTankFragPressure, holdingTankFragPressure * 1.15],
                      }}
                      format={formatPressure}
                      size={1.75} />
                  </LabeledList.Item>
                </LabeledList>
              )}
              {!hasHoldingTank && (
                <Box color="average">
                  Внутри нет бака
                </Box>
              )}
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
