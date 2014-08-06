
all:
	@make watch

clean:
	@( /bin/rm -fr _site/* )

build:
	@( make clean )
	@( jekyll build )

watch:
	@( jekyll serve --watch )

deploy:
	@( make clean )
	@( rm _site/Makefile _sige/CNAME )
	( cd _site ; rsync -arvu * dpw@raincitysoftware.com:blog.raincitysoftware.com/ )

.PHONY:	clean
.PHONY:	build
.PHONY:	deploy
.PHONY:	watch
