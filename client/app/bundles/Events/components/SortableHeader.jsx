import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import { withRouter } from 'react-router'
import queryString from 'query-string';

import { addParamToQuery, removeParamFromQuery } from '../utils';

class SortableHeader extends Component {
  render() {
    const { location, sortBy, title, className, style } = this.props;
    const { direction, sort } = queryString.parse(location.search);
    const currentDirection = sortBy === sort ? direction : 'desc';
    const oppositeDirection = currentDirection == 'desc' ? 'asc' : 'desc';

    const directionQuery = addParamToQuery(location.search, { direction: oppositeDirection, sort: sortBy });

    return (
      <th className={className} style={style}>
        <Link to={directionQuery} style={{ color: 'black', textDecoration: 'none' }}>
          {`${title} `}
          <i className={`fa fa-angle-${currentDirection == 'desc' ? 'down' : 'up'} fa-lg`} />
        </Link>
      </th>
    );
  }
}

export default withRouter(SortableHeader);
