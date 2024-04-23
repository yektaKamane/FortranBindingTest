program mpi_hello
    use iso_c_binding
    use mpi
    use mpi_interface
    implicit none

    ! Interface declarations for C MPI functions
    ! interface

    !     subroutine raise_sigint_c() bind(C, name="raise_sigint")
    !     use iso_c_binding
    !     end subroutine raise_sigint_c

    !     subroutine my_MPI_Comm_rank(Fcomm, rank, ierr) bind(C, name="my_MPI_Comm_rank")  
    !         use iso_c_binding      
    !         integer(c_int), value :: Fcomm
    !         integer(c_int), intent(out) :: rank
    !         integer(c_int), intent(out) :: ierr
    !     end subroutine my_MPI_Comm_rank

    !     subroutine my_MPI_Barrier(Fcomm, ierr) bind(C, name="my_MPI_Barrier")
    !         use iso_c_binding
    !         integer(c_int), value :: Fcomm
    !         integer(c_int), intent(out) :: ierr
    !     end subroutine my_MPI_Barrier

    !     subroutine my_MPI_Abort(Fcomm, errorcode, ierr) bind(C, name="my_MPI_Abort")
    !         use, intrinsic :: iso_c_binding
    !         integer(c_int), value :: Fcomm
    !         integer(c_int), value :: errorcode
    !         integer(c_int), intent(out) :: ierr
    !     end subroutine my_MPI_Abort

    ! end interface

    integer(c_int) :: ierr
    integer(c_int) :: rank
    integer(c_int) :: c_mpi_comm

    ! Initialize MPI
    call MPI_Init(ierr)

    c_mpi_comm = MPI_COMM_WORLD

    ! Get the rank of the current process
    call my_MPI_Comm_rank(c_mpi_comm, rank, ierr)

    ! Synchronize all processes before proceeding
    call my_MPI_Barrier(c_mpi_comm, ierr)

    if (rank == 2) then
        ! call raise_sigint_c()
    else
        print *, 'I am process', rank
    end if

    ! Synchronize all processes before proceeding
    call my_MPI_Barrier(c_mpi_comm, ierr)

    ! Finalize MPI
    call MPI_Finalize(ierr)

end program mpi_hello
