import axios from 'axios';

import {
  FETCH_EVENTS,
  FETCH_EVENT
} from './types';

import { eventsPath } from '../utils/Pathnames';
import { addAlert } from '../actions';

export const fetchEvents = (queryString = '') => {
  return (dispatch) => {
    axios.get(`${eventsPath()}.json${queryString}`)
      .then(response => {
        dispatch({
          type: FETCH_EVENTS,
          payload: response
        });
      }).catch(err => {
        let text = (err.response && err.response.status != 500) ? err.response.data.join(', ') : null;
        let type = 'error';

        dispatch(addAlert({ text, type }));
      });
  }
};

export const fetchEvent = (eventId) => {
  return (dispatch) => {
    axios.get(`${eventsPath()}/${eventId}.json`)
      .then(response => {
        dispatch({
          type: FETCH_EVENT,
          payload: response
        });
      }).catch(err => {
        let text = (err.response && err.response.status != 500) ? err.response.data.join(', ') : null;
        let type = 'error';

        dispatch(addAlert({ text, type }));
      });
  }
};
