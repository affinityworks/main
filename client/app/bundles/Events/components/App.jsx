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

class App extends Component {
  render() {
    const currentUser = this.props.current_user;
    const currentGroup = this.props.current_group;

    const storeWithMiddleware = createStore(reducers, {
      currentUser, currentGroup
    }, applyMiddleware(ReduxPromise, thunk));

    return (
      <Provider store={storeWithMiddleware}>
        <Router history={history}>
          <div className='container'>
            <Header/>
            {routes}
          </div>
        </Router>
      </Provider>
    )
  }
}

export default App;
