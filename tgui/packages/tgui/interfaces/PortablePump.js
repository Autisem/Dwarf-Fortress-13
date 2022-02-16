import { useBackend } from '../backend';
import { Button, LabeledList, NumberInput, Section } from '../components';
import { Window } from '../layouts';
import { PortableBasicInfo } from './common/PortableAtmos';

export const PortablePump = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    direction,
    holding,
    target_pressure,
    default_pressure,
    min_pressure,
    max_pressure,
  } = data;
  return (
    <Window
      width={300}
      height={325}>
      <Window.Content>
        <PortableBasicInfo />
        <Section
          title="Помпа"
          buttons={(
            <Button
              icon={direction ? 'sign-in-alt' : 'sign-out-alt'}
              content={direction ? 'Вдув' : 'Выдув'}
              selected={direction}
              onClick={() => act('direction')} />
          )}>
          <LabeledList>
            <LabeledList.Item label="Выход">
              <NumberInput
                value={target_pressure}
                unit="кПа"
                width="75px"
                minValue={min_pressure}
                maxValue={max_pressure}
                step={10}
                onChange={(e, value) => act('pressure', {
                  pressure: value,
                })} />
            </LabeledList.Item>
            <LabeledList.Item label="Управление">
              <Button
                icon="minus"
                disabled={target_pressure === min_pressure}
                onClick={() => act('pressure', {
                  pressure: 'min',
                })} />
              <Button
                icon="sync"
                disabled={target_pressure === default_pressure}
                onClick={() => act('pressure', {
                  pressure: 'reset',
                })} />
              <Button
                icon="plus"
                disabled={target_pressure === max_pressure}
                onClick={() => act('pressure', {
                  pressure: 'max',
                })} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
