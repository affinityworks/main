import React from 'react';

const EventAddress = (props) => (
  <div>
    <div className='address-1'>{props.location.venue}</div>
    <div className='state'>{props.location.locality} {props.location.region} {props.location.postal_code}</div>
  </div>
);

export default EventAddress;
