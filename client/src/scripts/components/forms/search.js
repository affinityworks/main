import React, { Component } from 'react';
import classnames from 'classnames';

import style from './search.scss';

class Search extends Component {
  constructor() {
    super();

    this.state = {
      query: '',
    };

    this.handleEntryChange = this.handleEntryChange.bind(this);
  }

  handleEntryChange(event) {
    this.setState({
      query: event.target.value,
    });
  }

  handleSubmit() {
    console.log(this.state);
  }

  render() {
    const formClasses = classnames({
      search: true,
    });

    const suggestion = (!this.props.suggestion) ? 'Search' : this.props.suggestion;

    return (
      <form
        style={style}
        className={formClasses}
        onChange={this.handleEntryChange}
        onSubmit={this.handleSubmit}
      >
        <div className="field">
          <label htmlFor="search">
            Find a local group:
          </label>
          <input
            type="search"
            className="form-control"
            name="search"
            placeholder={suggestion}
            value={this.state.email}
          />
        </div>
        <button className="button">Search</button>
      </form>
    );
  }
}

export default Search;

Search.propTypes = {
  suggestion: React.PropTypes.string,
};
