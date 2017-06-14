import React, { Component } from 'react';
import axios from 'axios';
import _ from 'lodash';
import queryString from 'query-string';
import { withRouter } from 'react-router';

import { groupPath, eventWithoutGroupPath, membershipWithoutGroupPath } from '../utils/Pathnames';

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
    this.setState({ isEditing: false });
  }

  tagResourceData() {
    let resource_type = '';
    let resource_id = '';
    const { groupId, eventId, membershipId } = this.props

    if (groupId) {
      resource_type = 'group';
      resource_id = groupId;
    } else if (eventId) {
      resource_type = 'event';
      resource_id = eventId;
    } else if (membershipId) {
      resource_type = 'membership';
      resource_id = membershipId;
    }

    return { resource_type, resource_id }
  }

  createTag(ev) {
    ev.preventDefault();

    const tag_name = this.state.tagName;
    const { resource_type, resource_id } = this.tagResourceData();

    axios.post(`/tags.json`, { tag_name, resource_type, resource_id })
      .then(response => {
        const tags = this.state.tags.concat(response.data);
        this.setState({ tags, isEditing: false, tagName: '' })
      });
  }

  removeTag(id) {
    axios.delete(`/tags/${id}.json`, { params: this.tagResourceData() })
      .then(response => {
        const tags = _.filter(this.state.tags, (tag) => (tag.id != id));
        this.setState({ tags })
      });
  }

  handleInputChange(ev) {
    this.setState({ tagName: ev.target.value });
  }

  addTagFilter(tag) {
    this.props.history.push(`?${queryString.stringify({ tag })}`);
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
    this.setState({ isEditing: true });
  }

  showTags() {
    const { tags } = this.state;
    return (
      tags.map(({ name, id }) => (
        <span className='tag'
          key={id}
          onClick={() => (this.addTagFilter(name))}>
          {name}

          <span
            className='tag-action--remove'
            onClick={(e) => { e.stopPropagation(); this.removeTag(id); }}>
            &times;
          </span>
        </span>
      )))
  }

  render() {
    return (
      <div>
        {this.showAddTagInput()}
        <div>
          {this.showTags()}
          {this.showAddTagIcon()}
        </div>
      </div>
    )
  }
}

export default withRouter(Tags);
