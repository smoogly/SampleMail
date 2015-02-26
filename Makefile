MAKEFLAGS+=-j 15
NPM_BIN=$(CURDIR)/node_modules/.bin



#----------------------------------------------------
# Variables
#----------------------------------------------------
BUILD_DIR=build
TEST_BUILD_DIR=test/_build

#Build coffee files into build/app tree
COFFEE=$(shell find ./app -type f | egrep '\.coffee$$')
COFFEE_BUILT=$(foreach cfile, $(COFFEE), $(BUILD_DIR)/$(cfile:.coffee=.js))

TESTS=$(shell find ./test -type f | egrep '\.coffee$$')
TESTS_BUILT=$(foreach cfile, $(TESTS), $(TEST_BUILD_DIR)/$(cfile:.coffee=.js))


#Build jsx files into build/app tree
JSX=$(shell find ./app -type f | egrep '\.jsx$$')
JSX_BUILT=$(foreach jsx, $(JSX), $(BUILD_DIR)/$(jsx:.jsx=.js))


# use NPMCACHE=y to skip loading cached packages from the registry
NPMCACHE?=n


# use MIN=n to skip minimizing files
MIN?=y

ifeq ($(MIN),y)
	MINIMIZE_CSS=--output-style=compressed
else
	MINIMIZE_CSS=--output-style=expanded
endif




#----------------------------------------------------
# Targets
#----------------------------------------------------

all: coffee jsx node_modules $(BUILD_DIR)/app/style.css

coffee: $(COFFEE_BUILT)

jsx: $(JSX_BUILT)

clean:
	rm -rf $(BUILD_DIR)/app
	rm -rf $(TEST_BUILD_DIR)

clean-all: clean
	rm -rf node_modules

prepare-tests: coffee jsx $(TESTS_BUILT) node_modules

$(BUILD_DIR)/app/style.css: node_modules ./app/style.sass
	$(NPM_BIN)/node-sass $(MINIMIZE_CSS) ./app/style.sass ./build/app/style.css


node_modules: package.json
ifeq ($(NPMCACHE),y)
	@echo "Installing npm modules from cache, if available"
	npm install --cache-min 86400
else
	@echo "Loading npm modules"
	npm install
endif

	# In case node_modules are older than package.json, make would always rebuild this target
	@touch node_modules



.SECONDEXPANSION:

$(COFFEE_BUILT): dependency=$(subst $(BUILD_DIR)/,, $(@:.js=.coffee))
$(COFFEE_BUILT): outdir=$(dir $@)
$(COFFEE_BUILT): $$(dependency) node_modules
	$(NPM_BIN)/coffee -o $(outdir) -c $<



$(TESTS_BUILT): dependency=$(subst $(TEST_BUILD_DIR)/,, $(@:.js=.coffee))
$(TESTS_BUILT): outdir=$(dir $@)
$(TESTS_BUILT): $$(dependency) node_modules
	$(NPM_BIN)/coffee -o $(outdir) -c $<



$(JSX_BUILT): dependency=$(subst $(BUILD_DIR)/,, $(@:.js=.jsx))
$(JSX_BUILT): $$(dependency) node_modules
	mkdir -p $(dir $@)
	@echo "define(['React'], function(React) { return function() { return (" > $@
	$(NPM_BIN)/jsx $< >> $@
	@echo ")};});" >> $@


.PHONY: all clean clean-all
