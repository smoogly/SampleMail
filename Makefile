MAKEFLAGS+=-j 15
NPM_BIN=$(CURDIR)/node_modules/.bin



#----------------------------------------------------
# Variables
#----------------------------------------------------

#Build coffee files into build/app tree
COFFEE=$(shell find ./app -type f | egrep '\.coffee$$')
COFFEE_BUILT=$(foreach cfile, $(COFFEE), build/$(cfile:.coffee=.js))


#Build jsx files into build/app tree
JSX=$(shell find ./app -type f | egrep '\.jsx$$')
JSX_BUILT=$(foreach jsx, $(JSX), build/$(jsx:.jsx=.js))


# use NPMCACHE=y to skip loading cached packages from the registry
NPMCACHE?=n


# use MIN=n to skip minimizing files
MIN?=y

ifeq ($(MIN),y)
	MINIMIZE_JS=--minimize=true
	MINIMIZE_CSS=--minimize=true
else
	MINIMIZE_JS=--minimize=false
	MINIMIZE_CSS=--minimize=false
endif




#----------------------------------------------------
# Targets
#----------------------------------------------------

all: coffee jsx node_modules

coffee: $(COFFEE_BUILT)

jsx: $(JSX_BUILT)

clean:
	rm -rf build/app

clean-all: clean
	rm -rf node_modules



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

$(COFFEE_BUILT): dependency=$(subst build/,, $(@:.js=.coffee))
$(COFFEE_BUILT): outdir=$(dir $@)
$(COFFEE_BUILT): $$(dependency) node_modules
	$(NPM_BIN)/coffee -o $(outdir) -c $<

$(JSX_BUILT): dependency=$(subst build/,, $(@:.js=.jsx))
$(JSX_BUILT): $$(dependency) node_modules
	mkdir -p $(dir $@)
	@echo "define(['React'], function(React) { return function() { return (" > $@
	$(NPM_BIN)/jsx $< >> $@
	@echo ")};});" >> $@


.PHONY: all clean clean-all
