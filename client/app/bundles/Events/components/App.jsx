import React, { Component} from 'react';
import { Router } from 'react-router-dom';
import routes from '../routes/routes';
import { Provider } from 'react-redux';
import { createStore } from 'redux';

import reducers from '../reducers/';
import history from '../history';

import Header from './Header';
import Nav from './Nav';

class App extends Component {
  render() {
    const currentUser = this.props.current_user;
    const currentGroup = this.props.current_group;

    return (
      <Provider store={createStore(reducers, { currentUser, currentGroup })}>
        <Router history={history}>
          <div className='container'>
            <Header/>
            <Nav />
            {routes}
          </div>
        </Router>
      </Provider>
    )
  }
}

export default App;
