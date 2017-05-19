import React from 'react';

const Input = ({ label, classes }) => (
  <div className={classes}>
    <label> {label} </label>
    <input type='text' className='form-control' />
  </div>
);

export default Input;
