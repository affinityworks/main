import axios from 'axios';
import React, { PropTypes, Component } from 'react';
import queryString from 'query-string';
import { connect } from 'react-redux';

import Event from './Event';
import EventsFilter from './EventsFilter';
import Pagination from './Pagination';
import Nav from './Nav';
import { fetchEvents } from '../actions';
import history from '../history';

class Events extends Component {
  constructor(props, _railsContext) {
    super(props);

    this.filterEvents = this.filterEvents.bind(this);
  }

  componentWillMount() {
    this.props.fetchEvents(this.buildQuery(this.props));
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.location.search !== nextProps.location.search)
      this.props.fetchEvents(this.buildQuery(nextProps));
  }

  buildQuery(props) {
    const { filter, page } = queryString.parse(props.location.search);
    const query = { filter, page };

    return `?${queryString.stringify(query)}`;
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

  render() {
    const { filter } = queryString.parse(this.props.location.search);

    return (
      <div>
        <Nav activeTab='events'/>
        <EventsFilter onSearchSubmit={this.filterEvents} filter={filter} />
        <br />
        <div className='list-group'>
          {this.props.events.map(event => <Event key={event.id} event={event} />)}
        </div>
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
