

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('CLFIXER016.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Source
!!! Create a queue with the list of excluded files
!!! </summary>
GetExcluded          PROCEDURE                             ! Declare Procedure
st                          StringTheory ! List of files
stf                         StringTheory ! File name
i                           LONG    ! Line number

  CODE
    !
    !// We want to take the global ExcludeFiles value and put it into a queue of Excluded file names
    !   Big thanks to Geoff Robinson for helping me optimise (rewrite) this code
    !
    CLEAR(clExclude)                                        ! Empty the queue
    st.SetValue(glo:ExcludeFiles)                           ! Get the data into a string theory object
    st.Split('<13,10>',,,,st:clip,st:left)                  ! each file name on a separate line, CLIPPED
    st.RemoveLines('<9,10,13>')                             ! Get rid of empty lines
    LOOP i = 1 to st.Records()
        stf.setValue(CLIP(st.getLine(i))) ! File name or wild card
        if stf.Length() >= 5 ! Must be a valid name
            CLE:name = stf.GetValue()
            CLE:uname = CLIP(UPPER(CLE:name))
            if stf.containsChar('*') or stf.containsChar('?') ! Does the file name have any wild cards?
                CLE:wild = TRUE
            else
                CLE:wild = FALSE
            end
            !dbg(CLE:wild & ' Exclude=' & CLE:name)
            ADD(clExclude)                                  ! Saved to the queue
        end ! Valid Name
    END    
