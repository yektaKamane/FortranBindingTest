program mpi_hello
    use iso_c_binding
    use mpi
    implicit none

    ! Interface declarations for C MPI functions
    interface

        subroutine raise_sigint_c() bind(C, name="raise_sigint")
        end subroutine raise_sigint_c

        subroutine my_MPI_Comm_rank(Fcomm, rank, ierr) bind(C, name="my_MPI_Comm_rank")  
            use iso_c_binding      
            integer(c_int), value :: Fcomm
            integer(c_int), intent(out) :: rank
            integer(c_int), intent(out) :: ierr
        end subroutine my_MPI_Comm_rank

    end interface

    integer(c_int) :: ierr
    integer(c_int) :: rank
    integer(c_int) :: c_mpi_comm

    ! Initialize MPI
    call MPI_Init(ierr)

    c_mpi_comm = MPI_COMM_WORLD

    ! Get the rank of the current process
    call my_MPI_Comm_rank(c_mpi_comm, rank, ierr)

    ! ! Synchronize all processes before proceeding
    call MPI_Barrier(MPI_COMM_WORLD, ierr)

    ! Print "Hello, World!" from all processes
    if (rank == 2) then
        ! Call raise_sigint_c() instead of MPI_Abort()
        call raise_sigint_c()
    else
        ! Print "Hello, World!" for other processes
        print *, 'Hello, World! I am process', rank
    end if

    ! Finalize MPI
    call MPI_Finalize(ierr)

end program mpi_hello
