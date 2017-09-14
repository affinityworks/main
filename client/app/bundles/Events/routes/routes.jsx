import React from 'react';
import { Route, Switch } from 'react-router';

import Events from '../containers/Events';
import EventDetail from '../containers/EventDetail';
import Attendances from '../containers/Attendances';
import Groups from '../containers/Groups';
import Members from '../containers/Members';
import GroupDetail from '../containers/GroupDetail';
import Profile from '../containers/Profile';
import MemberDetail from '../containers/MemberDetail';
import EventImport from '../containers/EventImport';
import AttendanceMatching from '../containers/AttendanceMatching';
import AttendanceImport from '../containers/AttendanceImport';
import Dashboard from '../containers/Dashboard';

export default (
  <Switch>
    <Route path='/groups/:groupId/dashboard' component={Dashboard} />

    <Route path='/groups/:groupId/affiliates' component={Groups} />

    <Route path='/groups/:groupId/events/imports/new' component={EventImport} />
    <Route path='/groups/:groupId/events/imports/:id/attendances/new' component={AttendanceImport} />
    <Route path='/groups/:groupId/events/imports/:id/attendances' component={AttendanceMatching} />

    <Route path='/groups/:groupId/events/:id/attendances' component={Attendances} />

    <Route path='/groups/:groupId/events/:id' component={EventDetail} />
    <Route path='/groups/:groupId/events' component={Events} />

    <Route path='/groups/:groupId/members/:id' component={MemberDetail} />
    <Route path='/groups/:groupId/members' component={Members} />
    <Route path='/members/:id' component={MemberDetail} />

    <Route path='/profile' component={Profile} />

    <Route path='/groups/:groupId/' component={GroupDetail} />
  </Switch>
);
