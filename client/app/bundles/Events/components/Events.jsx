import axios from 'axios';
import React, { PropTypes, Component } from 'react';
import queryString from 'query-string';
import { connect } from 'react-redux';

import Event from './Event';
import EventsFilter from './EventsFilter';
import Pagination from './Pagination';

import { fetchEvents } from '../actions';

class Events extends Component {
  constructor(props, _railsContext) {
    super(props);

    this.filterEvents = this.filterEvents.bind(this);
    this.renderEvents = this.renderEvents.bind(this);
    this.groupColumn = this.groupColumn.bind(this);
    this.printColumn = this.printColumn.bind(this);
  }

  componentWillMount() {
    this.props.fetchEvents(this.props.location.search);
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.location.search !== nextProps.location.search)
      this.props.fetchEvents(nextProps.location.search);
  }

  filterEvents(filter) {
    this.props.history.push(`?${queryString.stringify({ filter })}`);
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

  linkWithFacebook() {
    const {current_user} = this.props
    //this should be fixed as it doesnt' work, curent_user is always nil
    if (current_user && current_user.admin) {
      return (
        <a href='/admin/auth/facebook' className='btn btn-facebook'>
          Import Event From Facebook
        </a>
      )
    }
  }

  groupColumn() {
    if (this.props.showGroupName)
      return <th>Group Name</th>
  }

  printColumn() {
    if (this.props.showPrintIcon)
      return <th></th>
  }

  renderEvents() {
    return this.props.events.map(event => (<Event
      key={event.id} event={event}
      showGroupName={this.props.showGroupName}
      showPrintIcon={this.props.showPrintIcon}
    />))
  }

  render() {
    const { search } = this.props.location;
    const { filter, direction } = queryString.parse(search);

    return (
      <div>
        <div className='row'>

          <div className='col-5'>
            <EventsFilter onSearchSubmit={this.filterEvents} filter={filter} />
          </div>
          <div className='col-3 offset-4 text-right'>
            { this.linkWithFacebook() }
          </div>
        </div>

        <br />
        <table className='table table--fixed'>
          <thead>
            <tr>
              <th>Event Name</th>
              <th>Date</th>
              <th>Location</th>
              { this.groupColumn() }
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
    );
  }
}

const mapStateToProps = (state) => {
  const { events, total_pages, page } = state.events;

  return { events, total_pages, page };
}

export default connect(mapStateToProps, { fetchEvents })(Events);
