import React from 'react';
import NavItem from './NavItem';

const Nav = ({ activeTab }) => {
  return (
    <div>
      <ul className="nav nav-tabs">
        <NavItem title='Members' path='/members' active={activeTab === 'members'} />
        <NavItem title='Events' path='/events' active={activeTab === 'events'} />
      </ul>
      <br />
    </div>
  );
};

export default Nav;
