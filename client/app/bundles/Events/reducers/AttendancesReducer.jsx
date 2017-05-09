import _ from 'lodash';

import { FETCH_ATTENDANCES, UPDATE_ATTENDANCE } from '../actions/types';

const INITIAL_STATE = [];

export default (state = INITIAL_STATE, action) => {
  switch (action.type) {
  case FETCH_ATTENDANCES:
    return action.payload.data.data;
  case UPDATE_ATTENDANCE: {
    const updatedAttendance = action.payload.data.data;
    return _.map(state, function(attendance) {
      return (attendance.id === updatedAttendance.id)
        ? updatedAttendance
        : attendance;
    });
  }
  default:
    return state;
  }
};
