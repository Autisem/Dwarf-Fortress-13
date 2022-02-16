import { useBackend, useSharedState } from '../backend';
import { AnimatedNumber, Box, Button, Flex, LabeledList, Section, Table, Tabs } from '../components';
import { formatMoney } from '../format';
import { Window } from '../layouts';

export const Cargo = (props, context) => {
  return (
    <Window
      width={780}
      height={750}>
      <Window.Content scrollable>
        <CargoContent />
      </Window.Content>
    </Window>
  );
};

export const CargoContent = (props, context) => {
  const { act, data } = useBackend(context);
  const [tab, setTab] = useSharedState(context, 'tab', 'catalog');
  const {
    requestonly,
  } = data;
  const cart = data.cart || [];
  const requests = data.requests || [];
  return (
    <Box>
      <CargoStatus />
      <Section fitted>
        <Tabs>
          <Tabs.Tab
            icon="list"
            selected={tab === 'catalog'}
            onClick={() => setTab('catalog')}>
            Каталог
          </Tabs.Tab>
          <Tabs.Tab
            icon="envelope"
            textColor={tab !== 'requests'
              && requests.length > 0
              && 'yellow'}
            selected={tab === 'requests'}
            onClick={() => setTab('requests')}>
            Запросы ({requests.length})
          </Tabs.Tab>
          {!requestonly && (
            <Tabs.Tab
              icon="shopping-cart"
              textColor={tab !== 'cart'
                && cart.length > 0
                && 'yellow'}
              selected={tab === 'cart'}
              onClick={() => setTab('cart')}>
              Покупка ({cart.length})
            </Tabs.Tab>
          )}
        </Tabs>
      </Section>
      {tab === 'catalog' && (
        <CargoCatalog />
      )}
      {tab === 'requests' && (
        <CargoRequests />
      )}
      {tab === 'cart' && (
        <CargoCart />
      )}
    </Box>
  );
};

