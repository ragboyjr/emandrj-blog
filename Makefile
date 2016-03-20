ifndef env
    env = dev
endif

ifndef SASS_OPTS
    SASS_OPTS = -t expanded
    ifeq ($(env), prd)
        SASS_OPTS = -t compressed
    endif
endif

CSS = static/css/emandrj.css

.PHONY: all hugo sass watch-sass unwatch-sass clean

all: sass hugo

hugo: bin/hugo
	hugo server --buildDrafts

sass: $(CSS)

watch-sass:
	watchman watch-project .
	watchman -- trigger sass sass-w '*.scss' -- make sass
unwatch-sass:
	watchman watch-del sass
	watchman watch-del .

clean:
	rm -rf $(CSS) bin

$(CSS): sass/emandrj.scss ./bin/sassc
	cat $< | ./bin/sassc -s $(SASS_OPTS) > $@

bin/hugo:
	@mkdir -p bin
	bash install-hugo.sh

bin/sassc:
	@mkdir -p bin tmp
	curl -sL https://api.github.com/repos/sass/sassc/tarball/3.3.3 | tar -C tmp -xpv
	curl -sL https://api.github.com/repos/sass/libsass/tarball/3.3.3 | tar -C tmp -xpv
	cd tmp/sass-sassc-*; SASS_LIBSASS_PATH=../$$(basename ../sass-libsass-*) make; mv bin/sassc ../../bin
	rm -rf tmp
