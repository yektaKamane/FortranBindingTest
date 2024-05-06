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

    call MPI_Init(ierr)

    c_mpi_comm_world = MPI_COMM_WORLD
    c_mpi_comm_self = MPI_COMM_SELF

    call my_MPI_Init(c_mpi_comm_world, c_mpi_comm_self, ierr)

    ! Get the rank of the current process
    call my_MPI_Comm_rank(c_mpi_comm_world, rank, ierr)
    call my_MPI_Comm_size(c_mpi_comm_world, size, ierr)

    ! Synchronize all processes before proceeding
    call my_MPI_Barrier(c_mpi_comm_world, ierr)

    ! Print "Hello, World!" from all processes
    if (rank == 2) then
        ! Call raise_sigint_c() instead of MPI_Abort()
        call raise_sigint_c()
    else
        ! Print "Hello, World!" for other processes
        print *, 'Hello, World! I am process', rank
    end if

    call my_MPI_Barrier(c_mpi_comm_world, ierr)
    
    ! Finalize MPI
    call MPI_Finalize(ierr)
end program mpi_hello