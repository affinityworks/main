import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';

import { dashboardPath, groupId } from '../utils/Pathnames';

class Breadcrumbs extends Component {
  render() {
    const { currentRole, currentGroup, active } = this.props;

    if (currentRole != 'national_organizer' || currentGroup.id != groupId())
      return false;

    return (
      <ol className='breadcrumb'>
        <li className='breadcrumb-item'>
          <Link to={dashboardPath()}>{currentGroup.name}</Link>
        </li>

        <li className='breadcrumb-item active'>{active}</li>
      </ol>
    );
  }
}

const mapStateToProps = ({ currentGroup, currentRole }) => {
  return { currentGroup, currentRole };
};

export default connect(mapStateToProps)(Breadcrumbs);
