import React from 'react';
import Alert from '../Alert/Alert.jsx';
import ActionButton from '../ActionButton/ActionButton.jsx';
import './styles.css';

class LoginPanel extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      username: '',
      password: '',
      rememberMe: false,
      failedLogin: false,
      loggingIn: false
    }

    this.handleInputChange = this.handleInputChange.bind(this);
    this.login = this.login.bind(this);
  }

  login () {
    this.setState({
      failedLogin: false,
      loggingIn: true
    });

    this.sendLoginRequest().then(data => {
      if (data.error) {
        this.setState({ failedLogin: true, loggingIn: false });
      }
      else {
        this.props.history.push('/');
      }
    });
  }

  sendLoginRequest () {
    return fetch('/api/session', {
      method: 'POST',
      credentials: 'same-origin',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        username: this.state.username,
        password: this.state.password
      })
    }).then(res => {
      return res.json()
    });
  }

  handleInputChange (event) {
    const target = event.target;
    const value  = target.type === 'checkbox' ? target.checked : target.value;
    const name   = target.id;

    this.setState({
      [name]: value
    });
  }

  render () {
    return (
      <div className="form-signin-container">
        <div className="form-signin">
          <div className="text-center mb-4">
            <div className="mb-4 logo p-4 d-inline-block">
              <i className="fas fa-book fa-5x text-white"></i>
            </div>
          </div>

          <Alert type="danger" visible={this.state.failedLogin}>
            The specified login credentials were incorrect.
          </Alert>

          <div className="form-label-group">
            <input id="username"
              type="text"
              className="form-control"
              placeholder="Username"
              value={this.state.username}
              onChange={this.handleInputChange}
              required
              autoFocus />
            <label htmlFor="username">Username</label>
          </div>

          <div className="form-label-group">
            <input id="password"
              type="password"
              className="form-control"
              placeholder="Password"
              value={this.state.password}
              onChange={this.handleInputChange}
              required />
            <label htmlFor="password">Password</label>
          </div>

          <ActionButton idleText="Sign in"
            progressText="Signing in..."
            inProgress={this.state.loggingIn}
            onClick={this.login} />
        </div>
      </div>
    );
  }

}

export default LoginPanel
