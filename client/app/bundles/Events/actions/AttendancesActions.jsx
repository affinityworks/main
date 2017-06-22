import {
  FETCH_ATTENDANCES,
  UPDATE_ATTENDANCE,
  SET_ATTENDANCE_ATTRIBUTE,
  ATTENDANCE_CREATE_SUCCESS,
  RESET_ATTENDANCE_FORM,
} from './types';

import { attendancesPath, client } from '../utils';
import { addAlert } from '../actions';

export const fetchAttendances = (eventId, queryString = '') => {
  return (dispatch) => {
    client.get(`${attendancesPath(eventId)}.json${queryString}`)
      .then(response => {
        dispatch({
          type: FETCH_ATTENDANCES,
          payload: response
        });
      }).catch((error, alert) => {
        dispatch(addAlert(alert));
      });
  }
}

export const updateAttendance = ({ id, eventId, attended }) => {
  const request = client.put(`${attendancesPath(eventId)}/${id}.json`, { attended });

  return {
    type: UPDATE_ATTENDANCE,
    payload: request
  };
}

export const setAttendanceAttribute = (prop, value) => (
  {
    type: SET_ATTENDANCE_ATTRIBUTE,
    payload: { prop, value }
  }
);

export const createAttendance = (eventId, attributes) => {
  return (dispatch) => {
    client.post(`${attendancesPath(eventId)}.json`, { attendance: attributes })
      .then(response => {
        let type = 'success';
        let text = 'Attendance Successfully Created.';

        dispatch(addAlert({ text, type }));
        dispatch({ type: ATTENDANCE_CREATE_SUCCESS });
        dispatch(fetchAttendances(eventId));
      }).catch((error, alert) => {
        dispatch(addAlert(alert));
      });
  }
}

export const resetAttendanceForm = () => {
  return { type: RESET_ATTENDANCE_FORM }
}
