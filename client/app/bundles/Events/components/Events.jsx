import axios from 'axios';
import React, { PropTypes, Component } from 'react';
import queryString from 'query-string';
import { connect } from 'react-redux';

import Event from './Event';
import EventsFilter from './EventsFilter';
import SortToggle from './SortToggle';
import Pagination from './Pagination';
import Nav from './Nav';
import history from '../history';
import { addParamToQuery, removeParamFromQuery } from '../utils';
import { fetchEvents } from '../actions';

class Events extends Component {
  constructor(props, _railsContext) {
    super(props);

    this.filterEvents = this.filterEvents.bind(this);
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
    return (
      <a href='/admin/auth/facebook' className='btn btn-facebook'>
        Import Event From Facebook
      </a>
    )
  }

  render() {
    const { search } = this.props.location;
    const { filter, direction } = queryString.parse(search);

    return (
      <div>
        <Nav activeTab='events'/>
        <div className='row'>

          <div className='col-1'>
            <SortToggle search={search} title='Date' currentDirection={direction} />
          </div>

          <div className='col-5'>
            <EventsFilter onSearchSubmit={this.filterEvents} filter={filter} />
          </div>
          <div className='col-3 offset-3 text-right'>
            { //this.linkWithFacebook()
             }
          </div>
        </div>
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
