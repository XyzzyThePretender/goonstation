/**
 * @file
 * @copyright 2022
 * @author XyzzyThePretender (https://github.com/XyzzyThePretender)
 * @license MIT
 */

import { Fragment } from "inferno";
import { useBackend, useSharedState } from "../../../backend";
import { Box, Button, ByondUi, Flex, LabeledList, Modal, Section } from "../../../components";

export const ReportTab = (props, context) => {
  const { data, act } = useBackend(context);
  const [menu, setMenu] = useSharedState(context, "menu", "reporter");

  const {
    haveScanner,
    sample,
  } = data;

  const {
    name,
  } = sample || {};


  if (!sample) {
    return (
      <Section title="Scanner Error">
        {haveScanner ? "No sample detected." : "Check connection to scanner."}
      </Section>
    );
  }

  return (
    <Fragment>
      WIP!
    </Fragment>
  );
};
