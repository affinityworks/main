import React from 'react';

const EventsFilter = (props) => {
  return (
    <div className='container'>
      <ul className="nav nav-tabs">
        <li className="nav-item">
          <a className="nav-link active" href="#">Events</a>
        </li>
      </ul>

      <div className="tab-content">
        <div className="tab-pane active" id="home" role="tabpanel">
          <h3><i className="fa fa-calendar"></i> Events Attendance</h3>
          <div id="event_filter_controls">
            Filter events by date:
            <select>
              <option>Upcoming</option>
              <option>Past</option>
              <option>Date range</option>
            </select>
            by type:
            <select>
              <option>Meeting</option>
              <option>Rally/protest</option>
              <option>Town hall</option>
              <option>Direct action</option>
            </select>
          </div>
        </div>
      </div>
    </div>
  );
}

export default EventsFilter;
