import React from 'react';
import { Link } from 'react-router-dom';

import { addParamToQuery, removeParamFromQuery } from '../utils';

const SortToggle = ({ search, title, currentDirection }) => {
  const oppositeDirection = currentDirection == 'desc' ? 'asc' : 'desc';

  const directionQuery = addParamToQuery(search, { direction: oppositeDirection });

  return (
    <Link to={directionQuery}>
      <button className='btn btn-secondary'>
        {`${title} `}
        <i className={`fa fa-angle-${currentDirection == 'desc' ? 'down' : 'up'} fa-lg`} />
      </button>
    </Link>
  );
};

export default SortToggle;
