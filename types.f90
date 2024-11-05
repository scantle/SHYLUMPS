module types
  implicit none
!-------------------------------------------------------------------------------------------------!
  
  type container
  
    real :: storage
    
  end type container

!-------------------------------------------------------------------------------------------------!
  contains
!-------------------------------------------------------------------------------------------------!
  
subroutine linear_temp_process(input, temp, above_temp, below_temp, above_out, below_out)
  implicit none
! ----------------------------------------------------------------------
! Subroutine Name: linear_temp_process
! Purpose: Generalized function to partition an input value based on 
!          temperature thresholds, allowing for a linear transition 
!          between two states (e.g., rain/snow partitioning, snowmelt).
!
! Arguments:
!   input      - (in) The input value to be partitioned (e.g., total precipitation, snowpack).
!   temp       - (in) The temperature at which the partitioning is evaluated.
!   above_temp - (in) The temperature threshold above which the output is entirely in 'above_out'.
!   below_temp - (in) The temperature threshold below which the output is entirely in 'below_out'.
!   above_out  - (inout) The portion of 'input' above the transition range (e.g., rain, meltwater).
!   below_out  - (inout) The portion of 'input' below the transition range (e.g., snow, retained snowpack).
!
! Description:
!   The subroutine calculates a linear fraction based on the given temperature 
!   and partitions the 'input' value between 'above_out' and 'below_out'.
!   If 'temp' is greater than or equal to 'above_temp', the entire 'input' 
!   is assigned to 'above_out'. If 'temp' is less than or equal to 'below_temp',
!   the entire 'input' is assigned to 'below_out'. For temperatures between 
!   'above_temp' and 'below_temp', a linear fraction determines the split.
!
! Example Use Case:
!   - Partitioning precipitation into rain and snow based on temperature.
!   - Determining the portion of snowpack that melts as temperature rises.
! ----------------------------------------------------------------------
  real, intent(in)    :: input, temp, above_temp, below_temp
  real, intent(inout) :: above_out, below_out
  real                :: f_below
  
    ! Calculate fraction
    if (temp >= above_temp) then
        f_below = 0.0
    else if (temp <= below_temp) then
        f_below = 1.0
    else
        f_below = (above_temp - temp) / (above_temp - below_temp)
    end if

    ! Partition 
    below_out = input * f_below
    above_out = input * (1 - f_below)

end subroutine linear_temp_process

!-------------------------------------------------------------------------------------------------!

function linear_process(input, coefficient) result(output)
  implicit none
! ----------------------------------------------------------------------
! Function Name: linear_process
! Purpose: Scales an input value using a linear coefficient to determine
!          how much of the input remains as output. Useful for simple
!          partitioning in hydrologic models (e.g., quickflow).
!
! Arguments:
!   input       - (in) The input value to be scaled (e.g., total runoff).
!   coefficient - (in) The linear coefficient (0 to 1) used to scale the input.
!
! Returns:
!   output      - The scaled output value after applying the coefficient.
!
! Description:
!   The function calculates the output by multiplying the input by the 
!   given coefficient. This represents the proportion of input that stays 
!   or is processed in a particular way (e.g., how much runoff goes to 
!   quickflow versus infiltration).
! ----------------------------------------------------------------------
  real, intent(in)   :: input, coefficient
  real               :: output
  
  output = input * coefficient
  
  return
end function linear_process

!-------------------------------------------------------------------------------------------------!

subroutine move_water(amount, from_stor, to_stor)
  implicit none
  
  real, intent(in)                 :: amount
  type(container), intent(inout)   :: from_stor, to_stor
  
  from_stor%storage = from_stor%storage - amount
  to_stor%storage   = to_stor%storage + amount

end subroutine move_water

!-------------------------------------------------------------------------------------------------!

end module types