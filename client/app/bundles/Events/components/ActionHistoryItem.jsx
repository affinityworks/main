import React from 'react';
import { Link } from 'react-router-dom';

import { formatDay } from '../utils';
import { eventPath } from '../utils/Pathnames';

const ActionHistoryItem = ({ attendance }) => {
  const { attended } = attendance.attributes

  if (!attendance.attributes.event) { return null }

  const event = attendance.attributes.event.data;

  return (
    <div className='list-group-item'>
      <Link to={eventPath(event.id)} style={{ marginRight: '10px' }}>
        {event.attributes.title}
      </Link>
      <span style={{ marginRight: '10px' }}>
        {formatDay(event.attributes['start-date'])}
      </span>
      {attended == false && <span style={{ color: '#d9534f' }}> Missed </span>}
      {attended && <span style={{ color: '#5cb85c' }}> Attended </span>}
    </div>
  )
}

export default ActionHistoryItem;
