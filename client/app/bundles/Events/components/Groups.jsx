import React, { Component } from 'react';
import axios from 'axios';
import { connect } from 'react-redux';
import queryString from 'query-string';

import Group from './Group';
import { fetchGroups } from '../actions';
import Pagination from './Pagination';
import Nav from './Nav';

class Groups extends Component {
  componentWillMount() {
    this.props.fetchGroups(this.buildQuery(this.props));
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.location.search !== nextProps.location.search)
      this.props.fetchGroups(this.buildQuery(nextProps));
  }

  buildQuery(props) {
    const { page } = queryString.parse(props.location.search);
    const query = { page };

    return `?${queryString.stringify(query)}`;
  }

  renderPagination() {
    const { total_pages, page, location } = this.props;
    if (total_pages) {
      return <Pagination
        page={page}
        totalPages={total_pages}
        currentSearch={location.search} />
    }
  }

  render() {
    return (
      <div>
        <Nav activeTab='groups' />

        <table className='table table-striped'>
          <thead>
            <tr>
              <th>Name</th>
              <th>Location</th>
              <th>Description</th>
              <th>Public Contact</th>
              <th>Leaders</th>
              <th>Internal Notes</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {this.props.groups.map(group => <Group key={group.id} group={group} />)}
          </tbody>
        </table>
        <br />
        {this.renderPagination()}
      </div>

    );
  }
}

const mapStateToProps = (state) => {
  const { groups, total_pages, page } = state.groups;
  return { groups, total_pages, page };
};

export default connect(mapStateToProps, { fetchGroups })(Groups);
