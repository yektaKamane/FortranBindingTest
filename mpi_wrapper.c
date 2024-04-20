#include <signal.h>
#include <mpi.h>

void raise_sigint() {
    raise(SIGINT);
}

void my_MPI_Init(int *ierr) {
    *ierr = MPI_Init(NULL, NULL);
}

void my_MPI_Comm_rank(MPI_Comm comm, int *rank, int *ierr) {
    *ierr = MPI_Comm_rank(comm, rank);
}

void my_MPI_Barrier(MPI_Comm comm, int *ierr) {
    *ierr = MPI_Barrier(comm);
}

void my_MPI_Finalize(int *ierr) {
    *ierr = MPI_Finalize();
}
