
all:
	@make build

clean:
	@( /bin/rm -fr _site/* )

build:
	@( make clean )
	@( jekyll build )

watch:
	@( jekyll serve --watch --drafts )

deploy:
	@( make clean )
	@( jekyll build )
	( cd _site ; rsync -aruv --delete * dpw@raincitysoftware.com:blog.raincitysoftware.com/ )

.PHONY:	clean
.PHONY:	build
.PHONY:	deploy
.PHONY:	watch
