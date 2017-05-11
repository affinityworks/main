import React from 'react';
import { Link } from 'react-router-dom';

const NavItem = ({ title, path, active }) => (
  <li className="nav-item">
    <Link to={path} className={`nav-link ${active ? 'active' : ''}`}> {title} </Link>
  </li>
);

export default NavItem;
