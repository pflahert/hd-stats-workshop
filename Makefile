# Makefile for High-Dimensional Data Analysis Workshop
#
# Directory layout:
#   lectures/    — essay-style lecture notes + slide decks
#   notebooks/   — Python Colab notebooks (not built by Quarto)
#   assessments/ — pre-homework, homework
#   syllabus/    — course design, decision guide
#   data/        — ALL dataset CSVs
#
# Usage:
#   make              # render everything (HTML website + all PDFs)
#   make html         # render the full HTML website
#   make preview      # live preview with auto-reload
#
#   make lectures     # render lecture notes as HTML
#   make slides       # render slide decks (Reveal.js HTML)
#   make docs         # render syllabus, assessments, decision guide as HTML
#
#   make pdf          # render all PDFs
#   make lectures-pdf # render lecture notes as PDF (for printing)
#   make slides-pdf   # render slide decks as Beamer PDF
#   make docs-pdf     # render syllabus/assessments as PDF
#
#   make data         # export ALL dataset CSVs (requires Bioconductor)
#
#   make clean        # remove all rendered output
#   make clean-pdf    # remove PDF output only

# ---------- file lists ----------

LECTURE_NAMES := lecture1 lecture2 lecture3 lecture4
SLIDE_NAMES   := lecture1-slides lecture2-slides lecture3-slides lecture4-slides

QMD_LECTURES := $(addprefix lectures/,$(addsuffix .qmd,$(LECTURE_NAMES)))
QMD_SLIDES   := $(addprefix lectures/,$(addsuffix .qmd,$(SLIDE_NAMES)))
QMD_DOCS     := index.qmd assessments/pre-homework.qmd assessments/homework.qmd \
                syllabus/decision-guide.qmd syllabus/course-design.qmd
QMD_ALL      := $(QMD_LECTURES) $(QMD_SLIDES) $(QMD_DOCS)

PDF_LECTURES := $(addprefix _pdf/,$(addsuffix .pdf,$(LECTURE_NAMES)))
PDF_SLIDES   := $(addprefix _pdf/,$(addsuffix .pdf,$(SLIDE_NAMES)))
PDF_DOCS     := _pdf/index.pdf _pdf/pre-homework.pdf _pdf/homework.pdf \
                _pdf/decision-guide.pdf _pdf/course-design.pdf

PDF_ALL      := $(PDF_LECTURES) $(PDF_SLIDES) $(PDF_DOCS)

# ---------- directories ----------

HTML_DIR := _output
PDF_DIR  := _pdf

# ---------- top-level targets ----------

.PHONY: all html preview pdf clean clean-pdf
.PHONY: lectures slides docs data
.PHONY: lectures-pdf slides-pdf docs-pdf

all: html pdf

# --- HTML targets ---

html: $(QMD_ALL) _quarto.yml
	quarto render

preview:
	quarto preview

lectures: $(QMD_LECTURES) _quarto.yml
	@for f in $(QMD_LECTURES); do quarto render $$f; done

slides: $(QMD_SLIDES) _quarto.yml
	@for f in $(QMD_SLIDES); do quarto render $$f; done

docs: $(QMD_DOCS) _quarto.yml
	@for f in $(QMD_DOCS); do quarto render $$f; done

# --- Data export ---

data: data/export_all.R
	Rscript data/export_all.R

# --- PDF targets ---

# Build all PDFs. We invoke each sub-target with a separate make call so that a
# failure in one (e.g. slides-pdf failing because images are missing — see
# lectures/images/IMAGES_TODO.md) does not block the others. The `-` prefix
# tells make to ignore non-zero exit codes.
pdf:
	-$(MAKE) lectures-pdf
	-$(MAKE) docs-pdf
	-$(MAKE) slides-pdf

lectures-pdf: $(PDF_LECTURES)

slides-pdf: $(PDF_SLIDES)

docs-pdf: $(PDF_DOCS)

# ---------- PDF rules ----------

# Helper: chained mv covering all locations Quarto might emit a PDF.
# Quarto puts the PDF in:
#   - the source's directory       (e.g. lectures/lecture1.pdf)
#   - _output/<source-dir>/        (when run inside a website project)
#   - _output/                     (sometimes for project-root sources)
#   - cwd                          (when run with -o and no project context)
# This macro tries each in order.
define mv_pdf_to_pdfdir
	@mv $(1)/$(notdir $@) $(PDF_DIR)/ 2>/dev/null \
		|| mv _output/$(1)/$(notdir $@) $(PDF_DIR)/ 2>/dev/null \
		|| mv _output/$(notdir $@) $(PDF_DIR)/ 2>/dev/null \
		|| mv $(notdir $@) $(PDF_DIR)/ 2>/dev/null \
		|| (echo "ERROR: produced PDF not found for $@"; exit 1)
endef

# Slide decks → Beamer PDF
$(PDF_DIR)/%-slides.pdf: lectures/%-slides.qmd | $(PDF_DIR)
	@echo "--- Rendering $< to Beamer PDF ---"
	quarto render $< --to beamer -o $(notdir $@)
	$(call mv_pdf_to_pdfdir,lectures)

# Lecture notes → PDF document
# Lectures 2/3/4 are dual-format (revealjs + pdf); lecture1 is html + pdf.
$(PDF_DIR)/lecture%.pdf: lectures/lecture%.qmd | $(PDF_DIR)
	@echo "--- Rendering $< to PDF ---"
	quarto render $< --to pdf -o $(notdir $@)
	$(call mv_pdf_to_pdfdir,lectures)

# Assessments → PDF
$(PDF_DIR)/pre-homework.pdf: assessments/pre-homework.qmd | $(PDF_DIR)
	@echo "--- Rendering $< to PDF ---"
	quarto render $< --to pdf -o $(notdir $@)
	$(call mv_pdf_to_pdfdir,assessments)

$(PDF_DIR)/homework.pdf: assessments/homework.qmd | $(PDF_DIR)
	@echo "--- Rendering $< to PDF ---"
	quarto render $< --to pdf -o $(notdir $@)
	$(call mv_pdf_to_pdfdir,assessments)

# Syllabus files → PDF
$(PDF_DIR)/decision-guide.pdf: syllabus/decision-guide.qmd | $(PDF_DIR)
	@echo "--- Rendering $< to PDF ---"
	quarto render $< --to pdf -o $(notdir $@)
	$(call mv_pdf_to_pdfdir,syllabus)

$(PDF_DIR)/course-design.pdf: syllabus/course-design.qmd | $(PDF_DIR)
	@echo "--- Rendering $< to PDF ---"
	quarto render $< --to pdf -o $(notdir $@)
	$(call mv_pdf_to_pdfdir,syllabus)

# Root docs → PDF
$(PDF_DIR)/index.pdf: index.qmd | $(PDF_DIR)
	@echo "--- Rendering $< to PDF ---"
	quarto render $< --to pdf -o $(notdir $@)
	$(call mv_pdf_to_pdfdir,.)

$(PDF_DIR):
	mkdir -p $(PDF_DIR)

# ---------- clean ----------

clean:
	rm -rf $(HTML_DIR) $(PDF_DIR)
	rm -rf .quarto

clean-pdf:
	rm -rf $(PDF_DIR)
