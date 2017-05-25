import React from 'react';

const EventAddress = ({ location }) => (
  <div>
    <div> {location.address_lines && location.address_lines.join(' ')}</div>
    <div className='address-1'>{location.venue}</div>
    <div className='state'>{location.locality} {location.region} {location.postal_code}</div>
  </div>
);

export default EventAddress;
