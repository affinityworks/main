import _ from 'lodash';

import {
  LOOK_UP_MEMBER, LOOK_UP_MEMBER_START, SET_ATTENDANCE_ATTRIBUTE,
  ATTENDANCE_CREATE_FAIL, ATTENDANCE_CREATE_SUCCESS,
  RESET_ATTENDANCE_FORM
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
  'errorAlert': '',
  'loading': false
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
  case LOOK_UP_MEMBER_START:
    return { ...state, loading: true }
  case LOOK_UP_MEMBER:
    const members = action.payload.data.members.data;

    if (members.length) {
      const { attributes } = members[0];
      const address = attributes['primary-personal-address'];

      return {
        ...state, ..._.omit(attributes, 'primary-personal-address'),
        ...address, disabled: true, loading: false
      }
    } else if (state.disabled) {
      return {
        ...INITIAL_STATE,
        ['primary-email-address']:  state['primary-email-address']
      }
    }

    return state;
  case RESET_ATTENDANCE_FORM:
    return INITIAL_STATE;
  default:
    return state;
  }
};
