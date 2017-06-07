import React, { Component } from 'react';
import Breadcrumbs from '../components/Breadcrumbs';
import { connect } from 'react-redux';
import { fetchGroup } from '../actions';

import Nav from '../components/Nav';

class Dashboard extends Component {
  componentWillMount() {
    const { groupId } = this.props.match.params;

    this.props.fetchGroup(groupId);
  }

  render() {
    const { attributes } = this.props.group;

    if(!attributes) { return null }

    return (
      <div>
        <Breadcrumbs active='Dashboard' />

        <br />

        <Nav activeTab='dashboard' />
        <br />
        <div dangerouslySetInnerHTML={{ __html: attributes.description }} />
      </div>
    );
  }
}

const mapStateToProps = ({ group }) => {
  return { group }
};

export default connect(mapStateToProps, { fetchGroup })(Dashboard);
