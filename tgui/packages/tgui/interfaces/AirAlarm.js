import { toFixed } from 'common/math';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';
import { Scrubber, Vent } from './common/AtmosControls';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

export const AirAlarm = (props, context) => {
  const { act, data } = useBackend(context);
  const locked = data.locked && !data.siliconUser;
  return (
    <Window
      width={440}
      height={!locked ? 515 : 285}>
      <Window.Content scrollable>
        <InterfaceLockNoticeBox />
        <AirAlarmStatus />
        {!locked && (
          <AirAlarmControl />
        )}
      </Window.Content>
    </Window>
  );
};

const AirAlarmStatus = (props, context) => {
  const { data } = useBackend(context);
  const entries = (data.environment_data || [])
    .filter(entry => entry.value >= 0.01);
  const dangerMap = {
    0: {
      color: 'good',
      localStatusText: 'Оптимально',
    },
    1: {
      color: 'average',
      localStatusText: 'Нестабильно',
    },
    2: {
      color: 'bad',
      localStatusText: 'Опасно (Требуется Диагностика)',
    },
  };
  const localStatus = dangerMap[data.danger_level] || dangerMap[0];
  return (
    <Section title="Состояние атмосферы">
      <LabeledList>
        {entries.length > 0 && (
          <>
            {entries.map(entry => {
              const status = dangerMap[entry.danger_level] || dangerMap[0];
              return (
                <LabeledList.Item
                  key={entry.name}
                  label={entry.name}
                  color={status.color}>
                  {toFixed(entry.value, 2)}{entry.unit}
                </LabeledList.Item>
              );
            })}
            <LabeledList.Item
              label="Местный статус"
              color={localStatus.color}>
              {localStatus.localStatusText}
            </LabeledList.Item>
            <LabeledList.Item
              label="Состояние зоны"
              color={data.atmos_alarm || data.fire_alarm ? 'bad' : 'good'}>
              {data.atmos_alarm && 'Атмосферная тревога'
                || data.fire_alarm && 'Пожарная тревога'
                || 'Номинально'}
            </LabeledList.Item>
          </>
        ) || (
          <LabeledList.Item
            label="Внимание"
            color="bad">
            Невозможно получить воздух для анализа.
          </LabeledList.Item>
        )}
        {!!data.emagged && (
          <LabeledList.Item
            label="Внимание"
            color="bad">
            Протоколы безопасности нарушены. Устройство может
            работать неправильно.
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

const AIR_ALARM_ROUTES = {
  home: {
    title: 'Контроль атмосферы',
    component: () => AirAlarmControlHome,
  },
  vents: {
    title: 'Управление вентиляцией',
    component: () => AirAlarmControlVents,
  },
  scrubbers: {
    title: 'Управление фильтрами',
    component: () => AirAlarmControlScrubbers,
  },
  modes: {
    title: 'Режим работы',
    component: () => AirAlarmControlModes,
  },
  thresholds: {
    title: 'Пороги тревог',
    component: () => AirAlarmControlThresholds,
  },
};

const AirAlarmControl = (props, context) => {
  const [screen, setScreen] = useLocalState(context, 'screen');
  const route = AIR_ALARM_ROUTES[screen] || AIR_ALARM_ROUTES.home;
  const Component = route.component();
  return (
    <Section
      title={route.title}
      buttons={screen && (
        <Button
          icon="arrow-left"
          content="Назад"
          onClick={() => setScreen()} />
      )}>
      <Component />
    </Section>
  );
};


//  Home screen
// --------------------------------------------------------

const AirAlarmControlHome = (props, context) => {
  const { act, data } = useBackend(context);
  const [screen, setScreen] = useLocalState(context, 'screen');
  const {
    mode,
    atmos_alarm,
  } = data;
  return (
    <>
      <Button
        icon={atmos_alarm
          ? 'exclamation-triangle'
          : 'exclamation'}
        color={atmos_alarm && 'caution'}
        content="Атмосферная тревога"
        onClick={() => act(atmos_alarm ? 'reset' : 'alarm')} />
      <Box mt={1} />
      <Button
        icon={mode === 3
          ? 'exclamation-triangle'
          : 'exclamation'}
        color={mode === 3 && 'danger'}
        content="Паническая откачка"
        onClick={() => act('mode', {
          mode: mode === 3 ? 1 : 3,
        })} />
      <Box mt={2} />
      <Button
        icon="sign-out-alt"
        content="Управление вентиляцией"
        onClick={() => setScreen('vents')} />
      <Box mt={1} />
      <Button
        icon="filter"
        content="Управление фильтрами"
        onClick={() => setScreen('scrubbers')} />
      <Box mt={1} />
      <Button
        icon="cog"
        content="Режим работы"
        onClick={() => setScreen('modes')} />
      <Box mt={1} />
      <Button
        icon="chart-bar"
        content="Пороги тревог"
        onClick={() => setScreen('thresholds')} />
    </>
  );
};


//  Vents
// --------------------------------------------------------

const AirAlarmControlVents = (props, context) => {
  const { data } = useBackend(context);
  const { vents } = data;
  if (!vents || vents.length === 0) {
    return 'Нечего показывать';
  }
  return vents.map(vent => (
    <Vent
      key={vent.id_tag}
      vent={vent} />
  ));
};

//  Scrubbers
// --------------------------------------------------------

const AirAlarmControlScrubbers = (props, context) => {
  const { data } = useBackend(context);
  const { scrubbers } = data;
  if (!scrubbers || scrubbers.length === 0) {
    return 'Нечего показывать';
  }
  return scrubbers.map(scrubber => (
    <Scrubber
      key={scrubber.id_tag}
      scrubber={scrubber} />
  ));
};

//  Modes
// --------------------------------------------------------

const AirAlarmControlModes = (props, context) => {
  const { act, data } = useBackend(context);
  const { modes } = data;
  if (!modes || modes.length === 0) {
    return 'Нечего показывать';
  }
  return modes.map(mode => (
    <Fragment key={mode.mode}>
      <Button
        icon={mode.selected ? 'check-square-o' : 'square-o'}
        selected={mode.selected}
        color={mode.selected && mode.danger && 'danger'}
        content={mode.name}
        onClick={() => act('mode', { mode: mode.mode })} />
      <Box mt={1} />
    </Fragment>
  ));
};


//  Thresholds
// --------------------------------------------------------

const AirAlarmControlThresholds = (props, context) => {
  const { act, data } = useBackend(context);
  const { thresholds } = data;
  return (
    <table
      className="LabeledList"
      style={{ width: '100%' }}>
      <thead>
        <tr>
          <td />
          <td className="color-bad">hazard_min</td>
          <td className="color-average">warning_min</td>
          <td className="color-average">warning_max</td>
          <td className="color-bad">hazard_max</td>
        </tr>
      </thead>
      <tbody>
        {thresholds.map(threshold => (
          <tr key={threshold.name}>
            <td className="LabeledList__label">{threshold.name}</td>
            {threshold.settings.map(setting => (
              <td key={setting.val}>
                <Button
                  content={toFixed(setting.selected, 2)}
                  onClick={() => act('threshold', {
                    env: setting.env,
                    var: setting.val,
                  })} />
              </td>
            ))}
          </tr>
        ))}
      </tbody>
    </table>
  );
};
