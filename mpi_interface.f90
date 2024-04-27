module mpi_interface
    use iso_c_binding
    use mpi

    interface
        subroutine raise_sigint_c() bind(C, name="raise_sigint")
            use iso_c_binding
        end subroutine raise_sigint_c

        subroutine my_MPI_Init(Fcomm_w, Fcomm_s, ierr) bind(C, name="my_MPI_Init")
            use iso_c_binding
            integer(c_int), value :: Fcomm_w
            integer(c_int), value :: Fcomm_s
            integer(c_int) :: ierr
        end subroutine my_MPI_Init

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

        subroutine my_MPI_Waitall(count, array_of_requests, array_of_statuses, ierr) bind(C, name="my_MPI_Waitall")
            use, intrinsic :: iso_c_binding
            integer(c_int), value :: count
            integer(c_int), dimension(*), intent(in) :: array_of_requests
            integer(c_int), dimension(*), intent(in) :: array_of_statuses
            integer(c_int), intent(out) :: ierr
        end subroutine my_MPI_Waitall

        subroutine my_MPI_Isend(buf, count, datatype, dest, tag, comm, request, ierr) bind(C, name="my_MPI_Isend")
            use, intrinsic :: iso_c_binding
            type(c_ptr), value :: buf
            integer(c_int), intent(in) :: count
            integer(c_int), value :: datatype
            integer(c_int), intent(in) :: dest
            integer(c_int), intent(in) :: tag
            integer(c_int), value :: comm
            integer(c_int), intent(out) :: request
            integer(c_int), intent(out) :: ierr
        end subroutine my_MPI_Isend

        subroutine my_MPI_Irecv(buf, count, datatype, source, tag, comm, request, ierr) bind(C, name="my_MPI_Irecv")
            use, intrinsic :: iso_c_binding
            integer(c_int), value :: buf
            integer(c_int), intent(in) :: count
            integer(c_int), value :: datatype
            integer(c_int), intent(in) :: source
            integer(c_int), intent(in) :: tag
            integer(c_int), value :: comm
            integer(c_int), intent(out) :: request
            integer(c_int), intent(out) :: ierr
        end subroutine my_MPI_Irecv

    end interface
end module mpi_interface
