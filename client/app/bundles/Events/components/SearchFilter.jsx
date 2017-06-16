import React, { Component } from 'react';

class SearchFilter extends Component {
  constructor(props, _railsContext) {
    super(props);

    this.state = { searchTerm: props.filter || '' };
  }

  componentWillReceiveProps(nextProps) {
    if (this.props.filter !== nextProps.filter)
      this.setState({ searchTerm: nextProps.filter || '' });
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
            value={this.state.searchTerm}
            placeholder={this.props.placeholder}
            onChange={e => this.setState({ searchTerm: e.target.value })}/>
            <span className='input-group-btn' type='submit'>
              <button className='btn btn-secondary'> Search </button>
            </span>
        </div>
      </form>
    );
  }
}

export default SearchFilter;
