import { combineReducers } from 'redux';

import EventsReducer from './EventsReducer';
import EventReducer from './EventReducer';
import AttendancesReducer from './AttendancesReducer';

const CurrentGroupReducer = (state = {}) => ( state );
const CurrentUserReducer = (state = {}) => ( state );

export default combineReducers({
  events: EventsReducer,
  event: EventReducer,
  attendances: AttendancesReducer,
  currentGroup: CurrentGroupReducer,
  currentUser: CurrentUserReducer
});
