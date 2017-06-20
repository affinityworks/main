import axios from 'axios';

import {
  FETCH_MEMBERSHIPS
} from './types';

import { membershipPath } from '../utils/Pathnames';
import { addAlert } from '../actions';

export const fetchMemberships = (queryString = '') => {
  return (dispatch) => {
    axios.get(`${membershipPath()}.json${queryString}`)
      .then(response => {
        dispatch({
          type: FETCH_MEMBERSHIPS,
          payload: response
        });
      }).catch(err => {
        let text = (err.response && err.response.status != 500) ? err.response.data.join(', ') : null;
        let type = 'error';

        dispatch(addAlert({ text, type }));
      });
  }
};
