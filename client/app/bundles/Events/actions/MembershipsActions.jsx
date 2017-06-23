import {
  FETCH_MEMBERSHIPS,
  FETCHING_MEMBERSHIPS
} from './types';

<<<<<<< HEAD
import { membershipPath } from '../utils/Pathnames';
=======
import { membershipPath, client } from '../utils';
>>>>>>> master
import { addAlert } from '../actions';

export const fetchMemberships = (queryString = '') => {
  return (dispatch) => {
    dispatch({ type: FETCHING_MEMBERSHIPS })
<<<<<<< HEAD
    axios.get(`${membershipPath()}.json${queryString}`)
=======
    client.get(`${membershipPath()}.json${queryString}`)
>>>>>>> master
      .then(response => {
        dispatch({
          type: FETCH_MEMBERSHIPS,
          payload: response
        });
<<<<<<< HEAD
      }).catch(err => {
        let text = (err.response && err.response.status != 500) ? err.response.data.join(', ') : null;
        let type = 'error';

        dispatch(addAlert({ text, type }));
=======
      }).catch(alert => {
        dispatch(addAlert(alert));
>>>>>>> master
      });
  }
};
