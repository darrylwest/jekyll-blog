
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
	@( /bin/rm -f _site/Makefile )
	( cd _site ; rsync -aruv * dpw@raincitysoftware.com:blog.raincitysoftware.com/ )

.PHONY:	clean
.PHONY:	build
.PHONY:	deploy
.PHONY:	watch
