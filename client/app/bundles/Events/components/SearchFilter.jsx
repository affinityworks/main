import React, { Component } from 'react';

class SearchFilter extends Component {
  constructor(props, _railsContext) {
    super(props);

    this.state = { searchTerm: '' };
  }

  onInputSubmit(e, searchTerm) {
    e.preventDefault();
    this.setState({ searchTerm });
    this.props.onSearchSubmit(searchTerm);
  }

  render() {
    return (
      <form onSubmit={ev => this.onInputSubmit(ev, this.refs.searchInput.value)}>
        <div className='input-group'>
          <input
            ref="searchInput"
            type='text'
            className='form-control'
            defaultValue={this.props.filter}
            placeholder={this.props.placeholder} />
            <span className='input-group-btn' type='submit'>
              <button className='btn btn-secondary'> Search </button>
            </span>
        </div>
      </form>
    );
  }
}

export default SearchFilter;
