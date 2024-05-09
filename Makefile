# MPI Compiler
MPIFC = mpif90

# Compiler flags
FFLAGS = -Wall -Wextra

# Source files
SRCS = send_rec.f90 hello.f90 gather.f90 allgather.f90 reduce.f90
# Get the list of source file names without the extension
BASE_SRCS := $(basename $(SRCS))

# Executable names
TARGETS = $(BASE_SRCS)

# Interface file
INTERFACE_FILE = mpi_interface.f90

# Include path
INCLUDE_PATH = /usr/local/include/legio

# Library path
LIB_PATH = /usr/local/lib/

# Libraries
LIBS = legio

# MPI library
MPI_LIB = mpi

# Default target
all: $(TARGETS)

# Rule to build each executable
%: %.f90 $(INTERFACE_FILE)
	$(MPIFC) $(FFLAGS) -o $@ $< $(INTERFACE_FILE) -L. -lmpi_wrapper -L$(LIB_PATH) -I$(INCLUDE_PATH) -l$(LIBS) -l$(MPI_LIB) -lstdc++

# Clean rule
clean:
	rm -f $(TARGETS)
