import ReactDOM from 'react-dom';
import React from 'react';
import Group from './containers/group';
import Header from './components/header/header';

require('./app.scss');

const view = (
  <div className="app">
    <Header />
    <Group />
  </div>
);

ReactDOM.render(
  view, document.getElementById('app')
);
