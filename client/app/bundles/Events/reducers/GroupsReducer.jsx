import { FETCH_GROUPS } from '../actions/types';

const INITIAL_STATE = {
  groups: [],
  total_pages: null,
  page: null
};

export default (state = INITIAL_STATE, action) => {
  switch (action.type) {
  case FETCH_GROUPS:
    const { groups, page, total_pages } = action.payload.data
    return { page, total_pages, groups: groups.data };
  default:
    return state;
  }
};
