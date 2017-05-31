import React, { Component } from 'react';

class EventsFilter extends Component {
  constructor(props, _railsContext) {
    super(props);

    this.state =  { eventUrl: '' };
    this.onInputSubmit = this.onInputSubmit.bind(this);
  }

  onInputSubmit(eventUrl) {
    this.setState({ eventUrl });
    this.props.onSearchSubmit(eventUrl);
  }

  render() {
    return (
      <div className='input-group col-6'>
        <input
          ref="eventInput"
          type='text'
          className='form-control'
          defaultValue=''
          placeholder='Facebook event url' />
         <span className='input-group-btn'>
          <button className='btn btn-primary'
            onClick={ev => this.onInputSubmit(this.refs.eventInput.value) }>
            Import
          </button>
         </span>
      </div>
    );
  }
}

export default EventsFilter;
