import React, { Component} from 'react';
import { Router } from 'react-router-dom';
import routes from '../routes/routes';

import history from '../history';

import Header from './Header';
import Nav from './Nav';

class App extends Component {
  render() {
    return (
      <Router history={history}>
        <div className='container'>
          <Nav />
          {routes}
        </div>
      </Router>
    )
  }
}

export default App;
