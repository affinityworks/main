import {
  FETCH_GROUPS,
  FETCH_AFFILIATES,
  FETCH_GROUP
} from './types';

import { addAlert } from '../actions';
import { affiliatesPath, client } from '../utils';

export const fetchGroups = (queryString = '') => {
  return (dispatch) => {
    client.get(`/groups.json${queryString}`)
      .then(response => {
        dispatch({
          type: FETCH_GROUPS,
          payload: response
        });
      }).catch((error, alert) => {
        dispatch(addAlert(alert));
      });
  }
};

export const fetchAffiliates = (queryString = '') => {
  return (dispatch) => {
    client.get(`${affiliatesPath()}.json${queryString}`)
      .then(response => {
        dispatch({
          type: FETCH_AFFILIATES,
          payload: response
        });
      }).catch((error, alert) => {
        dispatch(addAlert(alert));
      });
  }
};


export const fetchGroup = (groupId) => {
  return (dispatch) => {
    client.get(`/groups/${groupId}.json`)
      .then(response => {
        dispatch({
          type: FETCH_GROUP,
          payload: response
        });
      }).catch((error, alert) => {
        dispatch(addAlert(alert));
      });
  }
};
