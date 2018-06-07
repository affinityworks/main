import { STATIC_FEATURE_TOGGLES_FETCHED } from '../actions/types';

const StaticFeatureTogglesReducer = (state = {}, action) => {
  switch (action.type){
  case STATIC_FEATURE_TOGGLES_FETCHED:
    return action.payload;
  default:
    return state;
  }
};

export default StaticFeatureTogglesReducer;
