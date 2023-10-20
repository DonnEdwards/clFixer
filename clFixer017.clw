

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('CLFIXER017.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Source
!!! Process each file in turn
!!! </summary>
ProcessFile          PROCEDURE  (LONG lngPointer)          ! Declare Procedure
strFilePathName             STRING(500)
stb                         StringTheory ! Contents of the file before
sta                         StringTheory ! File after
stl                         StringTheory ! Split into lines
st                          StringTheory ! Temporary
blnExclude                  BYTE ! This is one of the excluded files
lngLineNo                   LONG
i                           LONG
lngBefore                   LONG
lngAfter                    LONG

  CODE
    strFilePathName = CLIP(CLF:path) & '\' & CLIP(CLF:name)  
    glo:ProgressMessage = lngPointer & ' ' & CLIP(strFilePathName)
    DISPLAY()
    blnExclude = CLF:excluded ! Is this one of the excluded files?
    if not stb.LoadFile(strFilePathName) ! File load
        !// Report error in glo:stFiles - Thanks to Geoff Robinson for the help here
        glo:stfiles.Append('Error opening ' & CLIP(strFilePathName) & ' - ' & stb.lastError & '<13,10>')
        glo:FileErrors += 1
        RETURN
    end ! File load
    sta.SetValue(stb) ! Copy from before to after
    if Access:Action.TryOpen() = Level:Benign then ! Open
        Access:Action.ClearKey(act:ActionStepPK)
        SET(act:ActionStepPK)
        LOOP UNTIL Access:Action.Next() <> Level:Benign ! Next
            if act:DisableYN then CYCLE.        ! Ignore this action
            if LEN(CLIP(act:FileName)) >= 5 then ! file - must be a valid file name
                if MATCH(CLF:name,act:FileName,Match:Wild+Match:NoCase) then !
                    !// Files match, so proceed
                    do SearchAndReplace
                end !
            else ! file
                if act:ExcludeFilesYN and CLF:excluded then !
                    !// Do nothing
                    !dbg('Excluded file ' & strFilePathName)
                else !
                    do SearchAndReplace
                end !     
            end ! file            
        END ! Next
        Access:Action.Close()
    end ! open
    IF NOT stb.Equals(sta) THEN ! changes - Compare the before and after contents to see if they are equal
        !// Preserve the original, save the new one
        if EXISTS(CLIP(strFilePathName) & '.bf') = false then
            RENAME(CLIP(strFilePathName),CLIP(strFilePathName) & '.bf') ! Rename the original
            if ERRORCODE() 
                glo:stfiles.Append('Error renaming ' & CLIP(strFilePathName) & ' to *.bf - ' & ERROR() & '<13,10>')
                glo:FileErrors += 1                
            end 
        end        
        !dbg('Saved file ' & CLIP(strFilePathName))
        if sta.SaveFile(CLIP(strFilePathName)) then ! Save the modified version
            glo:FilesChanged += 1
            dbg(strFilePathName)
            glo:stfiles.Append(CLIP(strFilePathName) & '<13,10>')
        else ! problem saving
            glo:stfiles.Append('Error saving ' & CLIP(strFilePathName) & ' - ' & stb.lastError & '<13,10>')
            glo:FileErrors += 1
        end ! problem saving   
    END ! changes
    RETURN
    ! Replace
SearchAndReplace    ROUTINE

    !dbg(CLIP(act:stDescription))
    lngLineNo = act:LineNo
    if lngLineNo = 0 then ! Line No
        sta.Replace(CLIP(act:stBefore),CLIP(act:stAfter),,,,True) ! Case insensitive replace
    else ! Line No
        !// Start at a particular line number
        stl.SetValue(sta)  ! Copy the current version into stl
        stl.Split('<13,10>') ! Split into lines
        lngBefore = 0
        LOOP i = 1 to lngLineNo-1 ! loop i
            st.SetValue(stl.Getline(i))
            lngBefore = lngBefore + st.Length() + 2  ! total no of characters before act:LineNo
        END ! loop i
        lngAfter = lngBefore + LEN(CLIP(act:stBefore)) + 2 ! Total characters to the end of act:LineNo
        !// Do a single replace in the area specified
        sta.Replace(CLIP(act:stBefore),CLIP(act:stAfter),1,lngBefore,lngAfter,True) ! Case insensitive replace
        !
    end ! Line No    
