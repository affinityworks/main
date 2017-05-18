import axios from 'axios';

import {
  FETCH_ATTENDANCES,
  UPDATE_ATTENDANCE
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
