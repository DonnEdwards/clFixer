

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('CLFIXER015.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Source
!!! Scan entire directory structure including all subfolders
!!! </summary>
DirAllFileAndFolders PROCEDURE  (STRING strDir,STRING strMultiFilter) ! Declare Procedure
lngCurrent                  LONG
strFolder                   STRING(FILE:MaxFilePath)
i                           LONG
j                           LONG
udpt            UltimateDebugProcedureTracker

  CODE
        udpt.Init(UD,'DirAllFileAndFolders','clFixer015.clw','clFixer.EXE','10/19/2023 @ 03:52PM')    
             
    dbg('Folder=' & strDir)
    dbg('MultiMask=' & strMultiFilter)
    glo:FilesChanged = 0
    !// Set up the glo:stFiles object to contain important error messages and modified file names
    glo:stfiles.SetValue('<13,10>clFixer ' & CLIP(LEFT(format(TODAY(),'@D18'))) & ' ' & CLIP(LEFT(format(CLOCK(),'@T1'))) & '<13,10>') ! Note the date and time
    !
    !// This is the procedure that gets a list of all the files that match a particular filter
    !   These files (and folders) are stored in clFiles queue until done
    !   Then the folder names are removed since we have a path for each file anyway.
    !    
    !// First pass
    CLEAR(clFiles)
    GetExcluded()                                           ! Get the list of excluded files
    DirectoriesOnly(strDir)                                 ! Get the initial folder and its subfolders
    DirFilesMask(strDir,strMultiFilter)                     ! get the root files
    if RECORDS(clFiles) = 1 then ! did we find anything?
        MESSAGE(CLIP(strDir) & ' is empty or does''t exist')
        RETURN
    else !
        dbg(RECORDS(clFiles))
    end
    !// Multiple passes
    lngCurrent = 0      ! We have already scanned this folder
    LOOP
        lngCurrent += 1 ! Next queue entry
        GET(clFiles,lngCurrent)
            
        if CLF:attrib = ff_:DIRECTORY and CLF:scanned = FALSE THEN ! Folder
            CLF:scanned = TRUE
            strFolder = CLIP(CLF:path) ! Get the folder to be scanned
            PUT(clFiles)
            !dbg(lngCurrent & ' Attrib=' & CLF:attrib & ' name=' & CLIP(CLF:name) & ' scanned=' & CLF:scanned)
            !// Scan the folder for more folders and files
            DirectoriesOnly(strFolder)                      ! Add folders to the queue
            DirFilesMask(strFolder,strMultiFilter)          ! Add matching files to the queue
            glo:ProgressMessage = 'Inspecting ' & lngCurrent
        else ! Folder
            !dbg(lngCurrent & ' file=' & CLF:name)      ! Skip existing file names
        end ! Folder
        DISPLAY()
    WHILE lngCurrent < RECORDS(clFiles) ! Keep going until the queue has all the file and folder names
    dbg('----------------------------------------------------------------------------')
    j = 0   ! File counter
    glo:qFolders = 0
    lngCurrent = RECORDS(clFiles)
    glo:ProgressMessage = 'Sorting ' & lngCurrent
    DISPLAY()
    LOOP i = lngCurrent TO 1 BY -1
        GET(clFiles,i)
        if CLF:attrib = ff_:DIRECTORY or len(CLIP(CLF:name)) = 0 then ! Folder
            glo:qFolders += 1
            DELETE(clFiles)         ! Get rid of scanned folder names
            glo:qRecords = RECORDS(clFiles)
            DISPLAY()
            !dbg(i & ' Folder=' & CLIP(CLF:path) & ' scanned=' & CLF:scanned )
        else ! file
            j += 1  ! Count the file names
            !dbg(j & ' File=' & CLIP(CLF:path) & '\' & CLIP(CLF:name) ) 
            !glo:ProgressMessage = 'Found ' & j & ' File=' & CLIP(CLF:path) & '\' & CLIP(CLF:name)
        end ! Folder
    END ! loop i
    !dbg (j & ' files')
    glo:qRecords = RECORDS(clFiles)
    SORT(clFiles,CLF:uname)
    loop i = 1 to glo:qRecords ! loop i
        GET(clFiles,i)
        ProcessFile(i)
        !dbg(i & ' ' & CLIP(CLF:name) & '--' & CLF:excluded )
    end ! loop i  
    glo:ProgressMessage = 'Processed ' & glo:qRecords & ' files, ' & glo:FilesChanged & ' files updated, ' & glo:FileErrors & ' errors.'
    glo:stfiles.Append(clip(glo:ProgressMessage) & '<13,10>')
    DISPLAY()
    if glo:stfiles.SaveFile(clip(strDir) & '\clFixer.txt',True) ! Save the results
        RUN(clip(strDir) & '\clFixer.txt')  ! Display the results in notepad
    else ! Save
        MESSAGE('Problem saving ' & clip(strDir) & '\clFixer.txt')
    end ! Save
    RETURN
           
  
