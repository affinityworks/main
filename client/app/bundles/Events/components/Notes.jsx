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
      type: 'membership',
      id: this.props.membershipId
    }

    axios.post('/notes', { note })
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
      <div className='list-group'>
        {this.renderNotes()}
        <form onSubmit={this.handleSubmit().bind(this)}>
          <textarea
            className='form-control'
            value={this.state.text}
            onChange={(e) => this.setState({ text: e.target.value })} />
          <button className='btn btn-primary' style={{ marginTop: '5px' }}>
            Save
          </button>
        </form>

      </div>
    );
  }
}

export default Notes;
