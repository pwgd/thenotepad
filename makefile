SHELL = /bin/bash

# The method Pollen provides for generating the static files for your book is
# to build individual target files, or to build an entire ptree. The principle
# of ‘The book is a program’ means that any one source file/template could
# theoretically affect the output generated by any of the others. So rebuilding
# entire ptrees is the safest, simplest way to ensure that any updates propagate
# fully throughout the entire generated book.

# A makefile allows us to specify more specific dependency relationships between
# files in our particular project. We can now just type ‘make’ from the
# project directory to re-generate only those files that actually need it.

core-files := pollen.rkt \
              index.ptree \
			  util-date.rkt \
			  pollen-local/polytag.rkt \
			  pollen-local/common-helpers.rkt \
			  pollen-local/publication-vals.rkt

# Create variables with lists of all source files in the posts/ folder,
# then generate lists of target files.
posts-sourcefiles := $(wildcard posts/*.poly.pm)

# I want to show off my Pollen source files, so I name them .pollen.html
posts-sourcelistings := $(patsubst %.poly.pm,%.pollen.html,$(posts-sourcefiles))
posts-html := $(patsubst %.poly.pm,%.html,$(posts-sourcefiles))
posts-pdf := $(patsubst %.poly.pm,%.pdf,$(posts-sourcefiles))

other-sourcefiles := books.html.pm about.html.pm
other-html := $(patsubst %.html.pm,%.html,$(other-sourcefiles))
other-sourcelistings := $(patsubst %.html.pm,%.pollen.html,$(other-sourcefiles))

# The ‘all’ rule references the rules BELOW it (the above are just variable
# definitions, not rules).
all: $(posts-sourcelistings) $(posts-html) $(posts-pdf) $(other-html) $(other-sourcelistings) index.html feed.xml topics.html
all: ## Re-generate site including PDFs and RSS

# My dependencies are roughly as follows: for each .poly.pm file I want to
# generate an HTML file, a PDF file, and a .pollen.html file (so people can see
# the Pollen source). The index.html, book-index and Atom feed should be rebuilt
# if any of the source files change. 

# The two rules allow us to say, in effect, “each source listing .pollen.html
# depends on its corresponding .poly.pm file, but also on util/make-html-source.sh.”
# So it will run its recipe if any of those dependencies have changed.
$(posts-sourcelistings): util/make-html-source.sh
$(posts-sourcelistings): %.pollen.html: %.poly.pm
	util/make-html-source.sh $< > $@; \
	tidy -quiet -modify -indent --wrap 0 --tidy-mark no --drop-empty-elements no $@ || true

$(posts-html): $(core-files) template.html.p util-template.rkt pollen-local/tags-html.rkt
$(posts-html): %.html: %.poly.pm
	raco pollen render -t html $<; \
	tidy -quiet -modify -indent --wrap 0 --tidy-mark no --drop-empty-elements no $@ || true

$(posts-pdf): $(core-files) template.pdf.p util-template.rkt pollen-local/tags-pdf.rkt
$(posts-pdf): %.pdf: %.poly.pm
	raco pollen render -t pdf $<

# touch command forces Pollen to ignore any cached compile
feed.xml: $(core-files) $(posts-sourcefiles) feed.xml.pp util-template.rkt pollen-local/tags-html.rkt
	touch feed.xml.pp; \
	raco pollen render feed.xml.pp

# touch command forces Pollen to ignore any cached compile
index.html: $(core-files) $(posts-sourcefiles) 
index.html: index.html.pp util-template.rkt pollen-local/tags-html.rkt
	touch index.html.pp; \
	raco pollen render $@; \
	tidy -quiet -modify -indent --wrap 0 --tidy-mark no --drop-empty-elements no $@ || true

$(other-html): pollen.rkt template.html.p pollen-local/tags-html.rkt
$(other-html): %.html: %.html.pm
	raco pollen render $@; \
	tidy -quiet -modify -indent --wrap 0 --tidy-mark no --drop-empty-elements no $@ || true

$(other-sourcelistings): util/make-html-source.sh
$(other-sourcelistings): %.pollen.html: %.html.pm
	util/make-html-source.sh $< > $@

topics.html: topics.html.pp $(core-fils) $(posts-sourcefiles) pollen-local/tags-html.rkt
	touch topics.html.pp; \
	raco pollen render topics.html.pp; \
	tidy -quiet -modify -indent --wrap 0 --tidy-mark no --drop-empty-elements no $@ || true

.PHONY: all publish spritz zap help

# Doing ‘make publish’ automatically upload everything except the Pollen source
# files to the public web server. The NOTEPAD_SRV is defined as an environment
# variable for security reasons (never put credentials in a script!)
# Make sure yours is of the form ‘username@serverdomain.com:public_html/’
# See also the docs for ‘raco pollen publish’:
#  http://pkg-build.racket-lang.org/doc/pollen/raco-pollen.html

publish: ## Rsync the website to the public web server (does not rebuild site first)
	rm -rf posts/pollen-latex-work flatland/pollen-latex-work; \
	raco pollen publish; \
    rsync -av ~/Desktop/publish/ -e 'ssh -p $(WEB_SRV_PORT)' $(NOTEPAD_SRV) --delete --exclude=projects --exclude=.git --exclude=drafts --exclude=pollen-local --exclude=.DS_Store --exclude=.gitignore --exclude='template*.*' --exclude=makefile --exclude=util --exclude='posts/img/originals'; \
    rm -rf ~/Desktop/publish

# ‘make spritz’ just cleans up the pollen-latex-work files and clears the Pollen cache; 
# ‘make zap’ deletes all output files as well.
spritz: ## Just cleans up LaTeX working folders
	rm -rf posts/pollen-latex-work pollen-latex-work; \
	raco pollen reset

zap: ## Resets Pollen cache, deletes LaTeX working folders, feed.xml and all .html, .ltx files
	rm -rf posts/pollen-latex-work pollen-latex-work; \
	rm posts/*.html posts/*.pdf; \
	rm feed.xml; \
	rm *.html *.pdf; \
	raco pollen reset

# Self-documenting make file (http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html)
help: ## Displays this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
