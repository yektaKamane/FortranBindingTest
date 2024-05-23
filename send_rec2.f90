program mpi_send_rec
    use iso_c_binding
    use mpi
    use mpi_interface
    implicit none

    integer(c_int) :: ierr
    integer(c_int) :: rank
    integer(c_int) :: size
    integer(c_int) :: c_mpi_comm_world
    integer(c_int) :: c_mpi_comm_self
    ! integer :: send_value, recv_value
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
    


    ! Initialize MPI
    call MPI_Init(ierr)

    c_mpi_comm_world = MPI_COMM_WORLD
    c_mpi_comm_self = MPI_COMM_SELF

    call my_MPI_Init(c_mpi_comm_world, c_mpi_comm_self, ierr)

    ! Get the rank of the current process
    call my_MPI_Comm_rank(c_mpi_comm_world, rank, ierr)
    call my_MPI_Comm_size(c_mpi_comm_world, size, ierr)

    ! Initialize the array elements
    DO i = 1, array_size
        snd_buffer(i) = rank
        rec_buffer(i) = rank + 1
    END DO

    ptr_snd = c_loc(snd_buffer)
    ptr_rec = c_loc(rec_buffer)

    if (rank == 1) then
        call raise_sigint_c()
    endif

    ! first round

    if (rank == 1) then
        snd_buffer(1) = 46
        ! Asynchronous send from process 0 to process 1
        call my_MPI_Sendrecv(ptr_snd, 10, MPI_INTEGER, 1, 0, &
                            ptr_rec, 10, MPI_INTEGER, 1, 0, &
                            MPI_COMM_WORLD, status, ierr)

    elseif (rank == 0) then
        ! Initialize receive request for process 1
        call my_MPI_Sendrecv(ptr_snd, 10, MPI_INTEGER, 0, 0, &
                            ptr_rec, 10, MPI_INTEGER, 0, 0, &
                            MPI_COMM_WORLD, status, ierr)

    endif

    print *, 'I am process', rank, 'value', rec_buffer(1)



    ! Synchronize all processes before proceeding
    call my_MPI_Barrier(c_mpi_comm_world, ierr)

    ! Finalize MPI
    call MPI_Finalize(ierr)
    DEALLOCATE(snd_buffer)
    DEALLOCATE(rec_buffer)

end program mpi_send_rec
