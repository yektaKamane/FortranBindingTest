# MPI Compiler
MPIFC = mpif90

# Compiler flags
FFLAGS = -Wall -Wextra

# Source files
SRC = hello_world.f90

# Executable name
TARGET = hello_world

# Include path
INCLUDE_PATH = /usr/local/include/legio

# Libraries
LIBS = legio

# MPI library
MPI_LIB = mpi

# Default target
all: $(TARGET)

# Rule to build the executable
$(TARGET): $(SRC)
	$(MPIFC) $(FFLAGS) -o $@ $^ -L. -lmpi_wrapper -L$(LIB_PATH) -I$(INCLUDE_PATH) -l$(LIBS) -l$(MPI_LIB) -lstdc++

# Clean rule
clean:
	rm -f $(TARGET)
