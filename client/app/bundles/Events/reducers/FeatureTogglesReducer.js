import { FEATURE_TOGGLES_FETCHED } from '../actions/types';

const FeatureTogglesReducer = (state = {}, action) => {
  switch (action.type){
  case FEATURE_TOGGLES_FETCHED:
    return action.payload;
  default:
    return state;
  }
};

export default FeatureTogglesReducer;
