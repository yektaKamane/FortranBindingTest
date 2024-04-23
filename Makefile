# MPI Compiler
MPIFC = mpif90

# Compiler flags
FFLAGS = -Wall -Wextra

# Source files
SRC = mpi_hello.f90 mpi_interface.f90

# Executable name
TARGET = hello_world

# Include path
INCLUDE_PATH = /usr/local/include/legio

# Library path
LIB_PATH = /usr/local/lib/

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
