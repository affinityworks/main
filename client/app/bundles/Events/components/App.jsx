import React, { Component} from 'react';
import { Router } from 'react-router-dom';
import routes from '../routes/routes';
import { Provider } from 'react-redux';
import { createStore, applyMiddleware } from 'redux';
import ReduxPromise from 'redux-promise';
import thunk from 'redux-thunk';

import reducers from '../reducers/';
import history from '../history';

import Header from './Header';
import FlashMessages from './FlashMessages';

class App extends Component {
  render() {
    const { current_user, current_group, current_role, alerts } = this.props;
    const currentUser = current_user;
    const currentGroup = current_group;
    const currentRole = current_role;

    const storeWithMiddleware = createStore(reducers, {
      currentUser, currentGroup, currentRole, alerts
    }, applyMiddleware(ReduxPromise, thunk));

    return (
      <Provider store={storeWithMiddleware}>
        <Router history={history}>
          <div className='container'>
            <FlashMessages />
            <br />
            <Header/>
            {routes}
          </div>
        </Router>
      </Provider>
    )
  }
}

export default App;
