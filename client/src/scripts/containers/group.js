import React from 'react';
import UpdateList from '../components/updates/update-list';
import EventList from '../components/events/event-list';

import style from './group.scss';

export default function Group(props) {
  const {
      name,
      url,
      updates,
      // city,
      // region,
      contact_name: contactName,
      contact_email: contactEmail,
      contact_phone: contactPhone,
      facebook_page_url: facebookPageUrl,
      // stats,
      // leaders,
      // members,
      events,
      // tags,
      nearby_groups: nearby,
      // loading,
  } = props.group;

  const signUpFrom = (
    <div className="well">
      <h4>Join Our Group</h4>
      <input
        type="email"
        className="form-control"
        name="group_signup_form-email"
        placeholder="Email"
      />
      <input
        type="text"
        className="form-control"
        name="group_signup_form-name"
        placeholder="First Name"
      />
      <input
        type="text"
        className="form-control"
        name="group_signup_form-name"
        placeholder="Last Name"
      />
      <input
        type="phone"
        className="form-control"
        name="group_signup_form-phone"
        placeholder="Phone"
      />
      <input
        type="checkbox"
        name="volunteer"
      />
      <label htmlFor="volunteer">
        I want to volunteer to help organize events
      </label>
      <textarea
        className="form-control"
        placeholder="I can help by..."
      />
      <button className="btn">Join Group</button>
    </div>
  );

  const facebookGroup = (
    <div className="well">
      <h4>{name} on Facebook</h4>
      <a
        className="facebook-like"
        href={facebookPageUrl}
      >
        Like
      </a>
    </div>
  );

  const contactWell = (
    <div className="well">
      <h4>Contact Info</h4>
      <dl>
        <dt>Group Contact:</dt>
        <dd>{contactName}</dd>
        <dd>{contactPhone}</dd>
        <dd>
          <a href={`mailto:${contactEmail}`}>
            Send us an email
          </a>
        </dd>
      </dl>
    </div>
  );

  const nearbyWell = (
    <div className="well">
      <h4>Nearby Groups</h4>
      {nearby.map((item, i) => (
        <div key={i}>
          <a href={item.url}>{item.name}</a>
          <span>{item.distance} miles</span>
        </div>
      ))}
    </div>
  );

  return (
    <div className="group" style={style}>
      <div className="group-main">
        <a href={url} className="group-title">{name}</a>
        <UpdateList updates={updates.sticky} />
        <EventList events={events} />
      </div>
      <div className="group-related">
        {signUpFrom}
        {facebookGroup}
        {contactWell}
        {nearbyWell}
      </div>
    </div>
  );
}

Group.propTypes = {
  group: React.PropTypes.object,
  name: React.PropTypes.string,
  updates: React.PropTypes.object,
};
