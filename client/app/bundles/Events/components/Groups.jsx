import React, { Component } from 'react';

import Group from './Group';
import SortableHeader from './SortableHeader';
import Pagination from './Pagination';

class Groups extends Component {
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

export default Groups;
