import axios from 'axios';
import React from 'react';

const Header = (props) => {
  return (
    <div className='page-header'>
      <div className="row">
        <div className="col-10">
          <h2>
            <img src="/mocks/img/logo.png" height="50" />
            <a href="/">Affinity</a>
            <small> {` Group Name`} </small>
          </h2>
        </div>

        <div className="col-2 text-right">
          <div className="dropdown">
            <a className="btn btn-secondary dropdown-toggle" href="https://example.com" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              <img src='/mocks/img/jane_doe.jpg' />
              <span> Jane Doe </span>
            </a>
          </div>

          <div className="dropdown-menu" aria-labelledby="dropdownMenuLink">
            <a className="dropdown-item" href="#">Account</a>
            <a className="dropdown-item" href="/admin/logout">Logout</a>
          </div>
        </div>
      </div>
      <br />
    </div>
  );
}

export default Header;
