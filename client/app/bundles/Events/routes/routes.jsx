import React from 'react';
import { Route, IndexRoute } from 'react-router';

import Events from '../components/Events';
import Attendances from '../components/Attendances';

export default (
  <div>
    <Route exact path='/' component={Events} />
    <Route path='/:id/attendances' component={Attendances} />
  </div>
);
