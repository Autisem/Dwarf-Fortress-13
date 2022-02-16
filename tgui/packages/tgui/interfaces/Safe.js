import { Fragment } from 'inferno';
import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import { Box, Button, Icon, Section } from '../components';
import { Window } from "../layouts";

export const Safe = (properties, context) => {
  const { act, data } = useBackend(context);
  const {
    dial,
    open,
  } = data;
  return (
    <Window
      width={625}
      height={800}
      theme="ntos">
      <Window.Content>
        <Box className="Safe__engraving">
          <Dialer />
          <Box>
            <Box
              className="Safe__engraving-hinge"
              top="25%" />
            <Box
              className="Safe__engraving-hinge"
              top="75%" />
          </Box>
          <Icon
            className="Safe__engraving-arrow"
            name="long-arrow-alt-down"
            size="5"
          /><br />
          {open ? (
            <Contents />
          ) : (
            <Box
              as="img"
              className="Safe__dial"
              src={resolveAsset('safe_dial.png')}
              style={{
                "transform": "rotate(-" + (3.6 * dial) + "deg)",
              }}
            />
          )}
        </Box>
        {!open && (
          <Help />
        )}
      </Window.Content>
    </Window>
  );
};

const Dialer = (properties, context) => {
  const { act, data } = useBackend(context);
  const {
    dial,
    open,
    locked,
    broken,
  } = data;
  const dialButton = (amount, right) => {
    return (
      <Button
        disabled={open || (right && !locked) || broken}
        icon={"arrow-" + (right ? "right" : "left")}
        content={(right ? "Прав" : "Лево") + " " + amount}
        iconPosition={right ? "right" : "left"}
        onClick={() => act(!right ? "turnright" : "turnleft", {
          num: amount,
        })}
      />
    );
  };
  return (
    <Box className="Safe__dialer">
      <Button
        disabled={locked && !broken}
        icon={open ? "lock" : "lock-open"}
        content={open ? "Закрыть" : "Открыть"}
        mb="0.5rem"
        onClick={() => act('open')}
      /><br />
      <Box position="absolute">
        {[dialButton(50), dialButton(10), dialButton(1)]}
      </Box>
      <Box
        className="Safe__dialer-right"
        position="absolute" right="5px">
        {[dialButton(1, true), dialButton(10, true), dialButton(50, true)]}
      </Box>
      <Box className="Safe__dialer-number">
        {dial}
      </Box>
    </Box>
  );
};

const Contents = (properties, context) => {
  const { act, data } = useBackend(context);
  const {
    contents,
  } = data;
  return (
    <Box
      className="Safe__contents"
      overflow="auto">
      {contents.map((item, index) => (
        <Fragment key={item}>
          <Button
            mb="0.5rem"
            onClick={() => act("retrieve", {
              index: index + 1,
            })}>
            <Box
              as="img"
              src={item.sprite + ".png"}
              verticalAlign="middle"
              ml="-6px"
              mr="0.5rem"
            />
            {item.name}
          </Button>
          <br />
        </Fragment>
      ))}
    </Box>
  );
};

const Help = (properties, context) => {
  return (
    <Section
      className="Safe__help"
      title="Инструкция по открытию сейфа (потому что забываете)">
      <Box>
        1. Крути налево до первого числа.<br />
        2. Крути направо до второго числа.<br />
        3. Повторяй этот процесс для каждого числа,
        меняя стороны каждый раз.<br />
        4. Открывай.
      </Box>
      <Box bold>
        Для полной блокировки поверни крутилку налево после закрытия.
      </Box>
    </Section>
  );
};
