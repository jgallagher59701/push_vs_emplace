

%.1: %.man1
	groff -t -e -mandoc -Tascii $< | col -bx > $@

%: %.cc
	g++ --std=c++11 $< -o $@

all: emplace_back emplace_back_2 emplace_back_3 push_back push_back_2 push_back_3

emplace_back: emplace_back.cc

emplace_back_2: emplace_back_2.cc

emplace_back_3: emplace_back_3.cc

push_back: push_back.cc

push_back_2: push_back_2.cc

push_back_3: push_back_3.cc