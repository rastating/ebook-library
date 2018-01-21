import React from 'react';
import './styles.css';

class LoadingPanel extends React.Component {

  constructor(props) {
    super(props);

    this.state = {
      isLoading: true,
      entity: props.entity
    }
  }

  componentWillReceiveProps (nextProps) {
    this.setState({ isLoading: nextProps.isLoading });
  }

  render () {
    let hiddenStyle = { opacity: 0 }
    let loadingPanelStyle = this.state.isLoading ? {} : hiddenStyle;
    let contentPanelStyle = this.state.isLoading ? hiddenStyle : {};

    return (
      <div className="h-100 position-relative">

        <div className="loading-panel-loader centered-flex-box" style={loadingPanelStyle}>
          <div className="d-block text-center text-muted">
            <i className="fas fa-spin fa-spinner fa-5x"></i>
            <span className="d-block mt-2">Loading {this.state.entity}...</span>
          </div>
        </div>

        <div className="loading-panel-content h-100" style={contentPanelStyle}>
          {this.props.children}
        </div>

      </div>
    );
  }

}

export default LoadingPanel
