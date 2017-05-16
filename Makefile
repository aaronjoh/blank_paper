SOURCES = paper.tex 
EPSTEXFILES = $(wildcard figures/*.eps_tex)
FIGURETEXFILESTMP = $(EPSTEXFILES:.eps_tex=.tex)
FIGURETARGET = $(FIGURETEXFILESTMP:figures/%=%)
ALLTEXFILES = $(wildcard *.tex) #*.bib
TARGETS = $(SOURCES:.tex=.ps)
PDFTARGETS = $(SOURCES:.tex=.pdf)
ERRSYM = $(shell grep --color='auto' -P -n '[^\x00-\x7F]' $(ALLTEXFILES) $(wildcard *.bib) )


all: $(PDFTARGETS) simpleclean

noclean: $(PDFTARGETS)

$(PDFTARGETS): $(TARGETS)
	@echo 'generating pdf file: $@'
	ps2pdf14 -dPDFSETTINGS=/prepress $< $@

$(FIGURETARGET): %.tex : $(EPSTEXFILES)
	echo $(FIGURETARGET)
	echo 'Figure being worked on $@'
	sed s_unitlength]{_unitlength]{figures/_ <figures/$(@:.tex=.eps_tex) >$@

$(TARGETS): %.ps : %.tex $(FIGURETARGET) $(ALLTEXFILES) 
	@echo $(TARGETS)
	@ $(if $(ERRSYM), grep --color='auto' -P -n '[^\x00-\x7F]' $(ALLTEXFILES) $(wildcard *.bib); echo "\033[0;31mERROR: Non-standard characters\033[0m"; exit 2)
	@echo 'tex file being worked on: $<'
	@latex $<
	bibtex $(<:.tex=)
	latex $< && latex $< && latex $<
	dvips $(<:.tex=.dvi) -o $(<:.tex=.ps) -t letter -Ppdf -G0

simpleclean:
	@rm -f *.dvi *.log *.bbl *.aux *.blg *.pfg *.out *~

clean: simpleclean
	@rm -f *.ps *.pdf *~ *.dvi *.log *.aux *.bbl *.blg

check:
	@echo 'This check will search for special characters, words, and repeated words that you may want to correct, however these may or may not be errors!'
	@grep --color='auto' -P -n '[^\x00-\x7F]' $(ALLTEXFILES) $(wildcard *.bib) || true
	@grep --color='auto' -P -n '\x22' $(ALLTEXFILES) || true	
	@grep --color='auto' -n 'naive' $(ALLTEXFILES) || true
	@grep --color='auto' -n 'will' $(ALLTEXFILES) || true
	@grep --color='auto' -n '\b\([[:alpha:]]\+\)\b \1\b' $(ALLTEXFILES) $(wildcard *.bib) || true
	@grep --color='auto' -n -H '[pP]ages.\+[[:digit:]]-[[:digit:]]\+}' $(wildcard *.bib) || true
	@grep --color='auto' -n -H '[vV]olume.\+[[:digit:]]-[[:digit:]]\+}' $(wildcard *.bib) || true
	@grep --color='auto' -n -H '[nN]umber.\+[[:digit:]]-[[:digit:]]\+}' $(wildcard *.bib) || true
	@grep --color='auto' -n -e 'e\.g\. ' -e 'e\.g\.$$' $(ALLTEXFILES) || true
	@grep --color='auto' -n -e 'i\.e\. ' -e 'i\.e\.$$' $(ALLTEXFILES) || true
	@grep --color='auto' -n -e 'c\.f\. ' -e 'c\.f\.$$' $(ALLTEXFILES) || true
	@grep --color='auto' -n -e '{\\em ' -e'{ \\em ' -e '{  \\em ' -e '\\emph{ ' -e '\\emph{.* }' $(ALLTEXFILES) || true
	@grep --color='auto' -n -e '\\textit{' $(ALLTEXFILES) || true

arxiv: clean $(PDFTARGETS) arxiv_do simpleclean

lparen:=(
rparen:=)

arxiv_do:
	@touch arxiv_upload
	@rm -rf arxiv_upload
	@mkdir -p arxiv_upload/figures
	@cp `cat $(SOURCES:.tex=.log) |grep -o '$(lparen).*\.tex'|grep -v '/usr/'|sed -e 's_$(lparen)./__' -e 's_$(rparen) $(lparen)./_\n_g' -e 's_ .*\n_\n_g'` arxiv_upload/
	@cp `cat $(SOURCES:.tex=.log) |grep Graphic\ file\ \(type\ eps\) | sed -e 's_File: __' -e 's_ Graphic file (type eps)__'` arxiv_upload/figures
	@cp *.bib *.cls *.bbl *.bst arxiv_upload/
	@touch arxiv_upload.zip
	@rm arxiv_upload.zip
	@zip -rq arxiv_upload.zip arxiv_upload/*
	@echo "Folder arxiv_upload created and zip file arxiv_upload.zip"

