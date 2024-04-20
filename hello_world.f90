program mpi_hello
    use iso_c_binding
    implicit none

    ! Interface declarations for C MPI functions
    interface

        subroutine my_MPI_Init(ierr) bind(C, name="my_MPI_Init")
            import
            integer(c_int), intent(out) :: ierr
        end subroutine my_MPI_Init

        subroutine my_MPI_Comm_rank(comm, rank, ierr) bind(C, name="my_MPI_Comm_rank")
            import
            integer(c_int), value :: comm
            integer(c_int), intent(out) :: rank
            integer(c_int), intent(out) :: ierr
        end subroutine my_MPI_Comm_rank

        subroutine my_MPI_Barrier(comm, ierr) bind(C, name="my_MPI_Barrier")
            import
            integer(c_int), value :: comm
            integer(c_int), intent(out) :: ierr
        end subroutine my_MPI_Barrier

        subroutine my_MPI_Finalize(ierr) bind(C, name="my_MPI_Finalize")
            import
            integer(c_int), intent(out) :: ierr
        end subroutine my_MPI_Finalize

        subroutine raise_sigint_c() bind(C, name="raise_sigint")
        end subroutine raise_sigint_c

    end interface

    integer(c_int) :: ierr
    integer(c_int) :: rank
    integer(c_int), parameter :: MPI_COMM_WORLD = 0

    ! Initialize MPI
    call my_MPI_Init(ierr)

    ! Get the rank of the current process
    call my_MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)

    ! Synchronize all processes before proceeding
    call my_MPI_Barrier(MPI_COMM_WORLD, ierr)

    ! Print "Hello, World!" from all processes
    if (rank == 2) then
        ! Call raise_sigint_c() instead of MPI_Abort()
        call raise_sigint_c()
    else
        ! Print "Hello, World!" for other processes
        print *, 'Hello, World! I am process', rank
    end if

    ! Finalize MPI
    call my_MPI_Finalize(ierr)

end program mpi_hello
