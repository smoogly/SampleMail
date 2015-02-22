<div>
    Title: {this.getModel().toJSON().title}<br />
    Body: <br />
    <span dangerouslySetInnerHTML={{__html: this.getModel().toJSON().body }} />
</div>
