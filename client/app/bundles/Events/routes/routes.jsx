import React from 'react';
import { Route, IndexRoute, browserHistory, BrowserRouter as Router } from 'react-router';

import Events from '../components/Events';

export default (
  <div>
    <Route path='/' component={Events} />
    <Route path='/:id' component={Events} />
  </div>
);
