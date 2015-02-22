var testFiles = [];

var pathToTestFile = function(path) {
    return path.replace(/^\/base\//, '../').replace(/\.js$/, '');
};

var testFileRe = /\/test\/_build/;
Object.keys(window.__karma__.files).forEach(function(file) {
    if (testFileRe.test(file)) {
        // Normalize paths to RequireJS module names.
        testFiles.push(pathToTestFile(file));
    }
});

//Remove cache bust from urlArgs
reqConfig.urlArgs = ''; //TODO: remove after cachebust is removed

reqConfig.baseUrl = '/base/build';
reqConfig.deps = testFiles;
reqConfig.callback = window.__karma__.start;

require.config(reqConfig);



