program SHYLUMPS
  use types, only: container
  implicit none
!-------------------------------------------------------------------------------------------------!
! Forcings
  real             :: precip
  real             :: snow
  real             :: temp
  real             :: et
!-------------------------------------------------------------------------------------------------!
! Storage
  type(container)  :: stor_snow
  type(container)  :: stor_soil
  type(container)  :: stor_gw
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
! Output
  real             :: streamflow
!-------------------------------------------------------------------------------------------------!
! Program Variables
  integer          :: i, j
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

  ! Open the input file and read it line by line
  open(unit=10, file=input_file, status='old', action='read')

  ! Read in values directly from the structured input file
  read(10, '(A)') name
  read(10, *) area
  area = area * 1.0e6  ! km^2 to m^2

  ! Skip the "# Coefficients" line
  read(10, '(A)')

  ! Read the coefficients
  read(10, *) rain_temp
  read(10, *) snow_temp
  read(10, *) melt_low_temp
  read(10, *) melt_high_temp
  read(10, *) precip_correction
  read(10, *) et_correction
  read(10, *) quickflow_coef
  read(10, *) recharge_coef
  read(10, *) baseflow_coef
  read(10, *) gw_loss_coef
  
  ! Skip the "# Input Files" line
  read(10, '(A)')
  
  ! Read the forcings file line
  read(10, '(A)') forcings_file

  ! Done reading input file
  close(10)
  
  ! Read forcings file
  
  
!-------------------------------------------------------------------------------------------------!
end program SHYLUMPS