import { combineReducers } from 'redux';

import EventsReducer from './EventsReducer';
import EventReducer from './EventReducer';

const CurrentGroupReducer = (state = {}) => ( state );
const CurrentUserReducer = (state = {}) => ( state );

export default combineReducers({
  events: EventsReducer,
  event: EventReducer,
  currentGroup: CurrentGroupReducer,
  currentUser: CurrentUserReducer
});
