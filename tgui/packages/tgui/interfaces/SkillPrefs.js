import { useBackend } from '../backend';
import { Box, Button, Stack, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const SkillPrefs = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    skills,
    available,
    per_skill
  } = data;
  return (
    <Window
      title="Skills"
      width={300}
      height={600}>
      <Window.Content scrollable>
        <Box>Available skill points: {available}</Box>
        {skills.map(skill => (
          <Stack>
            <Box>{skill.name} - {skill.title}</Box>
          </Stack>
        ))}
      </Window.Content>
    </Window>
  );
};
