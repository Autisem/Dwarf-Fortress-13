import { useBackend } from '../backend';
import { Button, Section, LabeledList } from '../components';
import { Window } from '../layouts';

export const SoundPanelSettings = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    adminhelp,
    midi,
    ambience,
    lobby,
    instruments,
    ship_ambience,
    prayers,
    announcements,
    endofround,
    jukebox,
  } = data;
  return (
    <Window
      width={250}
      height={430}
      title="Sound settings">
      <Window.Content>
        <Section title="Main">
          <Button
            icon={midi ? 'volume-up' : 'volume-mute'}
            color={midi ? 'green' : 'transparent'}
            content="Admin midis"
            fluid
            onClick={() => act('midi')} />
          <Button
            icon={lobby ? 'volume-up' : 'volume-mute'}
            color={lobby ? 'green' : 'transparent'}
            content="Lobby music"
            fluid
            onClick={() => act('lobby')} />
          <Button
            icon={instruments ? 'volume-up' : 'volume-mute'}
            color={instruments ? 'green' : 'transparent'}
            content="Music instruments"
            fluid
            onClick={() => act('instruments')} />
          <Button
            icon={announcements ? 'volume-up' : 'volume-mute'}
            color={announcements ? 'green' : 'transparent'}
            content="Announcements"
            fluid
            onClick={() => act('announcements')} />
          <Button
            icon={endofround ? 'volume-up' : 'volume-mute'}
            color={endofround ? 'green' : 'transparent'}
            content="Endround sound"
            fluid
            onClick={() => act('endofround')} />
          <Button
            icon={jukebox ? 'volume-up' : 'volume-mute'}
            color={jukebox ? 'green' : 'transparent'}
            content="Jukebox"
            fluid
            onClick={() => act('jukebox')} />
          <Button
            icon={ambience ? 'volume-up' : 'volume-mute'}
            color={ambience ? 'green' : 'transparent'}
            content="Ambience"
            fluid
            onClick={() => act('ambience')} />
          <Button
            icon={ship_ambience ? 'volume-up' : 'volume-mute'}
            color={ship_ambience ? 'green' : 'transparent'}
            content="Ship Ambience"
            fluid
            onClick={() => act('ship_ambience')} />
          <Button
            icon="wrench"
            content="Battletension Settings"
            fluid
            onClick={() => act('bt_customize')} />
          <Button
            icon="play"
            content="Next Battletension"
            fluid
            onClick={() => act('switch_track')} />
        </Section>
        <Section title="Admin">
          <Button
            icon={adminhelp ? 'volume-up' : 'volume-mute'}
            color={adminhelp ? 'green' : 'transparent'}
            content="Ahelps"
            fluid
            onClick={() => act('adminhelp')} />
          <Button
            icon={prayers ? 'volume-up' : 'volume-mute'}
            color={prayers ? 'green' : 'transparent'}
            content="Prayers"
            fluid
            onClick={() => act('prayers')} />
        </Section>
      </Window.Content>
    </Window>
  );
};
