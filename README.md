# Aaron's Blank Paper Template

This format is overly complicated but works well. To set it up, change:
1. Rename `paper.tex` and `paper.bib` to something relevant for your project.
2. Edit `Makefile`, line 1, set `SOURCES = paper.tex` to your main file.
3. Edit `paper.tex`, (which should now be renamed), near the end change `paper` in `\bibliography{IEEEabrv,paper}` to your bib file name
4. Then you can start changing the title, authors, etc in the new `paper.tex`, rename the sections (e.g. `2-body.tex`, though update `paper.tex` if you do), etc.
5. You may also want to set per-author editing notes in `paper.tex`, to replace the examples `\tom` and `\sidd`.
6. I prefer not to upload `.pdf` and `.ps` files that are created, but there may be other pdfs that should be. So add the output file name (replacing `paper.pdf`) to `.gitignore` 

Structure:
* Main file is whatever replaced `paper.tex`, no actual text should show up here
* Included `.tex` files per-section, i.e. `1-introduction.tex`
* Figures go in `figures/`, and if exporting from inkscape use the `.eps_tex` option which this Makefile will look for

Useful commands:
* `make` - Regular PDF creation
* `make clean` - Remove all outputs (PDFs, etc)
* `make noclean` - Create PDF and keep all intermediate files
* `make check` - Check for special characters, repeated words, and a few other things
* `make arxiv` - Create a folder and zip suitable for uplaoding to `arXiv.org` (experimental)
