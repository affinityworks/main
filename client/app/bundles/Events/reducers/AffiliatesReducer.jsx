import { FETCH_AFFILIATES } from '../actions/types';

const INITIAL_STATE = {
  affiliates: [],
  total_pages: null,
  page: null
};

export default (state = INITIAL_STATE, action) => {
  switch (action.type) {
  case FETCH_AFFILIATES:
    const { affiliates, page, total_pages } = action.payload.data
    return { page, total_pages, affiliates: affiliates.data };
  default:
    return state;
  }
};
