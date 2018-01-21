import React from 'react';
import DOMPurify from 'dompurify'
import './styles.css';

class BookPopup extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      book: {},
      closed: true
    }

    this.close = this.close.bind(this);
    this.download = this.download.bind(this);
  }

  componentWillReceiveProps (newProps) {
    this.setState({
      book:   newProps.book,
      closed: newProps.closed
    });
  }

  download () {
    window.location.href = `/api/books/${this.state.book.id}/epub/${this.state.book.epub_name}`;
  }

  close () {
    this.setState({ closed: true });
    this.props.onClose();
  }

  render () {
    let coverURL = '';
    if (this.state.book.cover) {
      coverURL = `/api/books/${this.state.book.id}/cover/${this.state.book.cover}`;
    }
    else {
      coverURL = '/assets/images/missing-sm.jpg';
    }

    return (
      <div className={ `centered-flex-box book-popup ${this.state.closed ? 'closed' : ''}` }>
        <div className="container">
          <div className="row">
            <div className="col-md-12">
              <img src={coverURL} className="float-left mr-3 mb-3" />
              <h1>{this.state.book.title}</h1>
              <div className="text-muted mb-3"
                dangerouslySetInnerHTML={{__html: DOMPurify.sanitize(this.state.book.description)}}>
              </div>
              <button className="btn btn-lg btn-block btn-success" onClick={this.download}>Download</button>
              <button className="btn btn-lg btn-block btn-primary" onClick={this.close}>Close</button>
            </div>
          </div>
        </div>
      </div>
    );
  }

}

export default BookPopup
