import React, { Component } from 'react';

import Header from '../components/header/header';
import Search from '../components/forms/search';

import getData from '../util/get-data';

import style from './overview.scss';

// sample data hosted as json
// const uri = 'https://benvoluto.github.io/ac-sample.json';
const uri = '/ac-sample.json';

function List(props) {
  let groupsList = null;
  groupsList = props.items.map((item, index) => (
    <Item key={index} item={item} />
  ));
  return (
    <div className="groups-list">
      {groupsList}
    </div>
  );
}

function Item(props) {
  return (
    <a
      href={`/group/${props.item.group.slug}`}
      className="group-link"
      key={props.item.key}
    >{props.item.group.name}</a>
  );
}

class Overview extends Component {
  constructor() {
    super();
    this.goToGroup = this.goToGroup.bind(this);

    this.state = {
      groupList: [],
    };
  }

  componentDidMount() {
    getData(uri)
      .then((dataResponse) => {
        this.setState({
          groupList: dataResponse,
        });
      });
  }

  goToGroup(e, slug) {
    e.preventDefault();
    this.context.router.transitionTo(`/group/${slug}`);
  }

  render() {
    return (
      <div className="wrap">
        <Header current="group" />
        <div className="overview" style={style}>
          <Search suggestion="Enter a City or Zip Code" />
          <List items={this.state.groupList} />
        </div>
      </div>
    );
  }

}

Overview.contextTypes = {
  router: React.PropTypes.object,
};

Item.propTypes = {
  item: React.PropTypes.shape({
    key: React.PropTypes.string,
    group: React.PropTypes.object,
  }),
};

List.propTypes = {
  items: React.PropTypes.arrayOf(
    React.PropTypes.object,
  ),
};

export default Overview;
