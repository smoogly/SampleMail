module.exports = function(config) {
    config.set({
        basePath: './',
        frameworks: ['mocha', 'expect', 'sinon'],
        files: [
            //Specs
            "test/**/*.js"
        ],
        singleRun: true,
        reporters: ['progress'],
        port: 9876,
        colors: true,
        logLevel: config.LOG_INFO,
        browsers: ['PhantomJS'],
        captureTimeout: 60000
    });
};
