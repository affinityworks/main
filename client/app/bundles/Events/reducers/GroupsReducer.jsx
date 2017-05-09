import { FETCH_GROUPS } from '../actions/types';

const INITIAL_STATE = [];

export default (state = INITIAL_STATE, action) => {
  switch (action.type) {
  case FETCH_GROUPS:
    return action.payload.data;
  default:
    return state;
  }
};
