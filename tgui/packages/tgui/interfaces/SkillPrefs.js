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
      width={700}
      height={600}>
      <Window.Content scrollable>
        <Box
          style={{"padding-bottom":"8px"}}>
          Available skill points: {available}
        </Box>
        <ul>
        {skills.map(skill => (
          <li
            style={{"padding":"8px","margin-top":"10px",
              "display":"flex","margin-bottom":"10px",
              "justify-content":"space-between",
              "align-items":"flex-start","border-bottom":"1px solid gray"}}>
            <div
            style={{"display": "flex",
            "flex-direction":"column",
            "margin": "0 12px"}}>
              <span
              style={{"font-size":"1.3rem",
              "font-weight":"600"}}>{skill.name}</span>
              <span
              style={{"margin": "8px 0",
                "word-break": "normal",
                "font-weight": "300",
                "font-size":" 0.9rem"}}>{skill.desc}</span>
            </div>
            <div
            style={{"display": "flex",
              "align-items": "center",
              "margin": "0 12px"}}>
              <Button
              style={{"width":"24px","heigh":"24px","text-align":"center"}}
              disabled={skill.lvl < 2}
              onClick={()=>act("remove", {"path":skill.path})}>-</Button>
              <span
              style={{"width":"110px","text-align":"center"}}>
                {skill.rank}</span>
              <Button
              style={{"width":"24px","heigh":"24px","text-align":"center"}}
              disabled={skill.lvl == per_skill+1 || available == 0}
              onClick={()=>act("add", {"path":skill.path})}>+</Button>
            </div>
          </li>
        ))}
      </ul>
      </Window.Content>
    </Window>
  );
};
