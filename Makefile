MAKEFLAGS+=-j 15
NPM_BIN=$(CURDIR)/node_modules/.bin



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

all: node_modules

clean:
	@echo "Pass..."

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




.PHONY: all clean clean-all
