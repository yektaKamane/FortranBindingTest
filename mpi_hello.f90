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
    integer(c_int) :: c_mpi_datatype
    integer(c_int) :: send_request
    integer(c_int) :: recv_request
    integer :: send_value, recv_value
    integer :: requests(2)
    integer :: statuses(MPI_STATUS_SIZE, 2)
    ! integer(c_int) :: ptr_value

    REAL(KIND=8), DIMENSION(:), ALLOCATABLE :: top_snd_buffer
    INTEGER :: array_size
    INTEGER :: i

    ! Define the size of the array
    array_size = 10
    
    ! Allocate memory for the array
    ALLOCATE(top_snd_buffer(array_size))
    
    ! Initialize the array elements
    DO i = 1, array_size
        top_snd_buffer(i) = REAL(i, KIND=8) ! Initializing with some values (e.g., 1, 2, 3, ...)
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
    call my_MPI_Barrier(c_mpi_comm_world, ierr)

    if (rank == 0) then
        send_value = 42
        ! Asynchronous send from process 0 to process 1
        call MPI_ISEND(send_value, 1, MPI_INTEGER, 1, 0, MPI_COMM_WORLD, send_request, ierr)
    elseif (rank == 1) then
        ! Initialize receive request for process 1
        call MPI_IRECV(recv_value, 1, MPI_INTEGER, 0, 0, MPI_COMM_WORLD, recv_request, ierr)
    endif

    requests(1) = send_request
    requests(2) = recv_request
    ! Wait for the completion of all communication requests
    call my_MPI_Waitall(2, requests, statuses, ierr)

    print *, 'I am process', rank, 'value', recv_value

    ! Synchronize all processes before proceeding
    call my_MPI_Barrier(c_mpi_comm_world, ierr)

    ! Finalize MPI
    call MPI_Finalize(ierr)
    DEALLOCATE(top_snd_buffer)

end program mpi_hello
