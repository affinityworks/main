import React, { Component} from 'react';
import { Router, browserHistory } from 'react-router-dom';
import routes from '../routes/routes';

import createHistory from 'history/createBrowserHistory';
const history = createHistory({ basename: '/events' });

import Header from './header';

class App extends Component {
  render() {
    return (
      <Router history={history}>
        <div className='container'>
          <Header />
          {routes}
        </div>
      </Router>
    )
  }
}

export default App;
