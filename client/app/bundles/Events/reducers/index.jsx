import { combineReducers } from 'redux';

import EventsReducer from './EventsReducer';
import EventReducer from './EventReducer';
import AttendancesReducer from './AttendancesReducer';
import AttendanceFormReducer from './AttendanceFormReducer';
import GroupsReducer from './GroupsReducer';
import GroupReducer from './GroupReducer';
import MembersReducer from './MembersReducer';
import MemberReducer from './MemberReducer';

const CurrentGroupReducer = (state = {}) => ( state );
const CurrentUserReducer = (state = {}) => ( state );

export default combineReducers({
  events: EventsReducer,
  event: EventReducer,
  groups: GroupsReducer,
  group: GroupReducer,
  members: MembersReducer,
  member: MemberReducer,
  attendances: AttendancesReducer,
  newAttendance: AttendanceFormReducer,
  currentGroup: CurrentGroupReducer,
  currentUser: CurrentUserReducer
});
