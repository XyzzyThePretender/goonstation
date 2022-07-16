/**
 * @file
 * @copyright 2022
 * @author XyzzyThePretender (https://github.com/XyzzyThePretender)
 * @license MIT
 */

import { Fragment } from "inferno";
import { useBackend, useSharedState } from "../../../backend";
import { Button, Collapsible, Section } from "../../../components";

export const LogsTab = (props, context) => {
  const [menu, setMenu] = useSharedState(context, "menu", "logs");

  return (
    <Fragment>
      Wip!
    </Fragment>
  );
};
