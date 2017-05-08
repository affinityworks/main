import { combineReducers } from 'redux';

import EventsReducer from './EventsReducer';

const CurrentGroupReducer = (state = {}) => ( state );
const CurrentUserReducer = (state = {}) => ( state );

export default combineReducers({
  events: EventsReducer,
  currentGroup: CurrentGroupReducer,
  currentUser: CurrentUserReducer
});
