import { FETCH_MEMBERS } from '../actions/types';

const INITIAL_STATE = {
  members: [],
  total_pages: null,
  page: null
};

export default (state = INITIAL_STATE, action) => {
  switch (action.type) {
  case FETCH_MEMBERS:
    const { members, page, total_pages } = action.payload.data;
    return { page, total_pages, members: members.data };
  default:
    return state;
  }
};
