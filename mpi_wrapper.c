#include <signal.h>
#include <mpi.h>
#include <stdio.h>

void raise_sigint() {
    raise(SIGINT);
}

// MPI_INIT
void my_MPI_Init(MPI_Fint Fcomm_w, MPI_Fint Fcomm_s, int *ierr){
    MPI_Comm c_comm_w = MPI_Comm_f2c(Fcomm_w);
    MPI_Comm c_comm_s = MPI_Comm_f2c(Fcomm_s);
    MPI_Comm_set_errhandler(c_comm_w, MPI_ERRORS_RETURN);
    MPI_Comm_set_errhandler(c_comm_s, MPI_ERRORS_RETURN);

    // Context::get().m_comm.add_comm(MPI_COMM_SELF);
    // Context::get().m_comm.add_comm(c_comm_w);
}

// MPI_COMM_RANK 
// checked
void my_MPI_Comm_rank(MPI_Fint Fcomm, int *rank, int *ierr){
    MPI_Comm c_comm = MPI_Comm_f2c(Fcomm);
    MPI_Comm_rank(c_comm, rank);
}

// MPI_BARRIER
// checked
void my_MPI_Barrier(MPI_Fint Fcomm, int *ierr){
    MPI_Comm c_comm = MPI_Comm_f2c(Fcomm);
    MPI_Barrier(c_comm);
}

// MPI_ABORT
void my_MPI_Abort(MPI_Fint Fcomm, int errorcode, int *ierr){
    MPI_Comm c_comm = MPI_Comm_f2c(Fcomm);
    MPI_Abort(c_comm, errorcode);
}

// MPI_COMM_SIZE
void my_MPI_Comm_size(MPI_Fint Fcomm, int *size, int *ierr){
    MPI_Comm c_comm = MPI_Comm_f2c(Fcomm);
    MPI_Comm_size(c_comm, size);
}

// void my_MPI_WAITALL()

// MPI_STATUS_SIZE

// MPI_WAITALL

// MPI_ISEND

// MPI_IRECV

// MPI_DOUBLE_PRECISION

// MPI_REDUCE

// MPI_SUM

// MPI_MIN

// MPI_MAX

// MPI_INTEGER

// MPI_ALLREDUCE

// MPI_ALLGATHER

