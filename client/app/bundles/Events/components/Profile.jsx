import React, { Component } from 'react';
import { connect } from 'react-redux';
import Groups from './Groups';

class Profile extends Component {
  constructor(props) {
    super(props);
  }

  linkWithFacebook() {
    if (!this.props.currentUser.linked_with_facebook)
      return (
        <a href='/admin/auth/facebook' className='btn btn-primary'>
          Connect with Facebook
        </a>
      )
    else
      return (
        <a href='#' className='btn btn-danger'>
          Disconnect from Facebook
        </a>
      )
  }

  render() {
    const { currentUser, currentGroup } = this.props;
    return (
      <div>
        <div className='row'>
          <div className='col-md-6'>
            <h1>Welcome {currentUser.given_name} {currentUser.family_name}</h1>
          </div>
          <div className='col-md-3 offset-md-3 text-right'>
            { this.linkWithFacebook(currentUser) }
          </div>
        </div>
        <br/>
        <div className='list-group-item'>
          <h3>Your Groups</h3>
          <Groups location={this.props.location} />
        </div>
      </div>
    )
  }
}

const mapStateToProps = ({ currentUser }) => {
  return { currentUser }
};

export default connect(mapStateToProps)(Profile);
