import _ from 'lodash';
import update from 'react-addons-update';

import { ADD_ALERT, REMOVE_ALERT } from '../actions/types';

const INITIAL_STATE = [];

export default (state = INITIAL_STATE, { type, payload }) => {
  let alert = payload;

  switch (type) {
  case ADD_ALERT:
    console.log('WALALAL', alert);
    if (!alert) { return state };

    if (!alert.id)
      alert.id = _.uniqueId('alert_');

    if (!alert.text && alert.type == 'error')
      alert.text = 'An error ocurred, please try again later.';

    return update(state, { $push: [alert] });
  case REMOVE_ALERT:
    const index = state.indexOf(alert);
    return update(state, { $splice: [[index, 1]] });
  default:
    return state;
  }
};
