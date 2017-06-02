import axios from 'axios';

import {
  FETCH_ATTENDANCES,
  UPDATE_ATTENDANCE,
  SET_ATTENDANCE_ATTRIBUTE,
  ATTENDANCE_CREATE_SUCCESS,
  ATTENDANCE_CREATE_FAIL,
  RESET_ATTENDANCE_FORM
} from './types';

import { attendancesPath } from '../utils/Pathnames';

export const fetchAttendances = (eventId, queryString = '') => {
  const request = axios.get(`${attendancesPath(eventId)}.json${queryString}`);

  return {
    type: FETCH_ATTENDANCES,
    payload: request
  };
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
      .then((response) => {
        dispatch({ type: ATTENDANCE_CREATE_SUCCESS, payload: response.data })
        dispatch(fetchAttendances(eventId))
      }).catch((err) => {
        console.log('error', err);
        dispatch({ type: ATTENDANCE_CREATE_FAIL, payload: err })
      });
  }
}

export const resetAttendanceForm = () => {
  return { type: RESET_ATTENDANCE_FORM }
}
