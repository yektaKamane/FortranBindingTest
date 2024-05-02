program mpi_hello
    use iso_c_binding
    use mpi
    use mpi_interface
    implicit none

    integer(c_int) :: ierr
    integer(c_int) :: rank
    integer(c_int) :: size
    integer(c_int) :: c_mpi_comm_world
    integer(c_int) :: c_mpi_comm_self
    ! integer(c_int) :: c_mpi_datatype
    integer(c_int) :: send_request
    integer(c_int) :: recv_request
    ! integer :: send_value, recv_value
    integer :: requests(2)
    integer :: statuses(MPI_STATUS_SIZE, 2)
    integer :: status(MPI_STATUS_SIZE)
    type(c_ptr) :: ptr_snd, ptr_rec

    REAL(KIND=8), DIMENSION(:), POINTER :: snd_buffer, rec_buffer
    INTEGER :: array_size
    INTEGER :: i

    ! Define the size of the array
    array_size = 10
    
    ! Allocate memory for the array
    ALLOCATE(snd_buffer(array_size))
    ALLOCATE(rec_buffer(array_size))
    
    ! Initialize the array elements
    DO i = 1, array_size
        snd_buffer(i) = REAL(i, KIND=8) ! Initializing with some values (e.g., 1, 2, 3, ...)
        rec_buffer(i) = REAL(i, KIND=8)
    END DO

    ! Get the pointer to the top_snd_buffer array
    ! ptr_value = LOC(top_snd_buffer)

    ! Initialize MPI
    call MPI_Init(ierr)

    c_mpi_comm_world = MPI_COMM_WORLD
    c_mpi_comm_self = MPI_COMM_SELF

    call my_MPI_Init(c_mpi_comm_world, c_mpi_comm_self, ierr)

    ! Get the rank of the current process
    call my_MPI_Comm_rank(c_mpi_comm_world, rank, ierr)
    call my_MPI_Comm_size(c_mpi_comm_world, size, ierr)

    ! Synchronize all processes before proceeding
    ! call my_MPI_Barrier(c_mpi_comm_world, ierr)

    if (rank == 0) then
        snd_buffer(1) = 42
        ! Asynchronous send from process 0 to process 1
        ptr_snd = c_loc(snd_buffer)
        call my_MPI_ISEND(ptr_snd, 10, MPI_INTEGER, 1, 0, MPI_COMM_WORLD, send_request, ierr)
        ! call my_MPI_Wait(send_request, status, ierr)
    elseif (rank == 1) then
        ! Initialize receive request for process 1
        ptr_rec = c_loc(rec_buffer)
        call my_MPI_IRECV(ptr_rec, 10, MPI_INTEGER, 0, 0, MPI_COMM_WORLD, recv_request, ierr)
        ! call my_MPI_Wait(recv_request, status, ierr)
    endif

    requests(1) = send_request
    requests(2) = recv_request
    ! Wait for the completion of all communication requests
    call MPI_Waitall(2, requests, statuses, ierr)
    ! call MPI_Wait(recv_request, status, ierr)
    

    print *, 'I am process', rank, 'value', rec_buffer(1)

    ! Synchronize all processes before proceeding
    call my_MPI_Barrier(c_mpi_comm_world, ierr)

    ! Finalize MPI
    call MPI_Finalize(ierr)
    DEALLOCATE(snd_buffer)
    DEALLOCATE(rec_buffer)

end program mpi_hello
