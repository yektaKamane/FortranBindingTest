program mpi_reduce_test
    use iso_c_binding
    use mpi
    use mpi_interface
    implicit none

    integer(c_int) :: ierr
    integer(c_int) :: rank
    integer(c_int) :: size
    integer(c_int) :: c_mpi_comm_world
    integer(c_int) :: c_mpi_comm_self

    real(kind=8), target :: send_value, sum
    type(C_PTR) :: ptr_val, ptr_sum

    ! Initialize MPI
    call MPI_Init(ierr)

    c_mpi_comm_world = MPI_COMM_WORLD
    c_mpi_comm_self = MPI_COMM_SELF

    call my_MPI_Init(c_mpi_comm_world, c_mpi_comm_self, ierr)

    ! Get the rank of the current process
    call my_MPI_Comm_rank(c_mpi_comm_world, rank, ierr)
    call my_MPI_Comm_size(c_mpi_comm_world, size, ierr)

    send_value = rank + 1
    ptr_val = c_loc(send_value)
    ptr_sum = c_loc(sum)

    ! Synchronize all processes before proceeding
    call my_MPI_Barrier(c_mpi_comm_world, ierr)

    ! if (rank == 1) then 
    !     call raise_sigint_c()
    ! endif

    ! Perform reduction: sum up all values across processes
    call my_MPI_Reduce(ptr_val, ptr_sum, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD, ierr)

    if (rank == 0) then
        print *, "Total sum across all processes: ", sum
    end if

    ! Finalize MPI
    call MPI_Finalize(ierr)

end program mpi_reduce_test
