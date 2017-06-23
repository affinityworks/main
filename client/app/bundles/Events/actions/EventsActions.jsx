import {
  FETCH_EVENTS,
  FETCH_EVENT
} from './types';

import { eventsPath, client } from '../utils';
import { addAlert } from '../actions';

export const fetchEvents = (queryString = '') => {
  return (dispatch) => {
    client.get(`${eventsPath()}.json${queryString}`)
      .then(response => {
        dispatch({
          type: FETCH_EVENTS,
          payload: response
        });
      }).catch(alert => {
        dispatch(addAlert(alert));
      });
  }
};

export const fetchEvent = (eventId) => {
  return (dispatch) => {
    client.get(`${eventsPath()}/${eventId}.json`)
      .then(response => {
        dispatch({
          type: FETCH_EVENT,
          payload: response
        });
      }).catch(alert => {
        dispatch(addAlert(alert));
      });
  }
};
