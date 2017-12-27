import { FETCH_EVENT, CREATE_EVENT, ATTENDANCE_CREATE_SUCCESS } from '../actions/types';

const INITIAL_STATE = {
  attributes: {},
  rsvpCount: 0,
  id: null
}

const EventReducer = (state = {}, action) => {
  switch (action.type) {
  case FETCH_EVENT:
    let { data } = action.payload.data;
    data.rsvpCount = data.attributes['rsvp-count']
    return data;
  case CREATE_EVENT:
    const evenData = action.payload.data;
    return { ...state,  attributes: evenData.data.attributes, id: evenData.data.id}
  case ATTENDANCE_CREATE_SUCCESS:
    return { ...state, rsvpCount: (state.rsvpCount + 1) }
  default:
    return state;
  }
};

export default EventReducer;
