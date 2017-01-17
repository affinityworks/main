import React, { Component } from 'react';
import classnames from 'classnames';

import slugify from '../../util/slugify';

import style from './signup.scss';

class SignUp extends Component {
  constructor() {
    super();

    this.state = {
      email: '',
      firstName: '',
      lastName: '',
      phone: '',
      volunteer: false,
      volunteerDetail: '',
      initalEntry: true,
    };

    this.handleEntryChange = this.handleEntryChange.bind(this);
  }

  handleEntryChange(event) {
    this.setState({
      [event.target.name]: event.target.value,
      initalEntry: false,
    });
  }

  handleSubmit() {
    console.log(this.state);
  }

  render() {
    const formClasses = classnames({
      signup: true,
      'signup-initial': (this.state.initalEntry === true),
    });

    return (
      <form
        style={style}
        className={formClasses}
        onChange={this.handleEntryChange}
        onSubmit={this.handleSubmit}
      >
        <input
          type="hidden"
          name="group-signup-id"
          value={slugify(this.props.to)}
          readOnly
        />
        <div className="field field-initial">
          <input
            type="email"
            className="form-control"
            name="email"
            placeholder="Email"
            value={this.state.email}
          />
        </div>
        <div className="field">
          <input
            type="text"
            className="form-control"
            name="firstName"
            placeholder="First Name"
            value={this.state.firstName}
          />
        </div>
        <div className="field">
          <input
            type="text"
            className="form-control"
            name="lastName"
            placeholder="Last Name"
            value={this.state.lastName}
          />
        </div>
        <div className="field">
          <input
            type="phone"
            className="form-control"
            name="phone"
            placeholder="Phone"
            value={this.state.phone}
          />
        </div>
        <div className="field">
          <input
            type="checkbox"
            name="volunteer"
            checked={this.state.volunteer}
          />
          <label htmlFor="volunteer">
            I want to volunteer to help organize events
          </label>
        </div>
        <div className="field">
          <textarea
            className="form-control"
            name="volunteerDetail"
            placeholder="I can help by..."
            value={this.state.volunteerDetail}
          />
        </div>
        <button className="button">Join Group</button>
      </form>
    );
  }
}

export default SignUp;

SignUp.propTypes = {
  title: React.PropTypes.string,
  to: React.PropTypes.string,
};