const CargoStatus = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    grocery,
    away,
    docked,
    loan,
    loan_dispatched,
    location,
    message,
    points,
    requestonly,
    can_send,
  } = data;
  return (
    <Section
      title="Снабжение"
      buttons={(
        <Box inline bold>
          <AnimatedNumber
            value={points}
            format={value => formatMoney(value)} />
          {' кредитов'}
        </Box>
      )}>
      <LabeledList>
        <LabeledList.Item label="Шаттл">
          {docked && !requestonly && can_send &&(
            <Button
              color={grocery && "orange" || "green"}
              content={location}
              tooltip={grocery && "Повар сделал заказ и ожидает товар." || ""}
              tooltipPosition="right"
              onClick={() => act('send')} />
          ) || location}
        </LabeledList.Item>
        <LabeledList.Item label="Сообщение ЦК">
          {message}
        </LabeledList.Item>
        {!!loan && !requestonly && (
          <LabeledList.Item label="Ссуда">
            {!loan_dispatched && (
              <Button
                content="Передать шаттл"
                disabled={!(away && docked)}
                onClick={() => act('loan')} />
            ) || (
              <Box color="bad">
                Передано на ЦК
              </Box>
            )}
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

export const CargoCatalog = (props, context) => {
  const { express } = props;
  const { act, data } = useBackend(context);
  const {
    self_paid,
    app_cost,
  } = data;
  const supplies = Object.values(data.supplies);
  const [
    activeSupplyName,
    setActiveSupplyName,
  ] = useSharedState(context, 'supply', supplies[0]?.name);
  const activeSupply = supplies.find(supply => {
    return supply.name === activeSupplyName;
  });
  return (
    <Section
      title="Каталог"
      buttons={!express && (
        <>
          <CargoCartButtons />
          <Button.Checkbox
            ml={2}
            content="За мой счёт"
            checked={self_paid}
            onClick={() => act('toggleprivate')} />
        </>
      )}>
      <Flex>
        <Flex.Item ml={-1} mr={2}>
          <Tabs vertical>
            {supplies.map(supply => (
              <Tabs.Tab
                key={supply.name}
                selected={supply.name === activeSupplyName}
                onClick={() => setActiveSupplyName(supply.name)}>
                {supply.name} ({supply.packs.length})
              </Tabs.Tab>
            ))}
          </Tabs>
        </Flex.Item>
        <Flex.Item grow={1} basis={0}>
          <Table>
            {activeSupply?.packs.map(pack => {
              const tags = [];
              if (pack.small_item) {
                tags.push('Небольшой');
              }
              if (pack.access) {
                tags.push('Защищённый');
              }
              return (
                <Table.Row
                  key={pack.name}
                  minHeight="24px"
                  className="candystripe">
                  <Table.Cell>
                    {pack.name}
                  </Table.Cell>
                  <Table.Cell
                    collapsing
                    color="label"
                    textAlign="right">
                    {tags.join(', ')}
                  </Table.Cell>
                  <Table.Cell
                    collapsing
                    textAlign="right">
                    <Button
                      fluid
                      tooltip={pack.desc}
                      tooltipPosition="left"
                      onClick={() => act('add', {
                        id: pack.id,
                      })}>
                      {formatMoney((self_paid && !pack.goody) || app_cost
                        ? Math.round(pack.cost * 1.1)
                        : pack.cost)}
                      {' кр'}
                    </Button>
                  </Table.Cell>
                </Table.Row>
              );
            })}
          </Table>
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const CargoRequests = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    requestonly,
    can_send,
    can_approve_requests,
  } = data;
  const requests = data.requests || [];
  // Labeled list reimplementation to squeeze extra columns out of it
  return (
    <Section
      title="Активные запросы"
      buttons={!requestonly && (
        <Button
          icon="times"
          content="Очистить"
          color="transparent"
          onClick={() => act('denyall')} />
      )}>
      {requests.length === 0 && (
        <Box color="good">
          Нет запросов
        </Box>
      )}
      {requests.length > 0 && (
        <Table>
          {requests.map(request => (
            <Table.Row
              key={request.id}
              className="candystripe">
              <Table.Cell collapsing color="label">
                #{request.id}
              </Table.Cell>
              <Table.Cell>
                {request.object}
              </Table.Cell>
              <Table.Cell>
                <b>{request.orderer}</b>
              </Table.Cell>
              <Table.Cell width="25%">
                <i>{request.reason}</i>
              </Table.Cell>
              <Table.Cell collapsing textAlign="right">
                {formatMoney(request.cost)} кредитов
              </Table.Cell>
              {(!requestonly || can_send)&& can_approve_requests &&(
                <Table.Cell collapsing>
                  <Button
                    icon="check"
                    color="good"
                    onClick={() => act('approve', {
                      id: request.id,
                    })} />
                  <Button
                    icon="times"
                    color="bad"
                    onClick={() => act('deny', {
                      id: request.id,
                    })} />
                </Table.Cell>
              )}
            </Table.Row>
          ))}
        </Table>
      )}
    </Section>
  );
};

const CargoCartButtons = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    requestonly,
    can_send,
    can_approve_requests,
  } = data;
  const cart = data.cart || [];
  const total = cart.reduce((total, entry) => total + entry.cost, 0);
  if (requestonly || !can_send || !can_approve_requests) {
    return null;
  }
  return (
    <>
      <Box inline mx={1}>
        {cart.length === 0 && 'Корзина пуста'}
        {cart.length === 1 && '1 заказ'}
        {cart.length >= 2 && cart.length + ' заказов'}
        {' '}
        {total > 0 && `(${formatMoney(total)} кредитов)`}
      </Box>
      <Button
        icon="times"
        color="transparent"
        content="Очистить"
        onClick={() => act('clear')} />
    </>
  );
};

const CargoCart = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    requestonly,
    away,
    docked,
    location,
    can_send,
  } = data;
  const cart = data.cart || [];
  return (
    <Section
      title="Текущая корзина"
      buttons={(
        <CargoCartButtons />
      )}>
      {cart.length === 0 && (
        <Box color="label">
          Корзина пуста
        </Box>
      )}
      {cart.length > 0 && (
        <Table>
          {cart.map(entry => (
            <Table.Row
              key={entry.id}
              className="candystripe">
              <Table.Cell collapsing color="label">
                #{entry.id}
              </Table.Cell>
              <Table.Cell>
                {entry.object}
              </Table.Cell>
              <Table.Cell collapsing>
                {!!entry.paid && (
                  <b>[Оплачено с карты]</b>
                )}
              </Table.Cell>
              <Table.Cell collapsing textAlign="right">
                {formatMoney(entry.cost)} кредитов
              </Table.Cell>
              <Table.Cell collapsing>
                {can_send &&(
                  <Button
                    icon="minus"
                    onClick={() => act('remove', {
                      id: entry.id,
                    })} />
                )}
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      )}
      {cart.length > 0 && !requestonly && (
        <Box mt={2}>
          {away === 1 && docked === 1 && (
            <Button
              color="green"
              style={{
                'line-height': '28px',
                'padding': '0 12px',
              }}
              content="Подтвердить заказ"
              onClick={() => act('send')} />
          ) || (
            <Box opacity={0.5}>
              Шаттл в {location}.
            </Box>
          )}
        </Box>
      )}
    </Section>
  );
};
