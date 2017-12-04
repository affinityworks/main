import React, { Component } from 'react';
import FormGroup from '../components/FormGroup';
import Input from '../components/Input';
import RichTextEditor from 'react-rte';
import { Field, reduxForm } from 'redux-form';

class EventCreate extends Component {
  state = {
    showCreateEvent: false,
    value: RichTextEditor.createEmptyValue()
  }

  renderButtons () {
    return (
      <div className='col-md-12'>
        <button type='submit' className='btn btn-success mr-2'>Save</button>
        <button type='button' className='btn btn-danger' onClick={this.props.handleCancel}>Cancel</button>
      </div>
    )
  }

  handleSubmit (values) {
    const { title, startDate, locationName, adress, postal, city, region } = values
    const { handleCancel, location, createEvent} = this.props

    const attributes = {
      title: title,
      start_date: startDate,
      location: {
        address_lines: [adress],
        locality: city,
        venue: locationName,
        postal_code: postal,
        region: region
      }
    }
  
    createEvent(attributes, location.search)
    handleCancel()
  }

  onChange = (value) => {
    this.setState({value});
  
    if (this.props.onChange) {
      this.props.onChange(
        value.toString('html')
      );
    }
  };

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
