import {
  FETCH_MEMBERSHIPS,
  FETCHING_MEMBERSHIPS
} from './types';

import { membershipPath, client } from '../utils';
import { addAlert } from '../actions';

export const fetchMemberships = (queryString = '') => {
  return (dispatch) => {
    dispatch({ type: FETCHING_MEMBERSHIPS })
    client.get(`${membershipPath()}.json${queryString}`)
      .then(response => {
        dispatch({
          type: FETCH_MEMBERSHIPS,
          payload: response
        });
      }).catch((error, alert) => {
        dispatch(addAlert(alert));
      });
  }
};
