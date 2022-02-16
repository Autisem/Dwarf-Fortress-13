import { useBackend } from '../backend';
import { Button, Section } from '../components';
import { Window } from '../layouts';

export const AtmosAlertConsole = (props, context) => {
  const { act, data } = useBackend(context);
  const priorityAlerts = data.priority || [];
  const minorAlerts = data.minor || [];
  return (
    <Window
      width={350}
      height={300}>
      <Window.Content scrollable>
        <Section title="Тревоги">
          <ul>
            {priorityAlerts.length === 0 && (
              <li className="color-good">
                Нет приоритетных тревог
              </li>
            )}
            {priorityAlerts.map(alert => (
              <li key={alert}>
                <Button
                  icon="times"
                  content={alert}
                  color="bad"
                  onClick={() => act('clear', { zone: alert })} />
              </li>
            ))}
            {minorAlerts.length === 0 && (
              <li className="color-good">
                Нет средних тревог
              </li>
            )}
            {minorAlerts.map(alert => (
              <li key={alert}>
                <Button
                  icon="times"
                  content={alert}
                  color="average"
                  onClick={() => act('clear', { zone: alert })} />
              </li>
            ))}
          </ul>
        </Section>
      </Window.Content>
    </Window>
  );
};
