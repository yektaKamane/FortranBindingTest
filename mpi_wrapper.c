#include <signal.h>
#include <mpi.h>

void raise_sigint() {
    raise(SIGINT);
}

void my_MPI_Comm_rank(MPI_Fint Fcomm, int *rank, int *ierr){
    MPI_Comm c_comm = MPI_Comm_f2c(Fcomm);
    *ierr = MPI_Comm_rank(c_comm, rank);
}


void my_MPI_Barrier(MPI_Fint Fcomm, int *ierr){
    MPI_Comm c_comm = MPI_Comm_f2c(Fcomm);
    *ierr = MPI_Barrier(c_comm);
}