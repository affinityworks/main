import axios from 'axios';

import {
  FETCH_ATTENDANCES,
  UPDATE_ATTENDANCE,
  CREATE_ATTENDANCE,
  SET_ATTENDANCE_ATTRIBUTE
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
  const request = axios.post(
    `/events/${eventId}/attendances.json`,
    { attendance: attributes }
  );

  return {
    type: CREATE_ATTENDANCE,
    payload: request
  };
}
