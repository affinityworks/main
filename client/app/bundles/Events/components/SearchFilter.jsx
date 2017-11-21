import React, { Component } from 'react';

class SearchFilter extends Component {
  constructor(props, _railsContext) {
    super(props);

    this.state = { searchTerm: props.filter || '' };

    this.onClearSearch = this.onClearSearch.bind(this)
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

  onClearSearch(e) {
    this.onInputSubmit(e, '')
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
            {this.state.searchTerm && (
              <span
                className="fa fa-times-circle search__clear-button"
                onClick={this.onClearSearch}
              />
            )}
            <span className='input-group-btn' type='submit'>
              <button className='btn btn-secondary'> Search </button>
            </span>
        </div>
      </form>
    );
  }
}

export default SearchFilter;
