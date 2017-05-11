import { combineReducers } from 'redux';

import EventsReducer from './EventsReducer';
import EventReducer from './EventReducer';
import AttendancesReducer from './AttendancesReducer';
import GroupsReducer from './GroupsReducer';
import GroupReducer from './GroupReducer';
import MembersReducer from './MembersReducer';

const CurrentGroupReducer = (state = {}) => ( state );
const CurrentUserReducer = (state = {}) => ( state );

export default combineReducers({
  events: EventsReducer,
  event: EventReducer,
  groups: GroupsReducer,
  group: GroupReducer,
  members: MembersReducer,
  attendances: AttendancesReducer,
  currentGroup: CurrentGroupReducer,
  currentUser: CurrentUserReducer
});
