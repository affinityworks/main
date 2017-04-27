import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import axios from 'axios';
import moment from 'moment';
import EventAddress from './EventAddress';
import GoogleStaticMap from 'react-google-static-map-2';

class EventDetail extends Component {
  constructor(props) {
    super(props);

    this.state = { event: {} }
  }

  componentDidMount() {
    const eventId = this.props.match.params.id;

    axios.get(`/events/${eventId}.json`)
      .then(res => {
        const event = res.data.data;
        this.setState({ event });
      });
  }

  formatDate(date) {
    if (date)
      return moment(date).format('Y-M-D H:mm');
  }

  showMap() {
    const location = this.state.event.attributes.location;

    //NOTE we need to update this when we know all the data is present.
    if (location && location.location && location.location.latitude && location.location.longitude)
      return(
        <GoogleStaticMap
          latitude={location.location.latitude.toString()}
          longitude={location.location.longitude.toString()}
          zoom={13}
          size={{ width: 550, height: 300 }}
        />
      );
<<<<<<< HEAD
=======

>>>>>>> b03ba951da5b490af9b9164a6f14b9b31eed566b
    return <div><h2>No location available</h2></div>
  }

  showAddress() {
    const location = this.state.event.attributes.location
    if (location)
      return <EventAddress location={location}/>
  }

  render() {
    console.log(this.state);
    const attributes = this.state.event.attributes;

    if(!attributes) { return null}

    return (
      <div>
        <h1>{attributes.title}</h1>
        <br/>
        <h3>{this.formatDate(attributes['start-date'])}</h3>
        <div dangerouslySetInnerHTML={{ __html: attributes.description }} />
        <br/>
        {this.showAddress()}
        <br/>
        <div style={{width: '100%', height: '400px'}}>{this.showMap()}</div>
        <Link to='/'>
          <button className='btn btn-primary'>Back to Events</button>
        </Link>
      </div>
    )
  }
}

export default EventDetail;
