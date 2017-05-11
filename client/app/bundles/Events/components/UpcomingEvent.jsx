import React from 'react';
import moment from 'moment';
import { Link } from 'react-router-dom';

const UpcomingEvent = (props) => {
  const { attributes, id } = props.event;

  const formatDate = (date) => {
    if (date)
      return moment(date).format('Y-M-D H:mm');
  }

  return(
    <a href={attributes['browser-url']} className='list-group-item'>
      <div className='col-md-1'>
        <span className='badge badge-primary'>RSVP</span>
      </div>
      <div className='col-md-11'>
        {attributes.name} - {formatDate(attributes['start-date'])}
      </div>
    </a>
  );
};

export default UpcomingEvent;
