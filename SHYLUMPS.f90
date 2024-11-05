program SHYLUMPS
  use types
  implicit none
!-------------------------------------------------------------------------------------------------!
! Forcings
  character(10)    :: date
  real             :: precip
  real             :: temp
  real             :: et
!-------------------------------------------------------------------------------------------------!
  ! State Variables
  real             :: rain, snow, melt, quickflow, baseflow, gw_rech, gw_loss
  real             :: streamflow
!-------------------------------------------------------------------------------------------------!
! Storage
  real             :: init_snow, init_soil, init_gw
  type(container)  :: stor_snow
  type(container)  :: stor_soil
  type(container)  :: stor_gw
  type(container)  :: stor_gw_deep
  type(container)  :: stor_stream
!-------------------------------------------------------------------------------------------------!
! Parameters
  real             :: rain_temp, snow_temp
  real             :: melt_low_temp, melt_high_temp
  real             :: precip_correction
  real             :: et_correction    
  real             :: quickflow_coef   
  real             :: recharge_coef    
  real             :: baseflow_coef    
  real             :: gw_loss_coef     
!-------------------------------------------------------------------------------------------------!
! Watershed Properties
  real             :: area
  character(64)    :: name
!-------------------------------------------------------------------------------------------------!
! Program Variables
  integer          :: t
  integer          :: ndays
  character(100)   :: input_file, forcings_file, line
!-------------------------------------------------------------------------------------------------!
! MAIN PROGRAM
!-------------------------------------------------------------------------------------------------!
  
  ! Get input file name
  if (command_argument_count() > 0) then
    call get_command_argument(1,input_file)
  else
    write(*,*) 'Error - Must pass input filename'
    stop
  end if
  
  ! Write banner to screen
  write(*,'(a)') '****************************************'
  write(*,'(a)') '*        S H Y L U M P S   v1.0        *'
  write(*,'(a)') '****************************************'
  write(*,'(a)')
  write(*,'(a)') 'Simple Hydrological LUMPed-model System'
  write(*,'(a)') '    U.C. Davis Hydrologic Sciences'
  write(*,'(a)')
  
  ! Open the input file and read it line by line
  open(10, file=input_file, status='old', action='read')
  read(10, *) ! Skip header
  read(10, *) ! Skip blank

  ! Read in values directly from the structured input file
  read(10, *) line, name
  read(10, *) line, area
  area = area * 1.0e6  ! km^2 to m^2
  read(10, *) line, ndays

  read(10, *) ! Skip blank
  read(10, '(A)') ! Skip the "# Coefficients" line

  ! Read the coefficients
  read(10, *) line, rain_temp
  read(10, *) line, snow_temp
  read(10, *) line, melt_low_temp
  read(10, *) line, melt_high_temp
  read(10, *) line, precip_correction
  read(10, *) line, et_correction
  read(10, *) line, quickflow_coef
  read(10, *) line, recharge_coef
  read(10, *) line, baseflow_coef
  read(10, *) line, gw_loss_coef
  
  read(10, *) ! Skip blank
  read(10, '(A)') ! Skip the "# Initial Storage Valuess" line
  
  read(10, *) line, init_snow
  read(10, *) line, init_soil
  read(10, *) line, init_gw
  
  read(10, *) ! Skip blank
  read(10, '(A)') ! Skip the "# Input Files" line
  
  ! Read the forcings file line
  read(10, *) line, forcings_file

  ! Done reading input file
  close(10)
  
  ! Initialize storage
  stor_snow  %storage = init_snow
  stor_soil  %storage = init_soil
  stor_gw    %storage = init_gw
  stor_stream%storage = 0.0
  
  ! Write summary to screen
  write(*,'(2a)') ' Ready to run model: ', name
  
  ! Open forcings file
  open(10, file=forcings_file, status='old', action='read')
  read(10, '(A)')  ! Heading line

  ! Open outfile file
  open(20, file='shylumps.out', status='replace', action='write')
  write(20, '(a6,2x,a10,(2x,a16))')  'Step', 'Date', 'streamflow_m3s'
  
  write(*,*) 'Simulating...'
  
  ! Ready to start simulation
  do t=1, ndays
  
    ! Zero state variables
    rain       = 0.0
    snow       = 0.0
    melt       = 0.0
    quickflow  = 0.0
    gw_rech    = 0.0
    baseflow   = 0.0
    gw_loss    = 0.0
    streamflow = 0.0
    
    ! Read forcings for the day
    read(10, *) date, precip, temp, et
    
    ! Report progress
    write(*,'(2(a,i6),a)') 'Day ', t, '/', ndays,' - ' // date
    
    ! Corrections
    precip = precip * precip_correction
    et     = et     * et_correction
    
    ! Partition rain/snow
    call linear_temp_process(precip, temp, rain_temp, snow_temp, rain, snow)
    stor_snow%storage = stor_snow%storage + snow
    
    ! Snow melt
    call linear_temp_process(stor_snow%storage, temp, melt_high_temp, melt_low_temp, melt, stor_snow%storage)
    
    ! Rain/melt to Soil
    stor_soil%storage = stor_soil%storage + rain + melt
    
    ! ET (only if there is water to evaporate)
    stor_soil%storage = max(0.0, stor_soil%storage - et)
    
    ! Soil to Quickflow
    quickflow = linear_process(stor_soil%storage, quickflow_coef)
    call move_water(quickflow, stor_soil, stor_stream)
    
    ! Soil to GW
    gw_rech = linear_process(stor_soil%storage, recharge_coef)
    call move_water(gw_rech, stor_soil, stor_gw)
    
    ! GW to Baseflow
    baseflow = linear_process(stor_gw%storage, baseflow_coef)
    call move_water(baseflow, stor_gw, stor_stream)
    
    ! GW to Deep GW (loss)
    gw_loss = linear_process(stor_gw%storage, gw_loss_coef)
    call move_water(gw_loss, stor_gw, stor_gw_deep)
    
    ! Calculate streamflow (m3/s) from mm
    streamflow = (stor_stream%storage / 1000) * area * 86400
    
    ! Write out
    write(20, '(i6,2x,a10,2x,ES16.5)') t, date, streamflow
  
  end do  ! end main loop
  
  ! Close forcings & output files
  close(10)
  close(20)
  
  write(*,*) 'Done!'
  
!-------------------------------------------------------------------------------------------------!
end program SHYLUMPS