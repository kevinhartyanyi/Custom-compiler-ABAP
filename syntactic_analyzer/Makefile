COMPILERNAME=syntactic

all: $(COMPILERNAME)
	-

clean:
	rm -rf $(COMPILERNAME) lex.yy.cc Parserbase.h parse.cc *~

lex.yy.cc: lex.l
	flex lex.l

parse.cc: $(COMPILERNAME).y
	bisonc++ $(COMPILERNAME).y

$(COMPILERNAME): analyzer.cc lex.yy.cc parse.cc
	g++ -o$(COMPILERNAME) analyzer.cc parse.cc lex.yy.cc
