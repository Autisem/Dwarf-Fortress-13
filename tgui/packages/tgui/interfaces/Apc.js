import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, ProgressBar, Section } from '../components';
import { Window } from '../layouts';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

export const Apc = (props, context) => {
  return (
    <Window
      width={455}
      height={490}>
      <Window.Content scrollable>
        <ApcContent />
      </Window.Content>
    </Window>
  );
};

const powerStatusMap = {
  2: {
    color: 'good',
    externalPowerText: 'Внешнее питание',
    chargingText: 'Полностью заряжен',
  },
  1: {
    color: 'average',
    externalPowerText: 'Малое внешнее питание',
    chargingText: 'Зарядка',
  },
  0: {
    color: 'bad',
    externalPowerText: 'Нет внешнего питания',
    chargingText: 'Не заряжается',
  },
};

const malfMap = {
  1: {
    icon: 'terminal',
    content: 'Переписать программу',
    action: 'hack',
  },
  2: {
    icon: 'caret-square-down',
    content: 'Переместить ядро сюда',
    action: 'occupy',
  },
  3: {
    icon: 'caret-square-left',
    content: 'Вернуться в основное ядро',
    action: 'deoccupy',
  },
  4: {
    icon: 'caret-square-down',
    content: 'Переместить ядро сюда',
    action: 'occupy',
  },
};

const ApcContent = (props, context) => {
  const { act, data } = useBackend(context);
  const locked = data.locked && !data.siliconUser;
  const externalPowerStatus = powerStatusMap[data.externalPower]
    || powerStatusMap[0];
  const chargingStatus = powerStatusMap[data.chargingStatus]
    || powerStatusMap[0];
  const channelArray = data.powerChannels || [];
  const malfStatus = malfMap[data.malfStatus] || malfMap[0];
  const adjustedCellChange = data.powerCellStatus / 100;
  if (data.failTime > 0) {
    return (
      <NoticeBox>
        <b><h3>СИСТЕМНАЯ ОШИБКА</h3></b>
        <i>
          Обнаружена проблема с регуляторами I/O!
          Ожидается перезагрузка системы...
        </i>
        <br />
        Автоматическая перезагрузка через {data.failTime} секунд...
        <Button
          icon="sync"
          content="Перезагрузить сейчас"
          onClick={() => act('reboot')} />
      </NoticeBox>
    );
  }
  return (
    <>
      <InterfaceLockNoticeBox />
      <Section title="Состояние энергии">
        <LabeledList>
          <LabeledList.Item
            label="Основное питание"
            color={externalPowerStatus.color}
            buttons={(
              <Button
                icon={data.isOperating ? 'power-off' : 'times'}
                content={data.isOperating ? 'Вкл' : 'Выкл'}
                selected={data.isOperating && !locked}
                disabled={locked}
                onClick={() => act('breaker')} />
            )}>
            [ {externalPowerStatus.externalPowerText} ]
          </LabeledList.Item>
          <LabeledList.Item label="Аккумулятор">
            <ProgressBar
              color="good"
              value={adjustedCellChange} />
          </LabeledList.Item>
          <LabeledList.Item
            label="Режим зарядки"
            color={chargingStatus.color}
            buttons={(
              <Button
                icon={data.chargeMode ? 'sync' : 'close'}
                content={data.chargeMode ? 'Авто' : 'Выкл'}
                disabled={locked}
                onClick={() => act('charge')} />
            )}>
            [ {chargingStatus.chargingText} ]
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Энергоканалы">
        <LabeledList>
          {channelArray.map(channel => {
            const { topicParams } = channel;
            return (
              <LabeledList.Item
                key={channel.title}
                label={channel.title}
                buttons={(
                  <>
                    <Box inline mx={2}
                      color={channel.status >= 2 ? 'good' : 'bad'}>
                      {channel.status >= 2 ? 'Вкл' : 'Выкл'}
                    </Box>
                    <Button
                      icon="sync"
                      content="Авто"
                      selected={!locked && (
                        channel.status === 1 || channel.status === 3
                      )}
                      disabled={locked}
                      onClick={() => act('channel', topicParams.auto)} />
                    <Button
                      icon="power-off"
                      content="Вкл"
                      selected={!locked && channel.status === 2}
                      disabled={locked}
                      onClick={() => act('channel', topicParams.on)} />
                    <Button
                      icon="times"
                      content="Выкл"
                      selected={!locked && channel.status === 0}
                      disabled={locked}
                      onClick={() => act('channel', topicParams.off)} />
                  </>
                )}>
                {channel.powerLoad}
              </LabeledList.Item>
            );
          })}
          <LabeledList.Item label="Общая нагрузка">
            <b>{data.totalLoad}</b>
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="Остальное"
        buttons={!!data.siliconUser && (
          <>
            {!!data.malfStatus && (
              <Button
                icon={malfStatus.icon}
                content={malfStatus.content}
                color="bad"
                onClick={() => act(malfStatus.action)} />
            )}
            <Button
              icon="lightbulb-o"
              content="Перегрузить"
              onClick={() => act('overload')} />
          </>
        )}>
        <LabeledList>
          <LabeledList.Item
            label="Блокировка крышки"
            buttons={(
              <Button
                icon={data.coverLocked ? 'lock' : 'unlock'}
                content={data.coverLocked ? 'Включена' : 'Выключена'}
                disabled={locked}
                onClick={() => act('cover')} />
            )} />
          <LabeledList.Item
            label="Аварийное освещение"
            buttons={(
              <Button
                icon="lightbulb-o"
                content={data.emergencyLights ? 'Включено' : 'Отключено'}
                disabled={locked}
                onClick={() => act('emergency_lighting')} />
            )} />
          <LabeledList.Item
            label="Ночная смена освещения"
            buttons={(
              <Button
                icon="lightbulb-o"
                content={data.nightshiftLights ? 'Включена' : 'Отключена'}
                onClick={() => act('toggle_nightshift')} />
            )} />
        </LabeledList>
      </Section>
    </>
  );
};
