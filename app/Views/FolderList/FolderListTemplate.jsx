<ul className="folder-list col-xs-2">
    {this.state.folders ? this.state.folders.map((function(folder) {
        var classes = React.addons.classSet({
            'folder-list-item': true,
            'current': folder === this.state.currentFolder
        });

        return (
            <li className={classes} onClick={this.setCurrent.bind(this, folder)}>
                {folder}
            </li>
        )
    }).bind(this)) : ''}
</ul>
