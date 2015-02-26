var reqConfig = { //Not inlined so that tests can update it
    baseUrl: './',

    urlArgs: "bust=" +  (new Date()).getTime(), //TODO: removeme

    paths: {
        'es5-shim': '../node_modules/es5-shim/es5-shim.min',
        'es5-sham': '../node_modules/es5-shim/es5-sham.min',

        'Backbone': '../node_modules/backbone/backbone-min',
        'inherit': '../node_modules/inherit/lib/inherit',
        'React': '../node_modules/react/dist/react-with-addons',
        '_': '../node_modules/lodash/index',

        '$': 'http://yastatic.net/jquery/2.1.3/jquery.min',

        'assert': './app/assert',
        'util': './app/util'
    },

    shim: {
        '$': {
            exports: '$'
        },
        'React': ['es5-shim', 'es5-sham'],
        'es5-sham': ['es5-shim'] //Load shim before sham (otherwise there's a race condition)
    },

    map: {
        '*': {
            'jquery': '$',
            'underscore': '_'
        }
    }
};

require.config(reqConfig);
