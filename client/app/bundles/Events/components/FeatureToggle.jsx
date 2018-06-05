import React, { PropTypes, Component } from 'react';
import { connect } from 'react-redux';

const FeatureToggle = ({on, children}) => on ? children : null

export default FeatureToggle;