import { FETCH_GROUP } from '../actions/types';

const GroupReducer = (state = {}, action) => {
  switch (action.type) {
  case FETCH_GROUP:
    return action.payload.data.data;
  default:
    return state;
  }
};

export default GroupReducer;
