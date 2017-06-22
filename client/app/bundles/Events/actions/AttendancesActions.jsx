import axios from 'axios';

import {
  FETCH_ATTENDANCES,
  UPDATE_ATTENDANCE,
  SET_ATTENDANCE_ATTRIBUTE,
  ATTENDANCE_CREATE_SUCCESS,
  RESET_ATTENDANCE_FORM,
} from './types';

import { attendancesPath } from '../utils/Pathnames';
import { addAlert } from '../actions';

export const fetchAttendances = (eventId, queryString = '') => {
  return (dispatch) => {
    axios.get(`${attendancesPath(eventId)}.json${queryString}`)
      .then(response => {
        dispatch({
          type: FETCH_ATTENDANCES,
          payload: response
        });
      }).catch(err => {
        let text = (err.response && err.response.status != 500) ? err.response.data.join(', ') : null;
        let type = 'error';

        dispatch(addAlert({ text, type }));
      });
  }
}

export const updateAttendance = ({ id, eventId, attended }) => {
  const request = axios.put(`${attendancesPath(eventId)}/${id}.json`, { attended });

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
    axios.post(`${attendancesPath(eventId)}.json`, { attendance: attributes })
      .then(response => {
        let type = 'success';
        let text = 'Attendance Successfully Created.';

        dispatch(addAlert({ text, type }));
        dispatch({ type: ATTENDANCE_CREATE_SUCCESS });
        dispatch(fetchAttendances(eventId));
      }).catch(err => {
        let text = err.response ? err.response.data.join(', ') : null;
        let type = 'error';

        dispatch(addAlert({ text, type }));
      });
  }
}

export const resetAttendanceForm = () => {
  return { type: RESET_ATTENDANCE_FORM }
}
