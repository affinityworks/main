import React from 'react';

const EventsFilter = (props) => {
  return (
    <div className='input-group'>
      <input type='text' className='form-control' placeholder='Search by event name, host, location or status' />
       <span className='input-group-btn'>
         <button className='btn btn-secondary'> Search </button>
       </span>
    </div>
  );
}

export default EventsFilter;
