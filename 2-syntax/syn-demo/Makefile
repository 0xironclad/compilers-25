COMPILERNAME=while
SCANNERTEST=scantest

all: $(COMPILERNAME)
	-

compiler: $(COMPILERNAME)
	-

scanner: lex.yy.cc
	-

parser: parse.cc
	-

clean:
	rm -rf $(COMPILERNAME) $(SCANNERTEST) lex.yy.cc Parserbase.h parse.cc *~

lex.yy.cc: $(COMPILERNAME).l
	flex $(COMPILERNAME).l

parse.cc: $(COMPILERNAME).y Parser.ih
	bisonc++ $(COMPILERNAME).y

$(COMPILERNAME): $(COMPILERNAME).cc lex.yy.cc parse.cc
	VSN=$$(bisonc++ --version | cut -f2 -d" " | cut -f1,2 -d"." | tr -d 'V' | tr -d '.'); \
	g++ -DBISONCPP_VSN=$$VSN -o$(COMPILERNAME) $(COMPILERNAME).cc parse.cc lex.yy.cc

$(SCANNERTEST): $(SCANNERTEST).cc lex.yy.cc
	VSN=$$(bisonc++ --version | cut -f2 -d" " | cut -f1,2 -d"." | tr -d 'V' | tr -d '.'); \
	g++ -DBISONCPP_VSN=$VSN -o$(SCANNERTEST) $(SCANNERTEST).cc lex.yy.cc
