import { FETCH_MEMBER } from '../actions/types';

const MemberReducer = (state = {}, action) => {
  switch (action.type) {
  case FETCH_MEMBER:
    return action.payload.data.data;
  default:
    return state;
  }
};

export default MemberReducer;
