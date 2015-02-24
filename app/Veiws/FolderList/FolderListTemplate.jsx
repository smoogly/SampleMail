<ul>
    {this.state.folders ? this.state.folders.map(function(folder) {
        return (
            <li>
                {folder}
            </li>
        )
    }) : ''}
</ul>
