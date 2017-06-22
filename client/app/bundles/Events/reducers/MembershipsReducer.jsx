import { FETCH_MEMBERSHIPS, FETCHING_MEMBERSHIPS } from '../actions/types';

const INITIAL_STATE = {
  memberships: null,
  total_pages: null,
  page: null
};

export default (state = INITIAL_STATE, action) => {
  switch (action.type) {
  case FETCHING_MEMBERSHIPS:
    return INITIAL_STATE;
  case FETCH_MEMBERSHIPS:
    const { memberships, page, total_pages } = action.payload.data
    return { page, total_pages, memberships: memberships.data };
  default:
    return state;
  }
};
