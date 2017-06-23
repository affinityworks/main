import {
  FETCH_CURRENT_USER_GROUPS
} from './types';
import { addAlert } from '../actions';
import { client } from '../utils';

export const fetchCurrentUserGroups = (queryString = '') => {
  return (dispatch) => {
    client.get(`/profile/groups.json${queryString}`)
      .then(response => {
        dispatch({
          type: FETCH_CURRENT_USER_GROUPS,
          payload: response
        });
      }).catch(alert => {
        dispatch(addAlert(alert));
      });
  }
};
