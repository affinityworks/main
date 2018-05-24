import { DELETE_MEMBERSHIP, FETCH_MEMBERSHIPS, FETCHING_MEMBERSHIPS } from '../actions/types';

const INITIAL_STATE = {
  memberships: null,
  total_pages: null,
  tags: [],
  page: null
};

export default (state = INITIAL_STATE, action) => {
  switch (action.type) {
  case DELETE_MEMBERSHIP:
    const id = action.payload.data.membership.id.toString();
    return {...state, memberships: state.memberships.filter(m => m.id !== id)};
  case FETCHING_MEMBERSHIPS:
    return INITIAL_STATE;
  case FETCH_MEMBERSHIPS:
    const { memberships, page, total_pages, tags } = action.payload.data;
    return { page, total_pages, memberships: memberships.data, tags };
  default:
    return state;
  }
};
