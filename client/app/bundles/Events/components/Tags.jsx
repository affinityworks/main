import { filter, map, flatten, uniq } from 'lodash';
import React, { Component } from 'react';
import queryString from 'query-string';
import { withRouter } from 'react-router';

import {
  groupPath, eventWithoutGroupPath, membershipWithoutGroupPath, client
} from '../utils';

class Tags extends Component {
  constructor(props) {
    super(props);

    this.state = { tags: this.props.tags, isEditing: false, tagName: '', initialItems: [], items: []};
  }

  componentWillMount() {
    const { tagList } = this.props
    const values = map(tagList, (item) => {
      return item.name
    });

    this.setState({ initialItems: values })
  }

  componentDidUpdate() {
    if(this.tagsInput) { this.tagsInput.focus() }
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

    client.post(`/tags.json`, { tag_name, resource_type, resource_id })
      .then(response => {
        const tags = this.state.tags.concat(response.data);
        this.setState({ tags, isEditing: false, tagName: '' })
        this.state.initialItems.push(`${tag_name}`)
      });
  }

  removeTag(id) {
    client.delete(`/tags/${id}.json`, { params: this.tagResourceData() })
      .then(response => {
        const tags = filter(this.state.tags, (tag) => (tag.id != id));
        this.setState({ tags })
      });
  }

  updateList (e) {
    const { initialItems } = this.state;
    const value = e.target.value

    return initialItems.filter((item) => {
      return item.toLowerCase().search(
        value.toLowerCase()) !== -1
    })
  }

  addTagName (name) {
    this.setState({ tagName: name })
    this.setState({ item: [] })
  }

  searchList () {
    const { item } = this.state

    return map(uniq(item), (items, idx) => {
      return (
        <li
          key={idx}
          className='tag-list__item' 
          onClick={() => (this.addTagName(items))}>
          {items}
        </li>
      )
    })
  }

  handleInputChange(ev) {
    this.setState({ tagName: ev.target.value });
    this.setState({ item: ev.target.value ? this.updateList(ev) : [] })
  }

  addTagFilter(tag) {
    if (this.props.match.params.id) {
      // we are in the MemberDetail view, need to go up a level
      this.props.history.push(`./?${queryString.stringify({ tag })}`);
    } else {
      // we are in the MembersTable view, just add filter
      this.props.history.push(`?${queryString.stringify({ tag })}`);
    }
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
              ref={(input) => { this.tagsInput = input }}
            />
            <ul className='tag-list'>
              {this.searchList()}
            </ul>
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
