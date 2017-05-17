import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';
import Groups from './Groups';

class Profile extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    //const { currentUser, currentGroup } = this.state;
    return (
      <div className='list-group-item'>
        <h1>
          Welcome {this.props.currentUser.given_name} {this.props.currentUser.family_name}
        </h1>
        <h3>Your Groups</h3>
        <Groups location={this.props.location} />
      </div>
    )
  }
}

const mapStateToProps = ({ currentUser }) => {
  return { currentUser }
};

export default connect(mapStateToProps)(Profile);
