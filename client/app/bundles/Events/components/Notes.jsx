import axios from 'axios';
import React, { Component } from 'react';

class Notes extends Component {
  state = { text: '', notes: [] }

  componentWillMount() {
    const { notes } = this.props;
    this.setState({ notes });
  }

  handleSubmit(e) {
    e.preventDefault();

    const note = {
      text: this.state.text,
      resource_type: 'membership',
      resource_id: this.props.membershipId
    }

    axios.post('/notes.json', { note })
      .then(response => {
        const notes = this.state.notes.concat(response.data);
        this.setState({ notes, text: '' })
      });
  }

  renderNotes() {
    const { notes } = this.state;

    return (
      notes.map(note => {
        return (
          <div key={note.id} className='list-group-item'>
            {note.text}
            <i style={{ fontSize: '12px', marginLeft: '10px' }}>
              ({note.author.name})
            </i>
          </div>
        )
      })
    );
  }

  render() {
    return (
      <div>
        <div
          className='list-group'
          style={{ maxHeight: '500px', overflow: 'scroll', display: 'block' }}>
          {this.renderNotes()}
        </div>
        <form style={{ marginTop: '20px' }} onSubmit={this.handleSubmit.bind(this)}>
          <textarea
            rows={3}
            className='form-control'
            value={this.state.text}
            onChange={(e) => this.setState({ text: e.target.value })} />
          <button className='btn btn-primary' style={{ marginTop: '20px' }}>
            Save
          </button>
        </form>

      </div>
    );
  }
}

export default Notes;
