COMPILERNAME=while
STAGE=compiler
CXX?=clang++
EX?=ex/default
SRCFOLDER=$(STAGE)-$(notdir $(patsubst %/,%,$(EX)))
BISONC_VERSION := $(shell bisonc++ --version | cut -f2 -d" " | cut -f1,2 -d"." | tr -d 'V' | tr -d '.')

all:
	@rm -f compiler
	@rm -f tests
	@rm -f $(COMPILERNAME)

	@mkdir -p $(SRCFOLDER)
	@ln -sf $(SRCFOLDER) compiler
	@ln -sf $(EX)/tests tests
	@cp src/*.* $(SRCFOLDER)/
	@cp $(EX)/*.* $(SRCFOLDER)/

	@if [ -f $(SRCFOLDER)/while.l.pre ]; then sed -i '/\/\/ insert while[.]l[.]pre here/r $(SRCFOLDER)/while.l.pre' $(SRCFOLDER)/while.l; fi
	@if [ -f $(SRCFOLDER)/while.y.pre ]; then sed -i '/\/\/ insert while[.]y[.]pre here/r $(SRCFOLDER)/while.y.pre' $(SRCFOLDER)/while.y; fi
	@if [ -f $(SRCFOLDER)/while.y.post ]; then sed -i '/\/\/ insert while[.]y[.]post here/r $(SRCFOLDER)/while.y.post' $(SRCFOLDER)/while.y; fi
	@sed -i '/.*insert.*here/d' $(SRCFOLDER)/while.l
	@sed -i '/.*insert.*here/d' $(SRCFOLDER)/while.y

	flex -o $(SRCFOLDER)/lex.yy.cc $(SRCFOLDER)/$(COMPILERNAME).l
	bisonc++ $(SRCFOLDER)/$(COMPILERNAME).y --target-directory=$(SRCFOLDER)
	${CXX} -DBISONCPP_VSN=$(BISONC_VERSION) -o$(SRCFOLDER)/$(COMPILERNAME) $(SRCFOLDER)/$(COMPILERNAME).cc $(SRCFOLDER)/parse.cc $(SRCFOLDER)/lex.yy.cc $(SRCFOLDER)/semantics.cc

	@ln -sf compiler/$(COMPILERNAME) $(COMPILERNAME)

clean:
	@rm -rf $(SRCFOLDER) $(COMPILERNAME) compiler* tests
