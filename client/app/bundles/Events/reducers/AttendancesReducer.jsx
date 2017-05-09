import { FETCH_ATTENDANCES } from '../actions/types';

const INITIAL_STATE = [];

export default (state = INITIAL_STATE, action) => {
  switch (action.type) {
  case FETCH_ATTENDANCES:
    return action.payload.data.data;
  default:
    return state;
  }
};
