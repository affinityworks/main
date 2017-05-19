import React from 'react';

const Input = ({ label, classes, onBlur, value, onChange, disabled }) => {
  return(
    <div className={classes}>
      <label> {label} </label>
      <input
        type='text'
        className='form-control'
        onBlur={onBlur}
        value={value}
        onChange={onChange}
        disabled={disabled} />
      </div>
  );
}

export default Input;
