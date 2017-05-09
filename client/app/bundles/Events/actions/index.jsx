import axios from 'axios';

import {
  FETCH_EVENTS,
  FETCH_EVENT
} from './types';

export const fetchEvents = (queryString = '') => {
  const request = axios.get(`/events.json${queryString}`);

  return {
    type: FETCH_EVENTS,
    payload: request
  };
};

export const fetchEvent = (eventId) => {
  const request = axios.get(`/events/${eventId}.json`);

  return {
    type: FETCH_EVENT,
    payload: request
  };
};
