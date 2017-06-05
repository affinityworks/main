import axios from 'axios';

import {
  FETCH_EVENTS,
  FETCH_EVENT
} from './types';

import { eventsPath } from '../utils/Pathnames';

export const fetchEvents = (queryString = '') => {
  const request = axios.get(`${eventsPath()}.json${queryString}`);

  return {
    type: FETCH_EVENTS,
    payload: request
  };
};

export const fetchEvent = (eventId) => {
  const request = axios.get(`${eventsPath()}/${eventId}.json`);

  return {
    type: FETCH_EVENT,
    payload: request
  };
};
