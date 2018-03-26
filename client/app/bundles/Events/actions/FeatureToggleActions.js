import { client }  from '../utils';
import { addAlert } from '../actions';
import { FEATURE_TOGGLES_FETCHED } from './types';

export const fetchFeatureToggles = (feature, groupId) => (dispatch) =>
  client
    .get(`/feature_toggles.json$?feature=${feature}&group_id=${groupId}`)
    .then(resp => dispatch({
      type: FEATURE_TOGGLES_FETCHED,
      payload: resp.data
    }))
    .catch(alert => dispatch(addAlert(alert)));
