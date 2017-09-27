import React, { Component } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';

class Header extends Component {
  currentGroupName() {
    if (this.props.currentGroup)
      return this.props.currentGroup.name
    else
      return ''
    end
  }

  render() {
    const { currentUser, currentGroup } = this.props;

    return(
      <div className='page-header'>
        <div className="row container">
          <div className="col-10">
            <h2>
              <a href="/" className="affinity-logo"><img src="/images/affinity-logo.svg" width="230" /></a>
              <small style={{ position: 'relative', bottom: '-5px', marginLeft: '5px' }}>
                {this.currentGroupName()}
              </small>
            </h2>
          </div>

          <div className="col-2 text-right">
            <div className="dropdown">
              <button className="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <span> {`${currentUser.given_name} ${currentUser.family_name}`} </span>
              </button>
              <div className="dropdown-menu" aria-labelledby="dropdownMenuLink">
                <Link className="dropdown-item" to={`/profile/`}>Account</Link>
                <a className="dropdown-item" href="/admin/logout">Logout</a>
              </div>
            </div>
          </div>
        </div>
        <br />
      </div>
    );
  }
}

const mapStateToProps = ({ currentGroup, currentUser }) => {
  return { currentGroup, currentUser };
};

export default connect(mapStateToProps)(Header);
