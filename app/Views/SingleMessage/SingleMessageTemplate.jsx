<div>
    <div>
        <i className="message-to-trash fa fa-trash-o" onClick={this.toTrash}></i>
    </div>
    <h1>{this.state.title}</h1>
    <div dangerouslySetInnerHTML={{__html: this.state.body}} />
</div>
