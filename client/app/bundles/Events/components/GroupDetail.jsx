import React, { Component } from 'react';
import axios from 'axios';
import UpcomingEvent from './UpcomingEvent';

class GroupDetail extends Component {
  constructor(props) {
    super(props);

    this.state = { group: {} }
  }

  componentDidMount() {
    const groupId = this.props.match.params.id;

    axios.get(`/groups/${groupId}.json`)
      .then(res => {
        const group = res.data.data;
        this.setState({ group });
       });
  }

  upcoming_events() {
    const groupRelationships = this.state.group.relationships;

    if (!groupRelationships || !groupRelationships['upcoming-events'].data.length)
      return (<div>The group has not incoming events</div>);
    else {
      const events = groupRelationships['upcoming-events'].data;
      return events.map(event => <UpcomingEvent key={event.id} event={event} />)
    }
  }

  render() {
    const attributes = this.state.group.attributes;

    if(!attributes) { return null }

    return (
      <div>
        <div className='row'>
          <div className='col-md-12'>
            <div dangerouslySetInnerHTML={{ __html: attributes.description }} />
            <div>
              <hr/>
              <h3><i className='fa fa-calendar'/> Upcoming Events</h3>
              <br/>
              <div className='list-group'>
                {this.upcoming_events()}
              </div>
            </div>
          </div>
          <div className='col-md-4'>
          </div>
        </div>
      </div>
    );
  }
}

export default GroupDetail;
