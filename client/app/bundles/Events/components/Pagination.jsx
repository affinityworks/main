import React, { Component } from 'react';
import queryString from 'query-string';
import _ from 'lodash';

import { Link } from 'react-router-dom';

class Pagination extends Component {

  paginationSize() {
    return this.props.totalPages < 10 ? this.props.totalPages : 10;
  }

  pages() {
    const { totalPages, page } = this.props;

    if (totalPages < 10) // less than 10 total pages so show all
      return _.range(1, totalPages + 1);
    else {
      // more than 10 total pages so calculate start and end pages
      if (page <= 6)
        return _.range(1, 11);
      else if (page + 4 >= totalPages)
        return _.range(totalPages - 9, totalPages + 1);
      else
        return _.range(page - 5, page + 5);
    }
  }

  renderPages() {
    return this.pages().map((pageNumber) => {
      return (
        <li
          key={pageNumber}
          className={`page-item ${this.props.page === pageNumber ? 'active' : ''}`}>
          <Link to={`?${this.buildQuery(pageNumber)}`} className='page-link' >
            { pageNumber }
          </Link>
        </li>
      );
    });
  }

  renderPreviousPage() {
    const previousLink = `?${this.buildQuery(this.props.page - 1)}`;

    return (
      <li className={`page-item ${this.props.page === 1 ? 'disabled' : ''}`}>
        <Link to={previousLink} className="page-link">
          <span aria-hidden="true">&laquo;</span>
          <span className="sr-only">Previous</span>
        </Link>
      </li>
    );
  }

  renderNextPage() {
    const active = this.props.totalPages === this.props.page;
    const nextLink = `?${this.buildQuery(this.props.page + 1)}`;

    return (
      <li className={`page-item ${active ? 'disabled' : ''}`}>
        <Link to={nextLink} className="page-link">
          <span aria-hidden="true">&raquo;</span>
          <span className="sr-only">Next</span>
        </Link>
      </li>
    );
  }

  buildQuery(page) {
    const params = queryString.parse(this.props.currentSearch);

    return queryString.stringify({ ...params, page: page })
  }

  render() {
    return (
      <nav aria-label="Page navigation example" style={navStyle}>
        <ul className="pagination">
          {this.renderPreviousPage()}

          {this.renderPages()}

          {this.renderNextPage()}
        </ul>
      </nav>
    );
  }
}

const navStyle = {
  display: 'flex',
  justifyContent: 'center'
};

export default Pagination;
