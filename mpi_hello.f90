program mpi_hello
    use iso_c_binding
    use mpi
    use mpi_interface
    implicit none

    integer(c_int) :: ierr
    integer(c_int) :: rank
    integer(c_int) :: c_mpi_comm_world
    integer(c_int) :: c_mpi_comm_self
    integer(c_int) :: c_mpi_datatype
    integer(c_int) :: dest_rank
    integer(c_int) :: tag
    integer(c_int) :: value
    integer(c_int) :: request

    ! Initialize MPI
    call MPI_Init(ierr)

    c_mpi_comm_world = MPI_COMM_WORLD
    c_mpi_comm_self = MPI_COMM_SELF

    call my_MPI_Init(c_mpi_comm_world, c_mpi_comm_self, ierr)

    ! Get the rank of the current process
    call my_MPI_Comm_rank(c_mpi_comm_world, rank, ierr)

    ! Synchronize all processes before proceeding
    call my_MPI_Barrier(c_mpi_comm_world, ierr)

    if (rank == 1) then
        ! Process 1 sends a value to process 0 using MPI_ISEND
        dest_rank = 0
        tag = 123
        value = 12
        c_mpi_datatype = MPI_INTEGER
        call my_MPI_Isend(value, 1, c_mpi_datatype, dest_rank, tag, c_mpi_comm_world, request, ierr)
    else
        print *, 'I am process', rank
    end if

    ! Synchronize all processes before proceeding
    call my_MPI_Barrier(c_mpi_comm_world, ierr)

    ! Finalize MPI
    call MPI_Finalize(ierr)

end program mpi_hello
