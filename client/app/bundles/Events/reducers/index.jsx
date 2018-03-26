import { combineReducers } from 'redux';

import events from './EventsReducer';
import event from './EventReducer';
import attendances from './AttendancesReducer';
import newAttendance from './AttendanceFormReducer';
import groups from './GroupsReducer';
import group from './GroupReducer';
import affiliates from './AffiliatesReducer';
import members from './MembersReducer';
import member from './MemberReducer';
import memberships from './MembershipsReducer';
import profile from './ProfileReducer';
import alerts from './AlertsReducer';
import featureToggles from './FeatureTogglesReducer';
import { reducer as form } from "redux-form";

const currentGroup = (state = {}) => ( state );
const currentUser = (state = {}) => ( state );
const currentRole = (state = {}) => ( state );

export default combineReducers({
  events,
  event,
  featureToggles,
  groups,
  group,
  members,
  member,
  memberships,
  attendances,
  newAttendance,
  profile,
  currentGroup,
  currentUser,
  currentRole,
  affiliates,
  alerts,
  form
});
