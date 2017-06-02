import React, { Component } from 'react';
import axios from 'axios';
import queryString from 'query-string';
import { connect } from 'react-redux';

import Member from './Member';
import MembersFilter from './MembersFilter';
import Pagination from './Pagination';
import { fetchMemberships } from '../actions'

class Members extends Component {
  constructor(props, _railsContext) {
    super(props);

    this.filterMembers = this.filterMembers.bind(this);
    this.renderMembers = this.renderMembers.bind(this);
  }

  componentWillMount() {
    this.props.fetchMemberships(this.props.location.search);
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.location.search !== nextProps.location.search)
      this.props.fetchMemberships(nextProps.location.search);
  }

  filterMembers(filter) {
    this.props.history.push(`?${queryString.stringify({ filter })}`);
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

  renderMembers() {
    return this.props.memberships.map(membership => {
      const person = membership.attributes.person.data;
      return <Member key={person.id} id={person.id}
        member={person.attributes}
        role={membership.attributes.role}
      />
    })
  }

  render() {
    const { search } = this.props.location;
    const { filter, direction } = queryString.parse(search);

    return (
      <div>
        <div className='row'>
          <div className='col-6'>
            <MembersFilter onSearchSubmit={this.filterMembers} filter={filter} />
          </div>
        </div>

        <br />
        <table className='table'>
          <thead>
            <tr>
              <th>Name</th>
              <th>Phone</th>
              <th>Location</th>
              <th>Role</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {this.renderMembers()}
          </tbody>
        </table>
        <br />
        {this.renderPagination()}
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const { memberships, total_pages, page } = state.memberships;
  return { memberships, total_pages, page };
};

export default connect(mapStateToProps, { fetchMemberships })(Members);
