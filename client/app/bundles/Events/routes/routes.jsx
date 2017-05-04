import React from 'react';
import { Route, Switch } from 'react-router';

import Events from '../components/Events';
import EventDetail from '../components/EventDetail';
import Attendances from '../components/Attendances';
import Groups from '../components/Groups';

export default (
  <Switch>
    <Route path='/events/:id/attendances' component={Attendances} />
    <Route path='/events/:id' component={EventDetail} />
    <Route path='/events/' component={Events} />
    <Route path='/groups' component={Groups} />
  </Switch>
);
