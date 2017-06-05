import React from 'react';
import { Link } from 'react-router-dom';

import { membersPath } from '../utils/Pathnames';

const Member = (props) => {
  const { member } = props;
  if(!member) { return null }

  const emailAddressLink = () => {
    const email = member['primary-email-address']
    if (email)
      return <a href={`mailto:'${email}'`} className='fa fa-envelope-o'/>
  }

  const localityAndRegion = () => {
    const address = member['primary-personal-address']
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
  }

  return(
    <tr>
      <td>
        <Link to={`${membersPath()}/${props.id}`}>
          {member['given-name']} {member['family-name']}
        </Link>
      </td>
      <td>{member['primary-phone-number']}</td>
      <td>{ localityAndRegion() }</td>
      <td>{props.role}</td>
      <td>{ emailAddressLink() }</td>
    </tr>
  )
}

export default Member;
