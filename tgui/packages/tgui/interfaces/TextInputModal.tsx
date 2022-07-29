import { Loader } from './common/Loader';
import { InputButtons, Validator } from './common/InputButtons';
import { useBackend, useLocalState } from '../backend';
import { KEY_ENTER, KEY_ESCAPE } from '../../common/keycodes';
import { Box, Input, Section, Stack, TextArea } from '../components';
import { Window } from '../layouts';

type TextInputData = {
  max_length: number;
  message: string;
  multiline: boolean;
  placeholder: string;
  timeout: number;
  title: string;
};

export const TextInputModal = (_, context) => {
  const { act, data } = useBackend<TextInputData>(context);
  const {
    max_length,
    message,
    multiline,
    placeholder,
    timeout,
    title,
  } = data;
  const [input, setInput] = useLocalState<string>(
    context,
    'input',
    placeholder || ''
  );
  const [inputIsValid, setInputIsValid] = useLocalState<Validator>(
    context,
    'inputIsValid',
    { isValid: !!placeholder, error: null }
  );
  const onType = (value: string) => {
    setInputIsValid(validateInput(value, max_length));
    setInput(value);
  };
  // Dynamically changes the window height based on the message.
  const windowHeight
    = 125
    + Math.ceil(message.length / 3)
    + (multiline ? 75 : 0);

  return (
    <Window title={title} width={325} height={windowHeight}>
      {timeout && <Loader value={timeout} />}
      <Window.Content
        onKeyDown={(event) => {
          const keyCode = window.event ? event.which : event.keyCode;
          if (keyCode === KEY_ENTER && inputIsValid.isValid) {
            act('choose', { choice: input });
          }
          if (keyCode === KEY_ESCAPE) {
            act('cancel');
          }
        }}>
        <Section fill>
          <Stack fill vertical>
            <Stack.Item>
              <Box color="label">{message}</Box>
            </Stack.Item>
            <InputArea
              input={input}
              inputIsValid={inputIsValid}
              onType={onType}
            />
            <Stack.Item>
              <InputButtons input={input} inputIsValid={inputIsValid} />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

/** Gets the user input and invalidates if there's a constraint. */
const InputArea = (props, context) => {
  const { data } = useBackend<TextInputData>(context);
  const { multiline } = data;
  const { input, onType } = props;

  if (!multiline) {
    return (
      <Stack.Item>
        <Input
          autoFocus
          autoSelect
          fluid
          onInput={(_, value) => onType(value)}
          placeholder="Write something..."
          value={input}
        />
      </Stack.Item>
    );
  } else {
    return (
      <Stack.Item grow>
        <TextArea
          autoFocus
          autoSelect
          height="100%"
          onInput={(_, value) => onType(value)}
          placeholder="Write something..."
          value={input}
        />
      </Stack.Item>
    );
  }
};

/** Helper functions */
const validateInput = (input, max_length) => {
  if (!!max_length && input.length > max_length) {
    return { isValid: false, error: `Too long!` };
  } else if (input.length === 0) {
    return { isValid: false, error: null };
  }
  return { isValid: true, error: null };
};
