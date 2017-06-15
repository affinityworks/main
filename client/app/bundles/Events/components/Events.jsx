import axios from 'axios';
import React, { PropTypes, Component } from 'react';
import queryString from 'query-string';
import { connect } from 'react-redux';

import Event from './Event';
import EventsFilter from './EventsFilter';
import Pagination from './Pagination';
import SortableHeader from './SortableHeader';

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

  groupColumn() {
    if (this.props.showGroupName)
      return <SortableHeader title='Group Name' sortBy='group_name' />
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

          <div className='col-6'>
            <EventsFilter onSearchSubmit={this.filterEvents} filter={filter} />
          </div>
          <div className='col-3 offset-3 text-right'>
            <a href='/admin/auth/facebook' className='btn btn-facebook'>
              Import Event From Facebook
            </a>
          </div>
        </div>

        <br />
        <table className={`table ${this.props.showPrintIcon ? '' : 'table--fixed'}`}>
          <thead>
            <tr>
              <SortableHeader title='Event Name' sortBy='title' />
              <SortableHeader title='Date' sortBy='start_date' />
              <th>Location</th>
              { this.groupColumn() }
              <th>Tags</th>
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
