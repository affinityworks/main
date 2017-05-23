import React from 'react';
import { Route, Switch } from 'react-router';

import Events from '../components/Events';
import EventDetail from '../components/EventDetail';
import Attendances from '../components/Attendances';
import Groups from '../components/Groups';
import Members from '../components/Members';
import NewAttendance from '../containers/NewAttendance';
import GroupDetail from '../components/GroupDetail';
import Profile from '../components/Profile';
import MemberDetail from '../components/MemberDetail';

export default (
  <Switch>
    <Route path='/events/:id/attendances/new' component={NewAttendance} />
    <Route path='/events/:id/attendances' component={Attendances} />

    <Route path='/events/:id' component={EventDetail} />
    <Route path='/events' component={Events} />

    <Route path='/members/:id' component={MemberDetail} />
    <Route path='/members' component={Members} />

    <Route path='/groups/:id' component={GroupDetail} />
    <Route path='/groups' component={Groups} />
    <Route path='/profile/' component={Profile} />
  </Switch>
);
