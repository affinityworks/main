import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import axios from 'axios';
import { connect } from 'react-redux';

import EventAddress from './EventAddress';
import { fetchEvent } from '../actions';
import GoogleMap from './GoogleMap';
import { formatDateTime } from '../utils';

class EventDetail extends Component {
  componentWillMount() {
    const eventId = this.props.match.params.id;
    this.props.fetchEvent(eventId);
  }

  showMap() {
    const { location } = this.props.event.attributes;

    //NOTE we need to update this when we know all the data is present.
    if (location && location.location && location.location.latitude && location.location.longitude)
      return(
        <GoogleMap
          lat={location.location.latitude}
          lng={location.location.longitude}
          width={550}
          height={300}
          zoom={14}
          apiKey="AIzaSyDa2U99OyqeAOz1ZBqtUD2yNKXR00VYrM8"
        />
      );

    return <div><h2>No location available</h2></div>
  }

  showAddress() {
    const { location } = this.props.event.attributes
    if (location)
      return <EventAddress location={location}/>
  }

  render() {
    const attributes = this.props.event.attributes;

    if(!attributes) { return null}

    return (
      <div>
        <h1>{attributes.title}</h1>
        <br/>
        <h3>{formatDateTime(attributes['start-date'])}</h3>
        <div dangerouslySetInnerHTML={{ __html: attributes.description }} />
        <br/>
        {this.showAddress()}
        <br/>
        <div style={{width: '100%', height: '400px'}}>{this.showMap()}</div>
        <Link to='/events/'>
          <button className='btn btn-primary'>Back to Events</button>
        </Link>
      </div>
    )
  }
}

const mapStateToProps = ({ event }) => {
  return { event }
};

export default connect(mapStateToProps, { fetchEvent })(EventDetail);
