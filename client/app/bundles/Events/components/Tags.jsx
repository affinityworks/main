import React, { Component } from 'react';
import axios from 'axios';
import { groupPath } from '../utils/Pathnames';

class Tags extends Component {
  constructor(props) {
    super(props);

    this.state = { tags: this.props.tags, isEditing: false, tagName: '' };
  }

  showAddTagIcon() {
    if(!this.state.isEditing)
      return <i className="fa fa-plus tag-action" aria-hidden="true" onClick={this.addTagClick.bind(this)}/>
  }

  cancelTagCreation() {
    this.setState({isEditing: false});
  }

  createTag(ev) {
    const tag_name = this.state.tagName;
    ev.preventDefault();
    axios.post(`${groupPath(this.props.groupId)}/tags.json`, { tag_name }).then(response => {
      const tags = this.state.tags.concat(response.data);
      this.setState({ tags, isEditing: false, tagName: '' })
    })
  }

  handleInputChange(ev) {
    this.setState({ tagName: ev.target.value });
  }

  showAddTagInput() {
    if(this.state.isEditing) {
      return(
        <div className='add-tag-container'>
          <form onSubmit={this.createTag.bind(this)}>
            <i className="fa fa-minus tag-action" aria-hidden="true" onClick={this.cancelTagCreation.bind(this)}/>
            <input className='tag-input' type='text'
              value={this.state.tagName}
              onChange={this.handleInputChange.bind(this)}
            />
            <button className="fa fa-plus tag-action tag-action--create" aria-hidden="true" />
          </form>
        </div>
      )
    }
  }

  addTagClick() {
    this.setState({isEditing: true});
  }

  render() {
    const { tags } = this.state;
    return (
      <div>
        {this.showAddTagInput()}
        <div>
          {tags.map((tag) => (<span className='tag' key={tag.id}>{tag.name}</span>))}
          {this.showAddTagIcon()}
        </div>
      </div>
    )
  }
}

export default Tags;
