

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('CLFIXER010.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Source
!!! Display a debug message using StringTheory
!!! </summary>
dbg                  PROCEDURE  (string pstrDebugMessage)  ! Declare Procedure
std  Stringtheory   ! String Theory Debug variable
udpt            UltimateDebugProcedureTracker

  CODE
    if false then ! disable the u;timate debug message
        udpt.Init(UD,'dbg','clFixer010.clw','clFixer.EXE','10/10/2023 @ 08:00PM')    
    end 
             
    !// If you encounter an UltimateDebug message here, put an "if false then" statement in front of it
    !   and an "end" statement on the next line after it
           
  

    !// The purpose of this procedure is to display debug messages
    !   This means you can enable/disable the UltimateDebug messages
    !   without having to comment out a bunch of ud.debug lines in
    !   your code
    if glo:dbugoff = false then ! Display messages
        std.setvalue('--- ' & clip(pstrDebugMessage) )
        std.trace() 
    end ! Display message
      
