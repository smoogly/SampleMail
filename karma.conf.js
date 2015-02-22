var requireConfigPath = 'build/requireConfig.js';

var requireConfig = require('fs')
    .readFileSync(
        __dirname + '/' + requireConfigPath, {
            encoding: 'UTF-8'
        }
    );

var nodeDeps = require('lodash')
    .map(requireConfig.match(/node_modules[^"']+/g), function(nodeDep) {
        return {pattern: nodeDep + '.js', included: false};
    });

module.exports = function(config) {
    config.set({
        basePath: './',
        frameworks: ['requirejs', 'mocha', 'expect', 'sinon'],
        files: nodeDeps.concat([
            //Sources
            {pattern: 'build/app/**/*.js', included: false},

            //Built specs
            {pattern: 'test/_build/**/*.js', included: false},

            requireConfigPath,
            'test/requireTestsConfig.js'
        ]),
        singleRun: true,
        reporters: ['progress'],
        port: 9876,
        colors: true,
        logLevel: config.LOG_INFO,
        browsers: ['PhantomJS'],
        captureTimeout: 60000
    });
};
