import { combineReducers } from 'redux';

import EventsReducer from './EventsReducer';
import EventReducer from './EventReducer';
import AttendancesReducer from './AttendancesReducer';
import GroupsReducer from './GroupsReducer';

const CurrentGroupReducer = (state = {}) => ( state );
const CurrentUserReducer = (state = {}) => ( state );

export default combineReducers({
  events: EventsReducer,
  event: EventReducer,
  groups: GroupsReducer,
  attendances: AttendancesReducer,
  currentGroup: CurrentGroupReducer,
  currentUser: CurrentUserReducer
});
