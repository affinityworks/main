import React from 'react';

export default function Event(props) {
  const {
    name,
    date,
    start_time: startTime,
    description,
    location,
  } = props.event;

  return (
    <div className="event">
      <div className="event-date">{date} {startTime}</div>
      <span className="event-title">{name}</span>
      <div className="event-content">
        {description}
      </div>
      <dl className="event-location">
        <dd>{location.address}</dd>
        <dd>{location.city}</dd>
        <dd>{location.state}</dd>
      </dl>
    </div>
  );
}

Event.propTypes = {
  event: React.PropTypes.shape({
    name: React.PropTypes.string,
    description: React.PropTypes.string,
    date: React.PropTypes.string,
    location: React.PropTypes.shape({
      city: React.PropTypes.string,
      address: React.PropTypes.string,
      state: React.PropTypes.string,
    }),
    startTime: React.PropTypes.string,
  }),
};
