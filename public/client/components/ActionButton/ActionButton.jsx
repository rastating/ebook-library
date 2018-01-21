import React from 'react';

class ActionButton extends React.Component {

  constructor (props) {
    super(props);
    this.state = {
      inProgress:   props.inProgress || false,
      idleText:     props.idleText,
      progressText: props.progressText,
      icon:         props.icon || 'fa-spinner'
    }
  }

  componentWillReceiveProps (nextProps) {
    this.setState({
      inProgress: nextProps.inProgress || false
    });
  }

  render () {
    return (
      <button disabled={this.state.inProgress ? 'disabled' : ''} onClick={this.props.onClick} className="btn btn-lg btn-primary btn-block">
        <span style={{ display: this.state.inProgress ? 'inline' : 'none' }}>
          <i className={ 'fas fa-spin ' + this.state.icon }></i>&nbsp;
          {this.state.progressText}
        </span>
        <span style={{ display: this.state.inProgress ? 'none' : 'inline' }}>
          {this.state.idleText}
        </span>
      </button>
    );
  }
}

export default ActionButton
