import axios from 'axios';

import { affiliatesPath } from '../utils/Pathnames';

import {
  FETCH_GROUPS,
  FETCH_AFFILIATES,
  FETCH_GROUP
} from './types';

import { addAlert } from '../actions';

export const fetchGroups = (queryString = '') => {
  return (dispatch) => {
    axios.get(`/groups.json${queryString}`)
      .then(response => {
        dispatch({
          type: FETCH_GROUPS,
          payload: response
        });
      }).catch(err => {
        let text = (err.response && err.response.status != 500) ? err.response.data.join(', ') : null;
        let type = 'error';

        dispatch(addAlert({ text, type }));
      });
  }
};

export const fetchAffiliates = (queryString = '') => {
  return (dispatch) => {
    axios.get(`${affiliatesPath()}.json${queryString}`)
      .then(response => {
        dispatch({
          type: FETCH_AFFILIATES,
          payload: response
        });
      }).catch(err => {
        let text = (err.response && err.response.status != 500) ? err.response.data.join(', ') : null;
        let type = 'error';

        dispatch(addAlert({ text, type }));
      });
  }
};


export const fetchGroup = (groupId) => {
  return (dispatch) => {
    axios.get(`/groups/${groupId}.json`)
      .then(response => {
        dispatch({
          type: FETCH_GROUP,
          payload: response
        });
      }).catch(err => {
        let text = (err.response && err.response.status != 500) ? err.response.data.join(', ') : null;
        let type = 'error';

        dispatch(addAlert({ text, type }));
      });
  }
};
