import React, { Component} from 'react';
import { Router, browserHistory } from 'react-router-dom';
import routes from '../routes/routes';

import createHistory from 'history/createBrowserHistory';
const history = createHistory({ basename: '/events' });

class App extends Component {
  render() {
    return (
      <Router history={history}>
        {routes}
      </Router>
    )
  }
}

export default App;
