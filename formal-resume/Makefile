all: clean en zh

en: resume_english.tex
	latexmk -xelatex resume_english.tex

zh: resume_chinese.tex
	latexmk -xelatex resume_chinese.tex

ifeq ($(OS),Windows_NT)
  # on Windows
  RM = cmd //C del
else
  # on Unix/Linux
  RM = rm -f
endif

clean:
	$(RM) *.log *.aux *.bbl *.blg *.synctex.gz *.out *.toc *.lof *.idx *.ilg *.ind *.pdf *.cut *.fdb_latexmk
