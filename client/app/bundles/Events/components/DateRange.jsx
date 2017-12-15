import React, { Component } from 'react';
import FormGroup from '../components/FormGroup';
import { Field, reduxForm, SubmissionError } from 'redux-form';
import queryString from 'query-string';
import moment from 'moment';


import { map, isEmpty } from 'lodash';

class DateRange extends Component {
  state = {
    dateValue: {}
  }

  filterEventDate (start, end) {
    this.props.history.push(`?filter[start_date]=${start}&filter[end_date]=${end}`);
  }

  handleSubmit (values) {
    const { startDate, endDate } = values

    this.setState({ dateValue: values });
    this.filterEventDate(startDate, endDate);
  }

  onChangeForm (e) {
		this.setState({ [e.target.name]: e.target.value });
	}

  render() {
    const {
      state: { dateValue },
      props: {
        fields: {
          startDate,
          endDate
        },
        handleSubmit
      }
    } = this;
    const validate = this.state.startDate > this.state.endDate;

    return (
      <div className='date-range'>
        <div className='btn-group'>
          <button className='btn btn-secondary'>
            { isEmpty(dateValue)
              ? '--- Filter by Date ---'
              : `${moment(this.state.startDate).format('YYYY-DD-MM')} / ${moment(this.state.endDate).format('YYYY-DD-MM')}`}
          </button>
          <button
            className='btn btn-primary dropdown-toggle dropdown-toggle-split'
            type='button'
            data-toggle='dropdown'
            aria-haspopup='true'
            aria-expanded='false'
          >
            <span className='sr-only'>Toggle Dropdown</span>
          </button>
          <div className='dropdown-menu'>
              <div className='col-md-12'>
                <form
                  className='form-group'
                  onSubmit={handleSubmit(this.handleSubmit.bind(this))}
                  onChange={this.onChangeForm.bind(this)}
                >

                  <div className={validate ? 'form-group has-danger' : 'form-group'}>
                    <label>Start Date</label>
                    <Field
                      className='form-control'
                      type='date'
                      name='startDate'
                      component='input'
                      required
                      {...startDate}
                    />
                  </div>
                  <div className={validate ? 'form-group has-danger' : 'form-group'}>
                    <label>End Date</label>
                    <Field
                      className='form-control'
                      name='endDate'
                      component='input'
                      type="date"
                      {...endDate}
                    />
                    <div className={`form-control-feedback ${validate ? 'd-block' : 'd-none' }`}>Invalid date range selection</div>
                  </div>

                  <button type='button' className='btn btn-secondary btn-sm mr-2'>Cancel</button>
                  <button type='submit' className='btn btn-primary btn-sm'>Filter</button>
                </form>
              </div>
          </div>
        </div>
      </div>
    );
  }
}

function validate(values) {
  const errors = {};

  if (values.startDate > values.endDate) {
    errors.endDate = 'Set the date';
  }

  return errors;
}

export default reduxForm({
  form: 'dateRangeForm',
  fields: [ 'startDate', 'endDate'],
  initialValues: {
    endDate: moment().format('YYYY-MM-DD'),
    startDate: moment().format('YYYY-MM-DD')
  },
  validate
 })(DateRange);
