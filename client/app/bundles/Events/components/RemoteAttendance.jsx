import React, { Component } from 'react';

class RemoteAttendance extends Component {
  constructor(props) {
    super(props);
    const { email } = props.attendance;

    this.state = { email: email || '', isEditing: !props.hasEmail }
  }

  componentWillReceiveProps(nextProps) {
    const { email } = nextProps.attendance;

    this.state = { email: email || '', isEditing: !nextProps.hasEmail }
  }

  handleChange(ev) {
    const { attendance, onCheckboxChecked, onCheckboxUnChecked } = this.props;

    if(ev.target.checked)
      onCheckboxChecked(attendance);
    else
      onCheckboxUnChecked(attendance)
  }

  addEmail(ev) {
    ev.preventDefault();

    this.props.updateAttendanceEmail(this.props.attendance.id, this.state.email)
  }

  handleInputChange(ev) {
    this.setState({ email: ev.target.value });
  }

  showEmail() {
    const { isEditing, email } = this.state;
    if (!isEditing) {
      return (
        <div>
          <span style={{ marginRight: '10px' }}>{email}</span>
          <i className='fa fa-pencil' onClick={()=> (this.setState({isEditing: true}))}/>
        </div>
      )
    }else
      return (
        <div>
          <form onSubmit={this.addEmail.bind(this)}>
            <input type='email' placeholder='Add Email'
              className='tag-input'
              value={email}
              onChange={this.handleInputChange.bind(this)}
            />
            <button className='btn btn-primary'>Add</button>
          </form>
        </div>
      )
  }

  render() {
    const { attendance, checked } = this.props;
    return (
      <tr key={attendance.id}>
        <td>{attendance.name}</td>
        <td>{this.showEmail()}</td>
        <td>{attendance.rsvp_status}</td>
        <td><input type='checkbox' checked={checked} onChange={this.handleChange.bind(this)}/></td>
      </tr>
    );
  }
}

export default RemoteAttendance;
