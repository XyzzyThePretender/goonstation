/**
 * @file
 * @copyright 2022 XyzzyThePretender (https://github.com/XyzzyThePretender)
 * @license MIT
 */

import { useBackend, useSharedState } from '../backend';
import { Box, Button, Flex, Icon, LabeledList, Modal, Section, Tabs } from '../components';
import { Window } from '../layouts';


export const MicrobiologyResearch = (props, context) => {
  const { data, act } = useBackend(context);
  const [menu, setMenu] = useSharedState(context, "menu", "logs");

  const {
    input,
  } = data;

  return (
    <Window
      title="Microbiology Research Console"
      width={715}
      height={685}>
      <Window.Content>
        <Section>
          WIP!!
        </Section>
        <Section>
          WIP!!
        </Section>
      </Window.Content>
    </Window>
  );
};
/**
 * @file
 * @copyright 2022
 * @author XyzzyThePretender (https://github.com/XyzzyThePretender)
 * @license MIT
 */

// Moron attempts to write JS code, pain is guaranteed...

export const Centrifuge = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    active,
    sample,
    petridish,
    dishtotvol,
    dishmaxvol,
    whichculture,
  } = data;

  return (
    <Window
      title="Centrifuge"
      width={300}
      height={400}>

      {active && (
        <Modal
          textAlign="center"
          fontSize="14px">
          <Icon name="cog" spin={1} />
          <Box align="center" content="The centrifuge is currently working." />
          <Button.Confirm
            fontSize="16px"
            fluid
            content="Emergency Shutdown"
            onClick={() => act('shutdown')} />
        </Modal>
      ) || {}}

      <Window.Content>
        <Section
          title="Blood Slide"
          scrollable
          buttons={
            <Box>
              <Button
                icon="eject"
                onClick={() => act('eject_slide')}>
                {sample ? "Eject " : "Insert"}
              </Button>
            </Box>
          }>
          <LabeledList>
            {sample.length && sample.map(s => (
              <LabeledList.Item
                key={s.uid}
                fluid
                color={(whichculture===s.uid) ? 'good' : 'default'}
                label={s.name}>

                {s.goodeff + " / " + s.neuteff + " / " + s.badeff}

                <Button
                  icon="eject"
                  onClick={() => act('select_culture', { uid })} />
              </LabeledList.Item>
            )) || <LabeledList.Item fluid content="Nothing." />}
          </LabeledList>
        </Section>

        {(whichculture && (dishtotvol < (dishmaxvol - 5))) && (
          <Section>
            <Button.Confirm
              fluid
              onClick={() => act('isolate')}
              center
              content="Isolate Sample" />
          </Section>
        ) || {}}

        <Section
          title="Petri Dish"
          scrollable
          buttons={
            <Box>
              <Button
                icon="eject"
                onClick={() => act('eject_dish')}>
                {petridish ? "Eject " + " (" + dishtotvol + "/" + dishmaxvol + ")" : "Insert"}
              </Button>
            </Box>
          }>
          <LabeledList>
            {petridish.length && petridish.map(d => (
              <LabeledList.Item
                key={d.uid}
                fluid
                label={d.name}>

                {d.goodeff + " / " + d.neuteff + " / " + d.badeff}
              </LabeledList.Item>
            )) || <LabeledList.Item fluid content="Nothing." />}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
