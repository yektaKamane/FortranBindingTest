module mpi_interface
    use iso_c_binding
    use mpi

    interface
        subroutine raise_sigint_c() bind(C, name="raise_sigint")
            use iso_c_binding
        end subroutine raise_sigint_c

        subroutine my_MPI_Comm_rank(Fcomm, rank, ierr) bind(C, name="my_MPI_Comm_rank")
            use iso_c_binding
            integer(c_int), value :: Fcomm
            integer(c_int), intent(out) :: rank
            integer(c_int), intent(out) :: ierr
        end subroutine my_MPI_Comm_rank

        subroutine my_MPI_Barrier(Fcomm, ierr) bind(C, name="my_MPI_Barrier")
            use iso_c_binding
            integer(c_int), value :: Fcomm
            integer(c_int), intent(out) :: ierr
        end subroutine my_MPI_Barrier

        subroutine my_MPI_Abort(Fcomm, errorcode, ierr) bind(C, name="my_MPI_Abort")
            use, intrinsic :: iso_c_binding
            integer(c_int), value :: Fcomm
            integer(c_int), value :: errorcode
            integer(c_int), intent(out) :: ierr
        end subroutine my_MPI_Abort
    end interface
end module mpi_interface
