import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import RemoteEventMatches from './RemoteEventMatches';
import RemoteEvent from './RemoteEvent';

class RemoteEventMatch extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    const { remoteEvent, events } = this.props;

    if (!remoteEvent)
      return <div><h2>We could not find an Event for the given url.</h2></div>
    else if (!remoteEvent.name)
      return null;

    return (
      <div className='row'>
        <div className='col-4'>
          <RemoteEvent event={remoteEvent} />
        </div>
        <div className='col-4'>
          <RemoteEventMatches date={remoteEvent.start_time} events={events} />
          <br/>
          <div>
            <a href='#'>Search other Affinity Events.</a>
          </div>
        </div>
        <div className='col-3 offset-1'>
          <div className='row'>
            <div className='btn btn-success'>Sync RSVP's</div>
          </div>
          <br />
          <div className='row'>
            <Link className='btn btn-primary' to={`/events`}>
              Back to Events
            </Link>
          </div>
        </div>
      </div>
    );
  }
}

export default RemoteEventMatch;
