import React, { Component } from 'react';
import axios from 'axios';
import Member from './Member';
import queryString from 'query-string';
import Pagination from './Pagination';
import history from '../history';
import { connect } from 'react-redux';

import { fetchMembers } from '../actions'

class Members extends Component {
  componentWillMount() {
    this.props.fetchMembers(this.buildQuery(this.props));
  }

  buildQuery(props) {
    const { page } = queryString.parse(props.location.search);
    const query = { page };

    return `?${queryString.stringify(query)}`;
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.location.search !== nextProps.location.search)
      this.props.fetchMembers(this.buildQuery(nextProps));
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
        <table className='table'>
          <thead>
            <tr>
              <th>Name</th>
              <th>Phone</th>
              <th>Email</th>
              <th>Events</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {this.props.members.map(member => <Member key={member.id} member={member.attributes} />)}
          </tbody>
        </table>
        <br />
        {this.renderPagination()}
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const { members, total_pages, page } = state.members;
  return { members, total_pages, page };
};

export default connect(mapStateToProps, { fetchMembers })(Members);
