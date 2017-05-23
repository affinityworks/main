import axios from 'axios';

import {
  FETCH_ATTENDANCES,
  UPDATE_ATTENDANCE,
  SET_ATTENDANCE_ATTRIBUTE,
  ATTENDANCE_CREATE_SUCCESS,
  ATTENDANCE_CREATE_FAIL,
  CLEAN_ATTENDANCE_ALERTS
} from './types';

export const fetchAttendances = (eventId, queryString = '') => {
  const request = axios.get(`/events/${eventId}/attendances.json${queryString}`);

  return {
    type: FETCH_ATTENDANCES,
    payload: request
  };
}

export const updateAttendance = ({ id, eventId, attended }) => {
  const request = axios.put(`/events/${eventId}/attendances/${id}.json`, { attended });

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
    axios.post(`/events/${eventId}/attendances.json`, { attendance: attributes })
      .then((response) => {
        dispatch({ type: ATTENDANCE_CREATE_SUCCESS, payload: response.data })
      }).catch((err) => {
        console.log('error', err);
        dispatch({ type: ATTENDANCE_CREATE_FAIL, payload: err })
      });
  }
}

export const cleanAttendanceAlerts = () => {
  return { type: CLEAN_ATTENDANCE_ALERTS }
}
