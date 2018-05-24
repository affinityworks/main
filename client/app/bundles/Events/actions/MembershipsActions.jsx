import {
  DELETE_MEMBERSHIP,
  FETCH_MEMBERSHIPS,
  FETCHING_MEMBERSHIPS
} from './types';

import { membershipPath, client } from '../utils';
import { addAlert } from '../actions';

export const fetchMemberships = (queryString = '') => {
  return (dispatch) => {
    dispatch({ type: FETCHING_MEMBERSHIPS });
    client.get(`${membershipPath()}.json${queryString}`)
      .then(response => {
        dispatch({
          type: FETCH_MEMBERSHIPS,
          payload: response
        });
      }).catch(alert => {
        dispatch(addAlert(alert));
      });
  };
};


export const deleteMembership = (membershipId) => (dispatch) => 
  client
    .delete(`${membershipPath()}/${membershipId}.json`)
    .then(response => {
      dispatch({ type: DELETE_MEMBERSHIP, payload: response });
    }).catch(alert => {
      dispatch(addAlert(alert));
    });
