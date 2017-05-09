import React, { Component } from 'react';
import queryString from 'query-string';

import { Link } from 'react-router-dom';

class Pagination extends Component {
  renderPages() {
    return Array(this.props.totalPages).fill().map((_, i) => {
      const index = i + 1;

      return (
        <li
          key={index}
          className={`page-item ${this.props.page === index ? 'active' : ''}`}>
          <Link to={`?${this.buildQuery(index)}`} className='page-link' >
            { index }
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
