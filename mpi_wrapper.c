#include <signal.h>
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

void raise_sigint() {
    raise(SIGINT);
}

// MPI_INIT
void my_MPI_Init(MPI_Fint Fcomm_w, MPI_Fint Fcomm_s, int *ierr){
    MPI_Comm c_comm_w = MPI_Comm_f2c(Fcomm_w);
    MPI_Comm c_comm_s = MPI_Comm_f2c(Fcomm_s);
    MPI_Comm_set_errhandler(c_comm_w, MPI_ERRORS_RETURN);
    MPI_Comm_set_errhandler(c_comm_s, MPI_ERRORS_RETURN);
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

// MPI_WAITALL
void my_MPI_Waitall(int count, MPI_Fint *array_of_requests, MPI_Fint *array_of_statuses, int *ierr) {
    MPI_Request *cmpi_requests = (MPI_Request *)malloc(count * sizeof(MPI_Request));
    MPI_Status *cmpi_statuses = (MPI_Status *)malloc(count * sizeof(MPI_Status));
    MPI_Status c_status;
    
    // Convert Fortran MPI handles to C MPI handles
    for (int i = 0; i < count; ++i) {
        cmpi_requests[i] = MPI_Request_f2c(array_of_requests[i]);
        MPI_Status_f2c(&array_of_statuses[i], &c_status);
        cmpi_statuses[i] = c_status;
    }
    
    // Call MPI_Waitall
    MPI_Waitall(count, cmpi_requests, cmpi_statuses);
    
    // Free allocated memory
    free(cmpi_requests);
    free(cmpi_statuses);
}


// MPI_ISEND
void my_MPI_Isend(void *buf, int count, MPI_Fint datatype, int dest, int tag, MPI_Fint Fcomm, MPI_Fint request, int *ierr) {
    MPI_Comm c_comm = MPI_Comm_f2c(Fcomm);
    MPI_Datatype c_datatype = MPI_Type_f2c(datatype);
    MPI_Request c_request = MPI_Request_f2c(request);
    
    MPI_Isend(buf, count, c_datatype, dest, tag, c_comm, &c_request);
}

// MPI_IRECV
void my_MPI_Irecv(void *buf, int *count, MPI_Fint *datatype, int *source, int *tag, MPI_Fint *comm, MPI_Fint *request, int *ierr) {
    MPI_Comm c_comm = MPI_Comm_f2c(*comm);
    MPI_Datatype c_datatype = MPI_Type_f2c(*datatype);
    MPI_Request c_request = MPI_Request_f2c(*request);
    
    *ierr = MPI_Irecv(buf, *count, c_datatype, *source, *tag, c_comm, &c_request);
}





// MPI_STATUS_SIZE

// MPI_DOUBLE_PRECISION

// MPI_REDUCE

// MPI_SUM

// MPI_MIN

// MPI_MAX

// MPI_INTEGER

// MPI_ALLREDUCE

// MPI_ALLGATHER

