import axios from 'axios';

import {
  FETCH_CURRENT_USER_GROUPS
} from './types';
import { addAlert } from '../actions';

export const fetchCurrentUserGroups = (queryString = '') => {
  return (dispatch) => {
    axios.get(`/profile/groups.json${queryString}`)
      .then(response => {
        dispatch({
          type: FETCH_CURRENT_USER_GROUPS,
          payload: response
        });
      }).catch(err => {
        let text = (err.response && err.response.status != 500) ? err.response.data.join(', ') : null;
        let type = 'error';

        dispatch(addAlert({ text, type }));
      });
  }
};
