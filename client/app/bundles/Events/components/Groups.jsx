import React, { Component } from 'react';
import axios from 'axios';
import { connect } from 'react-redux';
import queryString from 'query-string';

import Group from './Group';
import SortableHeader from './SortableHeader';
import { fetchGroups } from '../actions';
import Pagination from './Pagination';

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
    const { groups } = this.props;

    return (
      <div>
        <table className='table table--fixed'>
          <thead>
            <tr>
              <SortableHeader title='Group Name' sortBy='name' />
              <th>Location</th>
              <th>Tags</th>
              <SortableHeader title='Owner' sortBy='owner' />
            </tr>
          </thead>

          <tbody>
            {groups.map(group => <Group key={group.id} group={group} linkToDashboard={true} />)}
          </tbody>
        </table>
        <br />
        {this.renderPagination()}
      </div>

    );
  }
}

const mapStateToProps = (props) => {
  const { groups, total_pages, page } = props.groups;

  return { groups, total_pages, page };
};

export default connect(mapStateToProps, { fetchGroups })(Groups);
