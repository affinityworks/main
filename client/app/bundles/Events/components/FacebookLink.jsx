import React from 'react';

const FacebookLink = ({id}) => (
  <a href={`https://facebook.com/${id}`} target='_blank'>
    <i className='fa fa-facebook-official fa-2x' style={{ color: '#3b5998' }} />
  </a>
);

export default FacebookLink;
