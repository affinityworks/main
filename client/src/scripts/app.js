import React from 'react';
import { render } from 'react-dom';
import { BrowserRouter, Match, Miss } from 'react-router';

import Overview from './containers/overview';
import Group from './containers/group';

require('./app.scss');


const Root = () => (
  <BrowserRouter>
    <div className="view">
      <Match exactly pattern="/" component={Overview} />
      <Match pattern="/group/:groupSlug" component={Group} />
      <Match pattern="/event" component={Overview} />
      <Match pattern="/login" component={Overview} />
      <Miss component={Overview} />
    </div>
  </BrowserRouter>
);

render(<Root />, document.querySelector('#mount'));
