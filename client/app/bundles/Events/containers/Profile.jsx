import React, { Component } from 'react';
import { connect } from 'react-redux';
import Groups from '../components/Groups';

class Profile extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    const { currentUser, currentGroup } = this.props;
    return (
      <div>
        <div className='row'>
          <div className='col-md-6'>
            <h1>Welcome {currentUser.given_name} {currentUser.family_name}</h1>
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
