import React from 'react';
import { Route, Switch } from 'react-router';

import Events from '../components/Events';
import EventDetail from '../components/EventDetail';
import Attendances from '../components/Attendances';
import Groups from '../containers/Groups';
import Members from '../components/Members';
import GroupDetail from '../components/GroupDetail';
import Profile from '../containers/Profile';
import MemberDetail from '../components/MemberDetail';
import EventImport from '../components/EventImport';
import AttendanceMatching from '../containers/AttendanceMatching';
import Dashboard from '../containers/Dashboard';

export default (
  <Switch>
    <Route path='/groups/:groupId/dashboard' component={Dashboard} />

    <Route path='/groups/:groupId/events/imports/new' component={EventImport} />
    <Route path='/groups/:groupId/events/imports/:id/attendances' component={AttendanceMatching} />

    <Route path='/groups/:groupId/events/:id/attendances' component={Attendances} />

    <Route path='/groups/:groupId/events/:id' component={EventDetail} />
    <Route path='/groups/:groupId/events' component={Events} />

    <Route path='/groups/:groupId/members/:id' component={MemberDetail} />
    <Route path='/groups/:groupId/members' component={Members} />

    <Route path='/groups/:groupId/profile/' component={Profile} />

    <Route path='/groups/:groupId/affiliates' component={Groups} />
    
    <Route path='/groups/:groupId/' component={GroupDetail} />
  </Switch>
);
