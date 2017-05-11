import React from 'react';


const Member = (props) => {
  if(!props.member) { return null }

  const emailAddressLink = () => {
    const email = props.member['primary-email-address']
    if (email)
      return <a href={`mailto:'${email}'`} className='fa fa-envelope-o'/>
  }

  return(
    <tr>
      <td>{props.member['given-name']} {props.member['family-name']}</td>
      <td>{props.member['primary-phone-number']}</td>
      <td>{props.member['primary-email-address']}</td>
      <td>{props.member['attended-events-count']}</td>
      <td>{ emailAddressLink() }</td>
    </tr>
  )
}

export default Member;
