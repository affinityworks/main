import { combineReducers } from 'redux';

import EventsReducer from './EventsReducer';
import EventReducer from './EventReducer';
import AttendancesReducer from './AttendancesReducer';
import AttendanceFormReducer from './AttendanceFormReducer';
import GroupsReducer from './GroupsReducer';
import AffiliatesReducer from './AffiliatesReducer';
import GroupReducer from './GroupReducer';
import MembersReducer from './MembersReducer';
import MemberReducer from './MemberReducer';
import MembershipsReducer from './MembershipsReducer';
import ProfileReducer from './ProfileReducer';

const CurrentGroupReducer = (state = {}) => ( state );
const CurrentUserReducer = (state = {}) => ( state );
const CurrentRole = (state = {}) => ( state );

export default combineReducers({
  events: EventsReducer,
  event: EventReducer,
  groups: GroupsReducer,
  group: GroupReducer,
  members: MembersReducer,
  member: MemberReducer,
  memberships: MembershipsReducer,
  attendances: AttendancesReducer,
  newAttendance: AttendanceFormReducer,
  profile: ProfileReducer,
  currentGroup: CurrentGroupReducer,
  currentUser: CurrentUserReducer,
  currentRole: CurrentRole,
  affiliates: AffiliatesReducer
});
