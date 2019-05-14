CXXFLAGS := -Wall -Werror -Wno-unused-function -fPIC -I. -I./godot-cpp/include -I./godot-cpp/include/core -I./godot-cpp/include/gen -I./godot_headers
CPPFILES := godot_binding.cpp
OBJFILES := $(CPPFILES:.cpp=.o)
LIBFILE  := godot_binding.a

CC ?= g++
AR ?= ar
RM ?= rm

all: $(LIBFILE)

clean:
	$(RM) -f $(OBJFILES)
	$(RM) -f $(LIBFILE)

$(LIBFILE): $(OBJFILES)
	$(AR) rcs $@ $^

%.o: %.cpp
	$(CC) -std=c++11 -c -o $@ $< $(CXXFLAGS)

.PHONY: clean
