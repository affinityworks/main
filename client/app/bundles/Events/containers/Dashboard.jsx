import React, { Component } from 'react';
import { connect } from 'react-redux';
import Nav from '../components/Nav';

class Dashboard extends Component {
  render() {
    const { currentGroup } = this.props;

    return (
      <div>
        <Nav activeTab='dashboard' />
        <br />
        <div dangerouslySetInnerHTML={{ __html: currentGroup.description }} />
      </div>
    );
  }
}

const mapStateToProps = ({ currentGroup }) => {
  return { currentGroup }
};

export default connect(mapStateToProps)(Dashboard);
