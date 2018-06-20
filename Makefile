test:
	@./node_modules/.bin/mocha --compilers "coffee:coffee-script/register" test/*.coffee 
.PHONY: test
