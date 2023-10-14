

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

  CODE
    
    !// Assume the file filter contains multiple extensions (*.inc;*.clw;*.txt etc)
    !   Extract each one and do a directory listing to find matching files
    !
    stf.SetValue(strMultiFilter & ';')
    LOOP
        !dbg('strMultiFilter=' & clip(stf.GetValue()))
        strFilter = stf.Before(';')     ! get the leftmost filter
        !i = INSTRING('*',strFilter) ! Where is the * ?
        !if i = 0 then ! No *
        !    strFilter = '*' & CLIP(strFilter)
        !end ! No *
        !dbg('strFilter=' & clip(strFilter))
        !dbg('strDir=' & clip(strDir)) 
        DirFilesOnly(strDir,strFilter)
        stf.SetAfter(';') ! Drop the leftmost filter, keep the others
    WHILE stf.Length() > 2 ! Keep going until you get ;; or less
    !dbg('strMultiFilter=' & clip(stf.GetValue()))
    RETURN
        
    
