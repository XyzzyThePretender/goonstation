/**
 * @file
 * @copyright 2022 XyzzyThePretender (https://github.com/XyzzyThePretender)
 * @license MIT
 */

import { useLocalState } from '../backend';
import { Flex, Section, Tabs } from '../components';
import { Window } from '../layouts';


export const Synthomatic = (props, context) => {
  const { act, data } = useLocalState(context);

  const {
    input,
  } = data;

  return (
    <Window
      title="Synth-o-Matic 6.5.535"
      width={800}
      height={600}>
      <Window.Content>
        <Section>
          AAA!!
        </Section>
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
