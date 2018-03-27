import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';

import Address from '../components/Address';
import { fetchEvent, fetchGroup } from '../actions';
import GoogleMap from '../components/GoogleMap';
import { formatDay, formatTime, eventsPath, groupPath } from '../utils';

class EventDetail extends Component {
  componentWillMount() {
    const { groupId, id} = this.props.match.params;
    this.props.fetchEvent(id);
    this.props.fetchGroup(groupId);
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
      return <Address location={location}/>
  }

  showCreator() {
    const { creator } = this.props.event.attributes;

    if (!creator || !creator.data) { return null }

    const { attributes } = creator.data;

    return(
      <div>
        <span> Event Organizer: </span>
        <a href={`mailto:${attributes['primary-email-address']}`}
           target="_blank" >
          {`${attributes['given-name']} ${attributes['family-name']}`}
        </a>
      </div>
    )
  }

  showActionNetworkLink() {
    const { attributes } = this.props.event;

    if (!attributes['browser-url']) { return false }

    return(
      <div>
        <a href={attributes['browser-url']}> Action Network Page </a>
      </div>
    );
  }

  render() {
    const { attributes } = this.props.event;
    const { group } = this.props;

    if(!attributes || !group.attributes) { return null }

    return (
      <div>
        <Link to={`${groupPath(group.id)}`}>
          <h2>{group.attributes.name}</h2>
        </Link>

        <br/>

        <div className='row'>
          <div className='col-6'>

            <h3>{attributes.title}</h3>

            <div>{formatDay(attributes['start-date'])}</div>
            <div>{formatTime(attributes['start-date'])}</div>

            {this.showCreator()}
          </div>

          <div className='col-6'>
            <div className='badge badge-primary col-2'>
              {`${attributes['rsvp-count']} RSVPs`}
            </div>

            {this.showActionNetworkLink()}
          </div>
        </div>

        <br/>

        {this.showAddress()}

        <br/>

        <div style={{width: '100%', height: '400px'}}>{this.showMap()}</div>
        <Link to={`${eventsPath()}`}>
          <button className='btn btn-primary'>Back to Events</button>
        </Link>
      </div>
    )
  }
}

const mapStateToProps = ({ event, group }) => {
  return { event, group }
};

export default connect(mapStateToProps, { fetchEvent, fetchGroup })(EventDetail);
