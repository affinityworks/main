import React from 'react';
import { Link } from 'react-router-dom';

import { formatDay } from '../utils';
import { eventPath } from '../utils/Pathnames';

const ActionHistoryItem = ({ attendance }) => {
  const { attended } = attendance.attributes
  const event = attendance.attributes.event.data;

  return (
    <div className='list-group-item'>
      <Link to={eventPath(event.id)} style={{ marginRight: '10px' }}>
        {event.attributes.title}
      </Link>
      <span style={{ marginRight: '10px' }}>
        {formatDay(event.attributes['start-date'])}
      </span>
      {attended == false && <i className='fa fa-times fa-2x' style={{ color: '#d9534f' }} />}
      {attended && <i className='fa fa-check fa-2x' style={{ color: '#5cb85c' }} />}
    </div>
  )
}

export default ActionHistoryItem;
