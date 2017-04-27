import React from 'react';
import { Route, IndexRoute } from 'react-router';

import Events from '../components/Events';
import EventDetail from '../components/EventDetail';
import Attendances from '../components/Attendances';

export default (
  <div>
    <Route exact path='/' component={Events} />
    <Route exact path='/:id' component={EventDetail} />
    <Route path='/:id/attendances' component={Attendances} />
  </div>
);
