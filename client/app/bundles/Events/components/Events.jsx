import axios from 'axios';
import React, { PropTypes, Component } from 'react';
import queryString from 'query-string';

import Event from './Event';
import EventsFilter from './EventsFilter';
import Pagination from './Pagination';
import history from '../history';

export default class Events extends Component {
  constructor(props, _railsContext) {
    super(props);

    const { filter, page } = queryString.parse(props.location.search);

    this.state = { events: [], page: page, filter: filter, total_pages: null };
    this.filterEvents = this.filterEvents.bind(this);
  }

  componentDidMount() {
    const { filter, page } = this.state;
    this.getEvents(filter, page);
  }

  componentWillReceiveProps(nextProps) {
    const { filter, page } = queryString.parse(nextProps.location.search);
    this.getEvents(filter, page);
  }

  filterEvents(filter) {
    this.props.history.push(`?${queryString.stringify({ filter })}`);
  }

  getEvents(filter, page) {
    const query = { filter, page };
    const uri = `/events.json?${queryString.stringify(query)}`;

    axios.get(uri)
      .then(res => {
        const events = res.data.events.data;
        const { total_pages, page } = res.data;

        this.setState({ events, total_pages, page });
      });
  }

  renderPagination() {
    if (this.state.total_pages) {
      return <Pagination
        page={this.state.page}
        totalPages={this.state.total_pages}
        currentSearch={this.props.location.search} />
    }
  }

  render() {
    return (
      <div>
        <EventsFilter onSearchSubmit={this.filterEvents} filter={this.state.filter} />
        <br />
        <div className='list-group'>
          {this.state.events.map(event => <Event key={event.id} event={event} />)}
        </div>
        <br />
        {this.renderPagination()}
      </div>
    );
  }
}
