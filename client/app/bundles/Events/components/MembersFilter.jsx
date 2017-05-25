import React, { Component } from 'react';

class MembersFilter extends Component {
  constructor(props, _railsContext) {
    super(props);

    this.state =  { searchTerm: '' };
  }

  onInputSubmit(searchTerm) {
    this.setState({ searchTerm });
    this.props.onSearchSubmit(searchTerm);
  }

  render() {
    return (
      <div className='input-group'>
        <input
          ref="searchInput"
          type='text'
          className='form-control'
          defaultValue={this.props.filter}
          placeholder='Search for your people' />
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

export default MembersFilter;
