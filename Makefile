#### Header Paths ####
INCLUDES=./includes

#### Header File List that can be used with the Syntastic Syntax Checker vim plugin ####
S_HEADERS=.syntastic_c_headers

#### Source and Build Paths ####
SRC_DIR=src
OBJ_DIR=obj
SRC=$(wildcard $(SRC_DIR)/*.cpp) $(wildcard $(SRC_DIR)/cards/*.cpp)
OBJ=$(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(SRC))

#### Compile Values ####
PREFIX=
CC=$(PREFIX)g++
WARNINGS=-Wall
DEFINES=
CC_DEBUG_FLAGS= -g
CC_FLAGS=$(CC_DEBUG_FLAGS) $(WARNINGS) $(DEFINES) -I$(INCLUDES)
SHARED_LIBS=-lc -ldl -lpthread

#### Target Value Settings ####
TARGET=main
TARGET_INPUT=

#### Debugger Settings ####
DB=$(PREFIX)gdb
DBTEST=#gdbinit
DBFLAGS=#--batch --command=$(DBTEST)

#### Valgrind Settings ####
VG=valgrind
VGTOOL=#--tool=exp-sgcheck
VGFLAGS=-v --leak-check=full --track-origins=yes

#### Library Testing values ####
## Test Dirs ##
TEST_DIR=tests
TEST_OBJ_DIR=$(TEST_DIR)/$(OBJ_DIR)

## Test Target Settings ##
TEST_TARGET=test
TEST_TARGET_DEPS=$(TEST_OBJ_DIR)/$(TEST).o
TEST_TARGET_INPUT= 


##################################################################################

all: build

build: $(TARGET)

printsrc:
	@echo $(SRC)

printobj:
	@echo $(OBJ)

debug:
	$(DB) $(DBFLAGS)

vg:
	$(VG) $(VGFLAGS) ./$(TARGET) $(EXAMPLE_INPUT)

run:
	sudo ./$(TARGET) $(EXAMPLE_INPUT)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(OBJ_DIR) $(OBJ_DIR)/cards
	$(CC) -c $(C_FLAGS) -o $@ $<

$(TARGET): $(OBJ)
	$(CC) -o $@ $(OBJ) $(LIBS)


#### Tests  OPTIONS ####

tests: build_tests run_test

run_test: $(TEST)
	@echo Test Run
	@echo --------------
	./$<
	@echo

build_tests: test_build

$(TEST_TARGET): $(TEST_TARGET_DEPS)
	$(CC) -o $@ $^ $(LIBS)

$(TEST_OBJ)/%.o: $(TEST_DIR)/%.cpp
	@mkdir -p $(TEST_OBJ_DIR)
	$(CC) -c $(CC_FLAGS) -o $@ $<


#### Cleanup Options ####

clean_file:
	rm -f $(TARGET)

clean_objs:
	rm -rf $(OBJ_DIR)

clean_tests:
	rm -rf $(TEST_OBJ_DIR)
	rm -f $(TEST_TARGET)

clean: clean_objs clean_file clean_tests

#### Project Directory Tools ####
setup_proj: mk_dirs git_init s_header_gen

mk_dirs:
	@mkdir -p $(SRC_DIR)
	@mkdir -p $(TEST_DIR)
	@mkdir -p $(INCLUDES)

git_init:
	@if test ! -d .git; then git init || (echo "Install git to initialize repository" && exit 1) ; else echo "git directory already exists"; fi

s_header_gen:
	@echo "-I$(INCLUDES)" > $(S_HEADERS)
