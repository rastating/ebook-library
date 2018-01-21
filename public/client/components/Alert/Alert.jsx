import React from 'react';
import './styles.css';

class Alert extends React.Component {

  constructor (props) {
    super(props);
    this.state = {
      visible: props.visible || false,
      type:    props.style || 'danger'
    }
  }

  componentWillReceiveProps (nextProps) {
    this.setState({
      visible: nextProps.visible || false,
      type:    nextProps.style || 'danger'
    });
  }

  render () {
    let style = {
      opacity: this.state.visible ? 1.0 : 0
    };

    if (!this.state.visible) {
      style.height = 0;
      style.padding = 0;
      style.margin = 0;
      style.border = 'none';
    }

    return (
      <div className={ 'alert alert-' + this.state.type } style={style} role="alert">
        {this.props.children}
      </div>
    );
  }
}

export default Alert
