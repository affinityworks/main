import React, { Component } from 'react';
import RichTextEditor from 'react-rte';
import {convertToRaw} from 'draft-js';
import UserAuth from '../components/UserAuth';
import { client, groupPath } from '../utils';

class TextEditor extends Component {
  state = {
    value: RichTextEditor.createEmptyValue(),
    format: 'html',
    preview: true,
    editor: false
  }

  componentWillMount() {
    const { textDescription } = this.props
    const markup = textDescription ? textDescription : '<p></p>'

    this.setState({value: RichTextEditor.createValueFromString(`${markup}`, 'html')});
  }

  updateDescription (description) {
    client.put(`${groupPath()}.json`, { group: {description: `${description}`} })
    .then(response => { 
      let type = 'success';
    })
    .catch(err => {
      let text = 'An error ocurred';
      let type = 'error';
      this.props.addAlert({ text, type });
    });
  }

  handleCancel = () => {
    const { hideTextEdit } = this.props
    hideTextEdit()
  }

  handleShowPreview = () => {
    this.setState({ preview: false });
  }

  handleShowWrite = () => {
    this.setState({ preview: true });
  }

  handleShowEditor = () => {
    this.setState({ editor: true })
    this.setState({ preview: true })
  }

  handleHideEditor = () => {
    this.setState({ editor: false })
  }

  handleCancelEditor = () => {
    const { textDescription } = this.props
    const markup = textDescription ? textDescription : '<p></p>'

    this.setState({value: RichTextEditor.createValueFromString(`${markup}`, 'html')});
    this.setState({ editor: false })
  }

  onChange = (value) => {
    const { onChange } = this.props  
    this.setState({value});

    if (onChange) {
      onChange(value.toString('html'));
    }
  }

  onChangeSource = (event: Object) => {
    let source = event.target.value;
    let oldValue = this.state.value;

    this.setState({
      value: oldValue.setContentFromString(source, this.state.format),
    });
  }

  saveDescription = () => {
    const { textDescription } = this.props
    const {
      state: { value, format },
      props: { hideTextEdit }
    } = this

    const textValue = value.toString(format)

    this.updateDescription(textValue);
    this.handleHideEditor();
  }

  renderDescription () {
    const { value, format } = this.state
    const textValue = value.toString(format)

    return (
      <div className='col-md-12'>
          <div className='row'>
            <div className="col-md-3">
                <h4>Aditional Description</h4>
            </div>
            <UserAuth allowed={['organizer']}>
              <div className='col-md-12 mb-3'>
                <button
                  className='btn btn-primary btn-sm btn-edit'
                  onClick={this.handleShowEditor.bind(this)}
                >
                  <span className='fa fa-pencil-square-o'></span> Edit description
                </button>
              </div>
            </UserAuth>
          </div>

          <div className='text-preview'>
            <div dangerouslySetInnerHTML={{ __html: textValue }} />
          </div>
      </div>
    )
  }

  renderEditor () {
    const {
      state: {
        value,
        format,
        preview
      },
      saveDescription,
      handleCancelEditor,
      handleShowPreview,
      handleShowWrite
    } = this

    const textValue = value.toString(format)

    const toolbarConfig = {
      display: [
        'INLINE_STYLE_BUTTONS',
        'BLOCK_TYPE_BUTTONS', 
        'LINK_BUTTONS',
        'BLOCK_TYPE_DROPDOWN', 
        'HISTORY_BUTTONS'
      ],
      INLINE_STYLE_BUTTONS: [
        {label: 'Bold', style: 'BOLD', className: 'custom-css-class'},
        {label: 'Italic', style: 'ITALIC'},
        {label: 'Underline', style: 'UNDERLINE'}
      ],
      BLOCK_TYPE_DROPDOWN: [
        {label: 'Normal', style: 'unstyled'},
        {label: 'Heading Large', style: 'header-one'},
        {label: 'Heading Medium', style: 'header-two'},
        {label: 'Heading Small', style: 'header-three'}
      ],
      BLOCK_TYPE_BUTTONS: [
        {label: 'UL', style: 'unordered-list-item'},
        {label: 'OL', style: 'ordered-list-item'}
      ]
    };
    return (
      <div className='col-md-12'>
        <div className="row">
          <div className="col-md-3">
              <h4>Aditional Description</h4>
          </div>
          <div className='col-md-4'>
            <button
              className={`btn ${preview ? 'btn-primary' : 'btn-secondary'}  btn-sm mr-2`}
              onClick={handleShowWrite.bind(this)}
            >
              Write
            </button>
            <button
              className={`btn ${!preview ? 'btn-primary' : 'btn-secondary'} btn-sm`}
              onClick={handleShowPreview.bind(this)}
            >
              <span className='fa fa-code'></span>
            </button>
          </div>
        </div>

        <div className='Text-editor'>
          { preview
            ? <RichTextEditor
                className='mb-3'
                toolbarConfig={toolbarConfig}
                onChange={this.onChange}
                value={this.state.value}
              />
            : <div className='col-md-12 px-0'>
                <textarea
                  className="text-source mb-3"
                  placeholder="Editor Source"
                  onChange={this.onChangeSource}
                  value={this.state.value.toString('html')}
                />
              </div>
          }
          <button
            className='btn btn-primary btn-sm mr-2'
            onClick={saveDescription.bind(this)}
          >
            <span className='fa fa-save'></span>
            <span> Save</span>
          </button>
          <button 
            className='btn btn-secondary btn-sm btn-delete'
            onClick={handleCancelEditor.bind(this)}
          >
            <span className='fa fa-close'></span>
            <span> Cancel</span>
          </button>
        </div>
      </div>
    )
  }

  render () {
    const { editor } = this.state

    return (
      <div className='row text-view mb-3'>
        { editor ? this.renderEditor() : this.renderDescription() }
      </div>
    );
  }
}

export default TextEditor;
