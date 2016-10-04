class Doogle extends React.Component {
  constructor(props) {
    super(props);
    
    this.state = {
      word: "",
      definitions: []
    };
  }

  onInputChange(event) {
    this.setState({ word: event.target.value });
  }
  
  onFormSubmit(event) {
    event.preventDefault();
    
    var $form = $(event.target);
    $.ajax({
      url: $form.attr("action"),
      type: $form.attr("method"),
      contentType: "application/json; charset=utf-8",
      beforeSend: (xhr) => {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
      },
      dataType: 'json',
      data: JSON.stringify({ word: this.state.word })
    })
    .done((data) => {
      this.setState({ definitions: $.map(data.definitions, definition => definition.text) });
    })
    .fail((xhr) => {
      this.setState({ definitions: null }); 
    });
  }
  
  hasDefinitions() {
    return this.state.definitions && this.state.definitions.length > 0;
  }
  
  hasError() {
    return (this.state.word.length > 0) && !this.hasDefinitions(); 
  }
  
  renderDefinitions() {
    if (this.hasDefinitions()) {
      return this.state.definitions.map( definition => {
        return (
          <li key={definition} className="definition-item">
            {definition}
          </li>
        );
      });
    }
  }
  
  render () {
    return (
      <div className="doogle">
        <h1>
          <span className="blue">D</span>
          <span className="red">o</span>
          <span className="yellow">o</span>
          <span className="blue">g</span>
          <span className="green">l</span>
          <span className="red">e</span>
        </h1>
      
        <form action="/entries" method="post" onSubmit={this.onFormSubmit.bind(this)}>
          <div className={"form-group" + (this.hasError() ? " has-error" : "")}>
            <input 
              id="word-input"
              className="form-control"
              type="text"
              autoFocus="autofocus"
              value={this.state.word}
              onChange={this.onInputChange.bind(this)}
            />
          </div>
          <button type="submit" className="btn btn-primary">Doogle Search</button>
        </form>
        
        <div className="definitions">
          {this.renderDefinitions()}
        </div>
      </div>
    );
  }
}

module.exports = Doogle;