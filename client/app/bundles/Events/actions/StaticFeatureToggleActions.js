import { client }  from '../utils';
import { addAlert } from '../actions';
import { STATIC_FEATURE_TOGGLES_FETCHED } from './types';

export const fetchStaticFeatureToggles = (feature, groupId) => (dispatch) =>
  client
    .get(`/static_feature_toggles.json$?feature=${feature}&group_id=${groupId}`)
    .then(resp => dispatch({
      type: STATIC_FEATURE_TOGGLES_FETCHED,
      payload: resp.data
    }))
    .catch(alert => dispatch(addAlert(alert)));
