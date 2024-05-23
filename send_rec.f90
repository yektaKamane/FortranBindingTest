program mpi_send_rec
    use iso_c_binding
    use mpi
    use mpi_interface
    implicit none

    integer(c_int) :: ierr
    integer(c_int) :: rank
    integer(c_int) :: size
    integer(c_int) :: c_mpi_comm_world
    integer(c_int) :: c_mpi_comm_self
    ! integer(c_int) :: c_mpi_datatype
    integer(c_int) :: send_request0
    integer(c_int) :: send_request1
    integer(c_int) :: send_request2
    integer(c_int) :: send_request3
    integer(c_int) :: recv_request0
    integer(c_int) :: recv_request1
    integer(c_int) :: recv_request2
    integer(c_int) :: recv_request3
    ! integer :: send_value, recv_value
    integer :: requests(8)
    integer :: statuses(MPI_STATUS_SIZE, 8)
    integer :: status(MPI_STATUS_SIZE)
    type(c_ptr) :: ptr_snd, ptr_rec

    REAL(KIND=8), DIMENSION(:), POINTER :: snd_buffer, rec_buffer
    INTEGER :: array_size
    INTEGER :: i

    ! Define the size of the array
    array_size = 10
    
    ! Allocate memory for the array
    ALLOCATE(snd_buffer(array_size))
    ALLOCATE(rec_buffer(array_size))
    
    ! Initialize the array elements
    DO i = 1, array_size
        snd_buffer(i) = 0 
        rec_buffer(i) = 0
    END DO

    ! Get the pointer to the top_snd_buffer array
    ! ptr_value = LOC(top_snd_buffer)

    ! Initialize MPI
    call MPI_Init(ierr)

    c_mpi_comm_world = MPI_COMM_WORLD
    c_mpi_comm_self = MPI_COMM_SELF

    call my_MPI_Init(c_mpi_comm_world, c_mpi_comm_self, ierr)

    ! Get the rank of the current process
    call my_MPI_Comm_rank(c_mpi_comm_world, rank, ierr)
    call my_MPI_Comm_size(c_mpi_comm_world, size, ierr)

    ! Synchronize all processes before proceeding
    ! call my_MPI_Barrier(c_mpi_comm_world, ierr)

    ptr_snd = c_loc(snd_buffer)
    ptr_rec = c_loc(rec_buffer)

    ! if (rank == 1) then
    !     call raise_sigint_c()
    ! endif

    ! first round

    if (rank == 0) then
        snd_buffer(1) = 46
        ! Asynchronous send from process 0 to process 1
        
        call my_MPI_ISEND(ptr_snd, 10, MPI_INTEGER, 1, 0, MPI_COMM_WORLD, send_request0, ierr)
        call my_MPI_ISEND(ptr_snd, 10, MPI_INTEGER, 1, 1, MPI_COMM_WORLD, send_request1, ierr)
        call my_MPI_IRECV(ptr_rec, 10, MPI_INTEGER, 1, 2, MPI_COMM_WORLD, recv_request2, ierr)
        call my_MPI_IRECV(ptr_rec, 10, MPI_INTEGER, 1, 3, MPI_COMM_WORLD, recv_request3, ierr)
        ! call my_MPI_Wait(send_request, status, ierr)
    elseif (rank == 1) then
        ! Initialize receive request for process 1
        call my_MPI_ISEND(ptr_snd, 10, MPI_INTEGER, 0, 2, MPI_COMM_WORLD, send_request2, ierr)
        call my_MPI_ISEND(ptr_snd, 10, MPI_INTEGER, 0, 3, MPI_COMM_WORLD, send_request3, ierr)
        call my_MPI_IRECV(ptr_rec, 10, MPI_INTEGER, 0, 0, MPI_COMM_WORLD, recv_request0, ierr)
        call my_MPI_IRECV(ptr_rec, 10, MPI_INTEGER, 0, 1, MPI_COMM_WORLD, recv_request1, ierr)
        ! call my_MPI_Wait(recv_request, status, ierr)
    endif

    requests(1) = send_request0
    requests(3) = send_request1
    requests(3) = send_request2
    requests(4) = send_request3
    requests(2) = recv_request0
    requests(4) = recv_request1
    requests(7) = recv_request2
    requests(8) = recv_request3
    ! Wait for the completion of all communication requests
    
    call my_MPI_Waitall(8, requests, statuses, ierr)
    ! call MPI_Waitall(8, requests, statuses, ierr)
    ! call MPI_Wait(send_request0, status, ierr)

    print *, 'I am process', rank, 'value', rec_buffer(1)


    ! if (rank == 1) then
    !     call raise_sigint_c()
    ! endif


    ! second round

    !     if (rank == 0) then
    !     snd_buffer(1) = 46
    !     ! Asynchronous send from process 0 to process 1
        
    !     call my_MPI_ISEND(ptr_snd, 10, MPI_INTEGER, 1, 0, MPI_COMM_WORLD, send_request0, ierr)
    !     call my_MPI_ISEND(ptr_snd, 10, MPI_INTEGER, 1, 1, MPI_COMM_WORLD, send_request1, ierr)
    !     call my_MPI_IRECV(ptr_rec, 10, MPI_INTEGER, 1, 2, MPI_COMM_WORLD, recv_request2, ierr)
    !     call my_MPI_IRECV(ptr_rec, 10, MPI_INTEGER, 1, 3, MPI_COMM_WORLD, recv_request3, ierr)
    !     ! call my_MPI_Wait(send_request, status, ierr)
    ! elseif (rank == 1) then
    !     ! Initialize receive request for process 1
    !     call my_MPI_ISEND(ptr_snd, 10, MPI_INTEGER, 0, 2, MPI_COMM_WORLD, send_request2, ierr)
    !     call my_MPI_ISEND(ptr_snd, 10, MPI_INTEGER, 0, 3, MPI_COMM_WORLD, send_request3, ierr)
    !     call my_MPI_IRECV(ptr_rec, 10, MPI_INTEGER, 0, 0, MPI_COMM_WORLD, recv_request0, ierr)
    !     call my_MPI_IRECV(ptr_rec, 10, MPI_INTEGER, 0, 1, MPI_COMM_WORLD, recv_request1, ierr)
    !     ! call my_MPI_Wait(recv_request, status, ierr)
    ! endif

    ! requests(1) = send_request0
    ! requests(3) = send_request1
    ! requests(3) = send_request2
    ! requests(4) = send_request3
    ! requests(2) = recv_request0
    ! requests(4) = recv_request1
    ! requests(7) = recv_request2
    ! requests(8) = recv_request3
    ! ! Wait for the completion of all communication requests
    ! ! call my_MPI_Waitall(8, requests, statuses, ierr)
    ! ! call MPI_Waitall(8, requests, statuses, ierr)
    ! ! call MPI_Wait(recv_request, status, ierr)
    
    
    ! print *, 'I am process', rank, 'value', rec_buffer(1)


    ! Synchronize all processes before proceeding
    call my_MPI_Barrier(c_mpi_comm_world, ierr)

    ! Finalize MPI
    call MPI_Finalize(ierr)
    DEALLOCATE(snd_buffer)
    DEALLOCATE(rec_buffer)

end program mpi_send_rec
