

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('CLFIXER016.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Source
!!! Create a queue with the list of excluded files
!!! </summary>
GetExcluded          PROCEDURE                             ! Declare Procedure
st                          StringTheory
!lngPointer                  LONG
i                           LONG
strLine                     STRING(FILE:MaxFileName)

  CODE
    !
    !// We want to take the global ExcludeFiles value and put it into a queue of Excluded file names
    !
    CLEAR(clExclude)                                        ! Empty the queue
    !lngPointer = 0
    st.SetValue(glo:ExcludeFiles)                           ! Get the data into a string theory object
    st.Split('<13,10>')                                     ! each file name on a separate line
    LOOP ! lines
        strLine = st.GetLine(1)
        if len(CLIP(strLine)) > 2 then ! strLine is not zero
            ADD(clExclude)
            CLE:name = strLine
            CLE:uname = UPPER(strLine)
            CLE:wild = FALSE                                ! Not a wild card by default
            i = STRPOS(strLine,'\*',Match:Simple+Match:NoCase)  ! Contains a *
            if i > 0 then 
                !dbg('Wild card: ' & strLine)
                CLE:wild = TRUE
            end
            i = STRPOS(strLine,'\?',Match:Simple+Match:NoCase) ! Contains a ?
            if i > 0 then 
                !dbg('Wild card: ' & strLine)
                CLE:wild = TRUE
            end    
            PUT(clExclude)                                  ! Saved to the queue
            !lngPointer += 1
            !dbg(lngPointer & ' line=' & CLIP(strLine) & ' wild: ' & CLE:wild)
        end ! strLine is not zero        
    UNTIL st.DeleteLine(1)  ! No more lines to process
