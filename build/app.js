require.config({
    baseUrl: './',

    urlArgs: "bust=" +  (new Date()).getTime(), //TODO: removeme

    paths: {
        'Backbone': '../node_modules/backbone/backbone-min',
        'React': '../node_modules/react/dist/react.min',
        '_': '../node_modules/lodash/index',
        '$': 'http://yastatic.net/jquery/2.1.3/jquery.min',
        'inherit': '../node_modules/inherit/lib/inherit',
        'assert': './app/assert'
    },

    shim: {
        '$': {
            exports: '$'
        }
    },

    map: {
        '*': {
            'jquery': '$',
            'underscore': '_'
        }
    }
});

require(['./app/app.js'], function() {});
