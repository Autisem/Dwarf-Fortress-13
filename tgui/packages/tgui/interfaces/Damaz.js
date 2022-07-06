import { bottom } from '@popperjs/core';
import { useBackend } from '../backend';
import { Button, Stack, Box } from '../components';
import { Window } from '../layouts';

export const Damaz = (props, context) => {
  const { act, data } = useBackend(context);
  const king = data.king;
  const entries = data.entries || [];
  return (
    <Window
      title="Damaz Kron"
      theme="ntos"
      width={600}
      height={700}>
      <Window.Content scrollable>
      <Stack vertical>
        {entries.map(entry => (
          <Stack.Item
          style={{"border-bottom":"1px solid gray","padding":"4px"}}>
          <Box bold
          style={{"font-size":"15px","word-wrap":"break-word"}}>
            {entry.content}</Box>
          <Box italic={true} textAlign="right" >
            - <b>{entry.author}</b> of <b>{entry.fortress}</b></Box>
          </Stack.Item>
        ))}
        </Stack>
        <Button
          fluid="auto"
          textAlign="center"
          disabled={!king}
          onClick={() => act('add_entry')}>
          New Entry
        </Button>
      </Window.Content>
    </Window>
  );
};
