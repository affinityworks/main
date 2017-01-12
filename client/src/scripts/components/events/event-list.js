import React from 'react';
import Event from './event';
import style from './event.scss';

export default function EventList(props) {
  const eventItems = (props.events) ? props.events.map((event, index) => (
    <Event key={index} event={event} />
  )) : null;

  return (
    <div className="event-list" style={style}>
      {eventItems}
    </div>
  );
}

EventList.propTypes = {
  events: React.PropTypes.arrayOf(React.PropTypes.object),
};
