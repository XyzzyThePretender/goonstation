/**
 * @file
 * @copyright 2022 XyzzyThePretender (https://github.com/XyzzyThePretender)
 * @license MIT
 */

import { useBackend } from '../backend';
import { BlockQuote, Box, Button, Divider, Flex, Icon, Modal, Section } from '../components';
import { Window } from '../layouts';


export const Centrifuge = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    active,
    sample,
    petridish,
    isolated,
  } = data;

  const {
    uid,
    name,
  } = sample || {};


  return (
    <Window
      title="Centrifuge"
      width={300}
      height={400}>
      <Window.Content>
        {active && (
          <Modal
            textAlign="center"
            fontSize="14px">
            <Box width={20} height={5} align="center">
              The centrifuge is currently working.
            </Box>
            <Button.Confirm
              fontSize="16px"
              content="Emergency Shutdown"
              Confirm="Confirm?">
              onClick={() => act("shutdown")}
            </Button.Confirm>
          </Modal>
        )}
        <Section>

          Vials (Icon, var bloodslide)
          Microbes and Isolation selection (Button)
          Eject (Button, Icon)
          Navigate (Button, Icon)

          <Divider />

          Petri Dish (Icon, var petridish)
          Microbes (BlockQuote)
          Eject (Button, Icon)

          <Divider />

          Button: perform isolation process

        </Section>
      </Window.Content>
    </Window>
  );
};
