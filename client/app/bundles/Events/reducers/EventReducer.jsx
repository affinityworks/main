import { FETCH_EVENT } from '../actions/types';

const EventReducer = (state = {}, action) => {
  switch (action.type) {
  case FETCH_EVENT:
    return action.payload.data.data;
  default:
    return state;
  }
};

export default EventReducer;
