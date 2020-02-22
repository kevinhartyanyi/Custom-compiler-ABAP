analyse: analyzer.cc lex.yy.cc
	g++ analyzer.cc lex.yy.cc

lex.yy.cc: lex.l
	flex lex.l

clean:
	rm -f lex.yy.cc analyse
