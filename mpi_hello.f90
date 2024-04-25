program mpi_hello
    use iso_c_binding
    use mpi
    use mpi_interface
    implicit none

    integer(c_int) :: ierr
    integer(c_int) :: rank
    integer(c_int) :: c_mpi_comm_world
    integer(c_int) :: c_mpi_comm_self

    ! Initialize MPI
    call MPI_Init(ierr)

    c_mpi_comm_world = MPI_COMM_WORLD
    c_mpi_comm_self = MPI_COMM_SELF

    call my_MPI_Init(c_mpi_comm_world, c_mpi_comm_self, ierr)

    ! Get the rank of the current process
    call my_MPI_Comm_rank(c_mpi_comm_world, rank, ierr)

    ! Synchronize all processes before proceeding
    call my_MPI_Barrier(c_mpi_comm_world, ierr)

    if (rank == 2) then
        call raise_sigint_c()
    else
        print *, 'I am process', rank
    end if

    ! Synchronize all processes before proceeding
    call my_MPI_Barrier(c_mpi_comm_world, ierr)

    ! Finalize MPI
    call MPI_Finalize(ierr)

end program mpi_hello
