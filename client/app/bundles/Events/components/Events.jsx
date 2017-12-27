import React, { PropTypes, Component } from 'react';
import queryString from 'query-string';
import { connect } from 'react-redux';

import Event from './Event';
import SearchFilter from './SearchFilter';
import Pagination from './Pagination';
import SortableHeader from './SortableHeader';
import { fetchEvents, fetchGroup, createEvent, fetchGroup } from '../actions';
import UpcomingEvent from '../components/UpcomingEvent';
import DateRange from '../components/DateRange';
import EventCreate from '../components/EventCreate';

import UserAuth from '../components/UserAuth';
import { isAllowed, eventsPath } from "../utils";


class Events extends Component {
  state = {
    showCreateEvent: false
  }

  constructor(props, _railsContext) {
    super(props);

    this.filterEvents = this.filterEvents.bind(this);
    this.renderEvents = this.renderEvents.bind(this);
    this.groupColumn = this.groupColumn.bind(this);
    this.printColumn = this.printColumn.bind(this);
    this.displayEventCreate = this.displayEventCreate.bind(this);
    this.handleCancel = this.handleCancel.bind(this);
  }

  componentWillMount() {
    const { fetchGroup, fetchEvents, location, currentGroup, currentRole } = this.props
    const groupId = currentGroup.id

    isAllowed(['member'], currentRole)
      ? fetchGroup(groupId)
      : fetchEvents(location.search)
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.location.search !== nextProps.location.search)
      this.props.fetchEvents(nextProps.location.search);
  }

  filterEvents(filter) {
    this.props.history.push(`?filter[name]=${filter}`);
  }

  renderPagination() {
    const { total_pages, page, location } = this.props;
    if (total_pages) {
      return <Pagination
        page={page}
        totalPages={total_pages}
        currentSearch={location.search} />
    }
  }

  displayEventCreate = () => {
    this.setState({ showCreateEvent: true });
  }

  handleCancel = () => {
    this.setState({ showCreateEvent: false })
  }

  groupColumn() {
    if (this.props.showGroupName)
      return <SortableHeader title='Group Name' sortBy='group_name' />
  }

  printColumn() {
    if (this.props.showPrintIcon)
      return <th></th>
  }

  upcoming_events() {
    const groupRelationships = this.props.group.relationships;

    if (!groupRelationships || !groupRelationships['upcoming-events'].data.length)
      return (<div>The group has no incoming events</div>);
    else {
      const events = groupRelationships['upcoming-events'].data;
      return events.map(event => <UpcomingEvent key={event.id} event={event} />)
    }
  }

  renderEvents() {
    return this.props.events.map(event => (<Event
      key={event.id} event={event}
      showGroupName={this.props.showGroupName}
      showPrintIcon={this.props.showPrintIcon}
      tagsEventList={this.props.tags}
    />))
  }

  render() {
    const { search } = this.props.location;
    const { filter, direction } = queryString.parse(search);
    const { id } = this.props.currentGroup
    const { currentUser, currentGroup, location, createEvent } = this.props

    if (this.state.showCreateEvent) {
      return (
        <div className='row'>
          <UserAuth allowed={['organizer']}>
            <div className='col-md-12'>
              <EventCreate
                handleCancel={this.handleCancel}
                currentGroup={currentGroup}
                location={location}
                history={this.props.history}
                createEvent={createEvent}
              />
            </div>
          </UserAuth>
        </div>
      )
    }

    return (
      <div>
      <UserAuth allowed={['member']}>
        <div className='col-md-12 mb-4 mt-5'>
          <h3><i className='fa fa-calendar'/> Upcoming Events</h3>
          <br/>
          {this.upcoming_events()}
        </div>
      </UserAuth>
       <UserAuth allowed={['organizer', 'volunteer']}>
        <div>
          <div className='row'>
            <div className='col-5'>
              <SearchFilter
                onSearchSubmit={this.filterEvents}
                filter={filter}
                placeholder='Search by event name or location' />
            </div>
            <UserAuth allowed={['organizer']}>
              <button
                className='btn btn-primary mr-2'
                onClick={this.displayEventCreate}
              >
                Add Event
              </button>
            </UserAuth>
            <DateRange history={this.props.history} />
            <UserAuth allowed={['organizer']}>
              <div className='col-3 text-right'>
                <a href={`/admin/auth/facebook?group_id=${id}`} className='btn btn-facebook'>
                  Import Event From Facebook
                </a>
              </div>
            </UserAuth>
          </div>
          <br/>
          <table className={`table ${this.props.showPrintIcon ? '' : 'table--fixed'}`}>
            <thead>
              <tr>
                <SortableHeader title='Event Name' sortBy='title' />
                <SortableHeader title='Date' sortBy='start_date' />
                <th>Location</th>
                { this.groupColumn() }
                <th>
                  <UserAuth allowed={['organizer']}>
                    <span>Tags</span>
                  </UserAuth>
                </th>
                <th>RSVPs</th>
                { this.printColumn() }
              </tr>
            </thead>
            <tbody>
              {this.renderEvents()}
            </tbody>
          </table>
          <br />
          {this.renderPagination()}
          </div>
       </UserAuth>        
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  const { group, currentRole, events: { events, total_pages, page, tags } } = state

  return { events, total_pages, page, tags, group, currentRole };
}

export default connect(mapStateToProps, { fetchEvents, createEvent, fetchGroup })(Events);
