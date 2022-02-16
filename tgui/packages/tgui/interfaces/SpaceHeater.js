import { useBackend } from '../backend';
import { Box, Button, LabeledList, NumberInput, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const SpaceHeater = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={400}
      height={305}>
      <Window.Content>
        <Section
          title="Энергия"
          buttons={(
            <>
              {!!data.chemHacked && (
                <Button
                  icon="eject"
                  content="Eject beaker"
                  disabled={!data.beaker}
                  onClick={() => act('ejectBeaker')} />
              )}
              <Button
                icon="eject"
                content="Изъять аккумулятор"
                disabled={!data.hasPowercell || !data.open}
                onClick={() => act('eject')} />
              <Button
                icon={data.on ? 'power-off' : 'times'}
                content={data.on ? 'Вкл' : 'Выкл'}
                selected={data.on}
                disabled={!data.hasPowercell}
                onClick={() => act('power')} />
            </>
          )}>
          <LabeledList>
            <LabeledList.Item
              label="Аккумулятор"
              color={!data.hasPowercell && 'bad'}>
              {data.hasPowercell && (
                <ProgressBar
                  value={data.powerLevel / 100}
                  content={data.powerLevel + '%'}
                  ranges={{
                    good: [0.6, Infinity],
                    average: [0.3, 0.6],
                    bad: [-Infinity, 0.3],
                  }}>
                  {data.powerLevel + '%'}
                </ProgressBar>
              ) || 'None'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Термостат">
          <LabeledList>
            <LabeledList.Item label="Температура">
              <Box
                fontSize="18px"
                color={Math.abs(data.targetTemp - data.currentTemp) > 50
                  ? 'bad'
                  : Math.abs(data.targetTemp - data.currentTemp) > 20
                    ? 'average'
                    : 'good'}>
                {data.currentTemp}°C
              </Box>
            </LabeledList.Item>
            <LabeledList.Item label="Целевая">
              {data.open && (
                <NumberInput
                  animated
                  value={parseFloat(data.targetTemp)}
                  width="65px"
                  unit="°C"
                  minValue={data.minTemp}
                  maxValue={data.maxTemp}
                  onChange={(e, value) => act('target', {
                    target: value,
                  })} />
              ) || (
                data.targetTemp + '°C'
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Режим">
              {!data.open && 'Авто' || (
                <>
                  <Button
                    icon="thermometer-half"
                    content="Авто"
                    selected={data.mode === 'auto'}
                    onClick={() => act('mode', {
                      mode: "auto",
                    })} />
                  <Button
                    icon="fire-alt"
                    content="Нагрев"
                    selected={data.mode === 'heat'}
                    onClick={() => act('mode', {
                      mode: "heat",
                    })} />
                  <Button
                    icon="fan"
                    content="Охлаждение"
                    selected={data.mode === 'cool'}
                    onClick={() => act('mode', {
                      mode: 'cool',
                    })} />
                </>
              )}
            </LabeledList.Item>
            <LabeledList.Divider />
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
