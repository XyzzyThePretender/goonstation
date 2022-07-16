/**
 * @file
 * @copyright 2022 XyzzyThePretender (https://github.com/XyzzyThePretender)
 * @license MIT
 */

import { useBackend, useSharedState } from '../backend';
import { Flex, Section, Tabs } from '../components';
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
