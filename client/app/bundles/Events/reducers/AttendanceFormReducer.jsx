import _ from 'lodash';

import {
  LOOK_UP_MEMBER, SET_ATTENDANCE_ATTRIBUTE,
  ATTENDANCE_CREATE_FAIL, ATTENDANCE_CREATE_SUCCESS,
  CLEAN_ATTENDANCE_ALERTS
} from '../actions/types';

const INITIAL_STATE = {
  'primary-email-address': '',
  'primary-phone-number': '',
  'family-name': '',
  'given-name': '',
  'disabled': '',
  'postal_code': '',
  'locality': '',
  'address_lines': [],
  'successAlert': '',
  'errorAlert': ''
};

export default (state = INITIAL_STATE, action) => {
  switch (action.type) {
  case SET_ATTENDANCE_ATTRIBUTE:
    const { prop, value } = action.payload;
    return { ...state, [prop]: value };
  case ATTENDANCE_CREATE_SUCCESS:
    return { ...INITIAL_STATE, successAlert: 'Attendee Successfully Created',  errorAlert: '' }
  case ATTENDANCE_CREATE_FAIL:
    const { response } = action.payload;

    if (response) {
      return { ...state, errorAlert: response.data.join(', '), successAlert: '' };
    }

    return state
  case LOOK_UP_MEMBER:
    const members = action.payload.data.members.data;

    if (members.length) {
      const { attributes } = members[0];
      const address = attributes['primary-personal-address'];

      return {
        ...state, ..._.omit(attributes, 'primary-personal-address'),
        ...address, disabled: true
      }
    } else if (state.disabled) {
      return {
        ...INITIAL_STATE,
        ['primary-email-address']:  state['primary-email-address']
      }
    }

    return state;
  case CLEAN_ATTENDANCE_ALERTS:
    return { ...state, errorAlert: '', successAlert: '' }
  default:
    return state;
  }
};
