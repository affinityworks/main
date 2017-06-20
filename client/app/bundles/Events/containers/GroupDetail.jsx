import React, { Component } from 'react';
import axios from 'axios';
import { connect } from 'react-redux';

import UpcomingEvent from '../components/UpcomingEvent';
import { fetchGroup } from '../actions';

class GroupDetail extends Component {
  componentWillMount() {
    const { groupId } = this.props.match.params;

    this.props.fetchGroup(groupId);
  }

  upcoming_events() {
    const groupRelationships = this.props.group.relationships;

    if (!groupRelationships || !groupRelationships['upcoming-events'].data.length)
      return (<div>The group has not incoming events</div>);
    else {
      const events = groupRelationships['upcoming-events'].data;
      return events.map(event => <UpcomingEvent key={event.id} event={event} />)
    }
  }

  render() {
    const attributes = this.props.group.attributes;

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

const mapStateToProps = ({ group }) => {
  return { group }
};

export default connect(mapStateToProps, { fetchGroup })(GroupDetail);
