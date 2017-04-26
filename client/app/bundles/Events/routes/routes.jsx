import React from 'react';
import { Route } from 'react-router';

import Events from '../components/Events';

export default (
  <div>
    <Route path='/' component={Events} />
    <Route path='/:id' component={Events} />
  </div>
);
