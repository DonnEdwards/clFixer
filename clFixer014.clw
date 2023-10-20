

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('CLFIXER014.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Source
!!! Find files based on multipe extension mask
!!! </summary>
DirFilesMask         PROCEDURE  (STRING strDir,STRING strMultiFilter) ! Declare Procedure
strFilter                   STRING(255)
stf                         StringTheory
i                           LONG
udpt            UltimateDebugProcedureTracker

  CODE
        udpt.Init(UD,'DirFilesMask','clFixer014.clw','clFixer.EXE','10/19/2023 @ 03:26PM')    
             
    
    !// Assume the file filter contains multiple extensions (*.inc;*.clw;*.txt etc)
    !   Extract each one and do a directory listing to find matching files
    !   Thanks to Geoff Robinson for his code suggestions
    !
    stf.SetValue(strMultiFilter)
    stf.Split(';',,,,st:clip,st:left)  ! split into multiple clipped lines
    stf.RemoveLines() ! Remove blank lines
    LOOP i = 1 to stf.Records()
        DirFilesOnly(strDir,stf.GetLine(i))  ! Try each mask in turn
    END
    RETURN        
    
           
  
