program mpi_allgather_test
    use iso_c_binding
    use mpi
    use mpi_interface
    implicit none

    integer(c_int) :: ierr
    integer(c_int) :: rank
    integer(c_int) :: size
    integer(c_int) :: c_mpi_comm_world
    integer(c_int) :: c_mpi_comm_self
    type(c_ptr) :: ptr_snd, ptr_rec

    REAL(KIND=8), DIMENSION(:), POINTER :: snd_buffer, rec_buffer

    INTEGER :: array_size
    INTEGER :: i

    ! Define the size of the array
    array_size = 1

    ! Initialize MPI
    call MPI_Init(ierr)

    c_mpi_comm_world = MPI_COMM_WORLD
    c_mpi_comm_self = MPI_COMM_SELF

    call my_MPI_Init(c_mpi_comm_world, c_mpi_comm_self, ierr)

    ! Get the rank of the current process
    call my_MPI_Comm_rank(c_mpi_comm_world, rank, ierr)
    call my_MPI_Comm_size(c_mpi_comm_world, size, ierr)

    ! Allocate memory for the array
    ALLOCATE(snd_buffer(array_size))
    ALLOCATE(rec_buffer(array_size * size))
    
    ! Initialize the array elements
    DO i = 1, array_size
        snd_buffer(i) = rank ! Initializing with some values (e.g., 1, 2, 3, ...)
    END DO

    ptr_snd = c_loc(snd_buffer)
    ptr_rec = c_loc(rec_buffer)

    call my_MPI_Allgather(ptr_snd, array_size, MPI_DOUBLE_PRECISION, ptr_rec, &
                        array_size, MPI_DOUBLE_PRECISION, c_mpi_comm_world, ierr)

    ! Synchronize all processes before proceeding
    call my_MPI_Barrier(c_mpi_comm_world, ierr)

    if (rank == 2) then
        print *, 'recv buffer:'
        do i = 1, array_size * size
            print *, rec_buffer(i)
        end do
    endif

    ! Finalize MPI
    call MPI_Finalize(ierr)
    DEALLOCATE(snd_buffer)
    DEALLOCATE(rec_buffer)

end program mpi_allgather_test
