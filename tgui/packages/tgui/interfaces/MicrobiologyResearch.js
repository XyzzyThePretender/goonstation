/**
 * @file
 * @copyright 2022 XyzzyThePretender (https://github.com/XyzzyThePretender)
 * @license MIT
 */

import { useLocalState } from '../backend';
import { Flex, Section, Tabs } from '../components';
import { Window } from '../layouts';


export const MicrobiologyResearch = (props, context) => {
  const { act, data } = useLocalState(context);

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
          AAA!!
        </Section>
        <Section>
          AAA!!
        </Section>
      </Window.Content>
    </Window>
  );
};
