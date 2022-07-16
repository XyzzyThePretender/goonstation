/**
 * @file
 * @copyright 2022
 * @author XyzzyThePretender (https://github.com/XyzzyThePretender)
 * @license MIT
 */

import { Fragment } from "inferno";
import { useBackend } from "../../../backend";
import { Section } from "../../../components";

export const ResearchTab = (props, context) => {
  const { data, act } = useBackend(context);
  const [menu, setMenu] = useSharedState(context, "menu", "research");
  const {
    budget,
    research,
  } = data;

  return (
    <Fragment>
      WIP!
    </Fragment>
  );
};
