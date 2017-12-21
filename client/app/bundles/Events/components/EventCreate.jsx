import React, { Component } from 'react';
import { connect } from 'react-redux';
import FormGroup from '../components/FormGroup';
import { Field, reduxForm } from 'redux-form';
import moment from 'moment';

class EventCreate extends Component {
  state = {
    showCreateEvent: false
  }

  componentWillReceiveProps(nextProps) {
    const { location, history } = this.props
    const eventId = nextProps.event.id;

    if (eventId)
      history.push(`${location.pathname}/${eventId}`);
  }

  renderButtons () {
    return (
      <div className='col-md-12'>
        <button type='button' className='btn btn-danger mr-2' onClick={this.props.handleCancel}>Cancel</button>
        <button type='submit' className='btn btn-success'>
          Create
        </button>
      </div>
    )
  }

  handleSubmit (values) {
    const { title, startDate, locationName, adress, postal, city, region, startTime, description } = values;
    const { createEvent } = this.props;
    const dateTime = `${startDate} ${startTime}`;

    const attributes = {
      title: title,
      start_date: moment(dateTime).format(),
      description: description,
      origin_system: 'Affinity',
      location_attributes: {
        address_lines: [adress],
        locality: city,
        venue: locationName,
        postal_code: postal,
        region: region
      }
    }

    createEvent(attributes);
  }
  
  render() {
    const {
      fields: {
        title,
        startDate,
        startTime,
        locationName,
        adress,
        city,
        postal,
        region,
        description
      },
      handleSubmit
    } = this.props

    return (
      <div className='card mb-5'>
        <div className='card-block'>
          <div className='col-md-9'>
            <h3>Add Event</h3>
            <form
              autoComplete='off'
              onSubmit={handleSubmit(this.handleSubmit.bind(this))}
            >
              <div className="row">
                <div className='form-group col-md-12'>
                  <label>Title</label>
                  <Field
                    className='form-control'
                    name='title'
                    component='input'
                    type='text'
                    required
                    {...title}
                  />
                </div>
                <div className='form-group col-md-5'>
                  <label>Start date</label>
                  <Field
                    className='form-control'
                    name='startDate'
                    component='input'
                    type='date'
                    required
                    {...startDate}
                  />
                </div>
                <div className='form-group col-md-7'>
                  <label>Start time</label>
                  <Field
                    className='form-control'
                    name='startTime'
                    component='input'
                    type='time'
                    required
                    {...startTime}
                  />
                </div>
                <div className='form-group col-md-7'>
                  <label>Location Name</label>
                  <Field
                    className='form-control'
                    name='locationName'
                    component='input'
                    type='text'
                    {...locationName}
                  />
                </div>
                <div className='form-group col-md-5'>
                  <label>Adress</label>
                  <Field
                    className='form-control'
                    name='adress'
                    component='input'
                    type='text'
                    {...adress}
                  />
                </div>
                <div className='form-group col-md-4'>
                  <label>City</label>
                  <Field
                    className='form-control'
                    name='city'
                    component='input'
                    type='text'
                    {...city}
                  />
                </div>
                <div className='form-group col-md-4'>
                  <label>State</label>
                  <Field
                    className='form-control'
                    name='region'
                    component='input'
                    type='text'
                    {...region}
                  />
                </div>
                <div className='form-group col-md-4'>
                  <label>Zip/Postal Code</label>
                  <Field
                    className='form-control'
                    name='postal'
                    component='input'
                    type='number'
                    {...postal}
                  />
                </div>
                <div className='form-group col-md-12'>
                  <label>Description</label>
                  <Field
                    className='form-control'
                    name='description'
                    component='input'
                    type='text'
                    {...description}
                  />
                </div>
                {this.renderButtons()}
              </div>
            </form>
          </div>
        </div>
      </div>
    );
  }
}

const mapStateToProps = ({ event }) => {
  return { event }
};

EventCreate = connect(mapStateToProps)(EventCreate)

export default reduxForm({
  form: 'eventCreate',
  fields: [
    'title',
    'startDate',
    'startTime',
    'locationName',
    'adress',
    'city',
    'postal',
    'region',
    'description']
})(EventCreate)