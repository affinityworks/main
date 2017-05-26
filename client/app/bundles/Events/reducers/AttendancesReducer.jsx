import _ from 'lodash';

import { FETCH_ATTENDANCES, UPDATE_ATTENDANCE, ATTENDANCE_CREATE_SUCCESS } from '../actions/types';

const INITIAL_STATE = {
  attendances: [],
  total_pages: null,
  page: null
};

export default (state = INITIAL_STATE, action) => {
  switch (action.type) {
  case FETCH_ATTENDANCES:
    const { page, total_pages, attendances } = action.payload.data
    return { page, total_pages, attendances: attendances.data };
  case UPDATE_ATTENDANCE: {
    const updatedAttendance = action.payload.data.data;
    const attendances = _.map(state.attendances, function(attendance) {
      return (attendance.id === updatedAttendance.id)
        ? updatedAttendance
        : attendance;
    });
    return { ...state, attendances }
  }
  default:
    return state;
  }
};
