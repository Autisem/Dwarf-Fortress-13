import { map } from 'common/collections';
import { toFixed } from 'common/math';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NumberInput, Section } from '../components';
import { RADIO_CHANNELS } from '../constants';
import { Window } from '../layouts';

export const Radio = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    freqlock,
    frequency,
    minFrequency,
    maxFrequency,
    listening,
    broadcasting,
    command,
    useCommand,
    subspace,
    subspaceSwitchable,
  } = data;
  const tunedChannel = RADIO_CHANNELS
    .find(channel => channel.freq === frequency);
  const channels = map((value, key) => ({
    name: key,
    status: !!value,
  }))(data.channels);
  // Calculate window height
  let height = 111;
  if (subspace) {
    if (channels.length > 0) {
      height += channels.length * 23 + 6;
    }
    else {
      height += 24;
    }
  }
  return (
    <Window
      width={360}
      height={height}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Частота">
              {freqlock && (
                <Box inline color="light-gray">
                  {toFixed(frequency / 10, 1) + ' kHz'}
                </Box>
              ) || (
                <NumberInput
                  animate
                  unit="kHz"
                  step={0.2}
                  stepPixelSize={10}
                  minValue={minFrequency / 10}
                  maxValue={maxFrequency / 10}
                  value={frequency / 10}
                  format={value => toFixed(value, 1)}
                  onDrag={(e, value) => act('frequency', {
                    adjust: (value - frequency / 10),
                  })} />
              )}
              {tunedChannel && (
                <Box inline color={tunedChannel.color} ml={2}>
                  [{tunedChannel.name}]
                </Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Звук">
              <Button
                textAlign="center"
                width="37px"
                icon={listening ? 'volume-up' : 'volume-mute'}
                selected={listening}
                onClick={() => act('listen')} />
              <Button
                textAlign="center"
                width="37px"
                icon={broadcasting ? 'microphone' : 'microphone-slash'}
                selected={broadcasting}
                onClick={() => act('broadcast')} />
              {!!command && (
                <Button
                  ml={1}
                  icon="bullhorn"
                  selected={useCommand}
                  content={`Приоритет ${useCommand ? 'ВКЛ' : 'ВЫКЛ'}`}
                  onClick={() => act('command')} />
              )}
              {!!subspaceSwitchable && (
                <Button
                  ml={1}
                  icon="bullhorn"
                  selected={subspace}
                  content={`Subspace Tx ${subspace ? 'ВКЛ' : 'ВЫКЛ'}`}
                  onClick={() => act('subspace')} />
              )}
            </LabeledList.Item>
            {!!subspace && (
              <LabeledList.Item label="Каналы">
                {channels.length === 0 && (
                  <Box inline color="bad">
                    Нет установленных ключей шифрования.
                  </Box>
                )}
                {channels.map(channel => (
                  <Box key={channel.name}>
                    <Button
                      icon={channel.status ? 'check-square-o' : 'square-o'}
                      selected={channel.status}
                      content={channel.name}
                      onClick={() => act('channel', {
                        channel: channel.name,
                      })} />
                  </Box>
                ))}
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
