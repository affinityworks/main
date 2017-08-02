import React, { Component } from 'react';
import { connect } from 'react-redux';
import queryString from 'query-string';

import SearchFilter from './SearchFilter';
import MembersTable from './MembersTable';
import Pagination from './Pagination';
import { fetchMemberships } from '../actions'

class Members extends Component {
  constructor(props, _railsContext) {
    super(props);

    this.filterMembers = this.filterMembers.bind(this);
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

  render() {
    const { memberships, showGroupName, location } = this.props
    const { search } = location;
    const { filter } = queryString.parse(search);

    return (
      <div>
        <div className='row'>
          <div className='col-6'>
            <SearchFilter
              onSearchSubmit={this.filterMembers}
              filter={filter}
              placeholder='Search for your people' />
          </div>
        </div>
        <br />
        <div>
          <a href="members/new">
            <button className='btn btn-primary'>Add Member</button>
          </a>
        </div>

        <br />

        <MembersTable memberships={memberships} showGroupName={showGroupName} />

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
