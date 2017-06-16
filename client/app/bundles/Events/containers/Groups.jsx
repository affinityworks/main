import React, { Component } from 'react';
import { connect } from 'react-redux';
import queryString from 'query-string';

import GroupsList from '../components/Groups';
import Nav from '../components/Nav';
import Breadcrumbs from '../components/Breadcrumbs';
import { fetchGroups } from '../actions';

class Groups extends Component {
  componentWillMount() {
    this.props.fetchGroups(this.buildQuery(this.props));
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.location.search !== nextProps.location.search)
      this.props.fetchGroups(this.buildQuery(nextProps));
  }

  buildQuery(props) {
    const { page, sort, direction, tag } = queryString.parse(props.location.search);
    const query = { page, sort, direction, tag };

    return `?${queryString.stringify(query)}`;
  }

  render() {
    const { currentGroup, groups, total_pages, page } = this.props;

    return (
      <div>
        <Breadcrumbs active='All Groups' location={this.props.location} />

        <br/>

        <Nav activeTab='groups' />

        <GroupsList
          location={this.props.location}
          groups={groups}
          total_pages={total_pages}
          page={page} />
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const { currentGroup } = state;
  const { groups, total_pages, page } = state.groups;

  return { currentGroup, groups, total_pages, page }
};

export default connect(mapStateToProps, { fetchGroups })(Groups);
