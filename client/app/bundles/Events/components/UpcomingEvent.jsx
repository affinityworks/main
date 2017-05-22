import React from 'react';
import { Link } from 'react-router-dom';

import { formatDateTime } from '../utils';

const UpcomingEvent = (props) => {
  const { attributes, id } = props.event;

  return(
    <a href={attributes['browser-url']} className='list-group-item'>
      <div className='col-md-1'>
        <span className='badge badge-primary'>RSVP</span>
      </div>
      <div className='col-md-11'>
        {attributes.title} - {formatDateTime(attributes['start-date'])}
      </div>
    </a>
  );
};

export default UpcomingEvent;
