/**
 * @file
 * @copyright 2022
 * @author XyzzyThePretender (https://github.com/XyzzyThePretender)
 * @license MIT
 */

import { Fragment } from "inferno";
import { useBackend, useSharedState } from "../../../backend";
import { Box, Button, LabeledList, Section } from "../../../components";

export const MarketTab = (props, context) => {
  const { data, act } = useBackend(context);
  const [menu, setMenu] = useSharedState(context, "menu", "market");
  const {
    samples,
  } = data;

  return (
    <Fragment>
      WIP!
    </Fragment>
  );
};
