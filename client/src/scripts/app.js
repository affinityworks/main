import ReactDOM from 'react-dom';
import React from 'react';
import Group from './containers/group';
import Header from './components/header/header';
import data from './sample-data';

require('./app.scss');

const view = (
  <div className="app">
    <Header />
    <Group group={data.group} />
  </div>
);

ReactDOM.render(
  view, document.getElementById('app')
);
