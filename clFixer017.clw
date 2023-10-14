

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
    stb.LoadFile(strFilePathName) 
    sta.SetValue(stb.GetValue()) ! Copy from before to after
    Access:Action.Open()
    Access:Action.ClearKey(act:ActionStepPK)
    SET(act:ActionStepPK)
    LOOP UNTIL Access:Action.Next() <> Level:Benign ! Next
        if act:DisableYN then CYCLE.        ! Ignore this action
        if LEN(CLIP(act:FileName)) >= 5 then ! file
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
    IF stb.GetValue() <> sta.GetValue() THEN ! changes
        !// Preserve the original, save the new one
        if EXISTS(CLIP(strFilePathName) & '.bf') = false then
            RENAME(CLIP(strFilePathName),CLIP(strFilePathName) & '.bf') ! Rename the original
        end        
        !dbg('Saved file ' & CLIP(strFilePathName))
        sta.SaveFile(CLIP(strFilePathName)) ! Save the modified version
        glo:FilesChanged += 1
        dbg(strFilePathName)
        glo:stfiles.Append(CLIP(strFilePathName) & '<13,10>')
    END ! changes
    RETURN
    ! Replace
SearchAndReplace    ROUTINE

    !dbg(CLIP(act:stDescription))
    lngLineNo = act:LineNo
    if lngLineNo = 0 then ! Line No
        sta.Replace(CLIP(act:stBefore),CLIP(act:stAfter))
    else ! Line No
        !// Start at a particular line number
        stl.SetValue(sta.GetValue())  ! Copy the current version into stl
        stl.Split('<13,10>') ! Split into lines
        lngBefore = 0
        LOOP i = 1 to lngLineNo-1 ! loop i
            lngBefore = lngBefore + LEN(CLIP(stl.Getline(i))) + 2  ! total no of characters before act:LineNo
        END ! loop i
        lngAfter = lngBefore + LEN(CLIP(act:stBefore)) + 2 ! Total characters to the end of act:LineNo
        !// Do a single replace in the area specified
        sta.Replace(CLIP(act:stBefore),CLIP(act:stAfter),1,lngBefore,lngAfter,True) ! Case insensitive replace
        !
    end ! Line No    
