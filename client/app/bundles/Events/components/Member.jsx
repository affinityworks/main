import React from 'react';
import { Link } from 'react-router-dom';

const Member = (props) => {
  if(!props.member) { return null }

  const emailAddressLink = () => {
    const email = props.member['primary-email-address']
    if (email)
      return <a href={`mailto:'${email}'`} className='fa fa-envelope-o'/>
  }

  const localityAndRegion = () => {
    const address = props.member['primary-personal-address']
    if (address) {
      if (address['locality'] && address['region']) {
        return <span>{address['locality']}, {address['region']}</span>
      }
      else if (address['locality']) {
        return <span>{address['locality']}</span>
      }
      else if (address['region']){
        return <span>{address['region']}</span>
      }
      else if (address['postal_code']){
        return <span>{address['region']}</span>
      }
    }
    return <span></span>
    //const region = props.member['primary-personal-address']['region']
    //if (locality && region)
    //  return {locality}
  }

  return(
    <tr>
      <td>
        <Link to={`/members/${props.id}`}>
          {props.member['given-name']} {props.member['family-name']}
        </Link>
      </td>
      <td>{props.member['primary-phone-number']}</td>
      <td>{ localityAndRegion() }</td>
      <td>{props.member['attended-events-count']}</td>
      <td>{ emailAddressLink() }</td>
    </tr>
  )
}

export default Member;
