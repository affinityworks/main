import React, { Component } from 'react';

class EventsFilter extends Component {
  constructor(props, _railsContext) {
    super(props);

    this.state =  { searchTerm: '' };
  }

  onInputSubmit(searchTerm) {
    console.log('WTF', searchTerm)
    this.setState({searchTerm});
    this.props.onSearchSubmit(searchTerm);
  }

  render() {
    return (
      <div className='input-group'>
        <input ref="searchInput" type='text' className='form-control' placeholder='Search by event title' />
         <span className='input-group-btn'>
          <button className='btn btn-secondary'
            onClick={ev => this.onInputSubmit(this.refs.searchInput.value) }>
            Search
          </button>
         </span>
      </div>
    );
  }
}

export default EventsFilter;
