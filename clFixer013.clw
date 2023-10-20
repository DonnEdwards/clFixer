

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('CLFIXER013.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Source
!!! Scan for Folders Only
!!! </summary>
DirectoriesOnly      PROCEDURE  (STRING strDir)            ! Declare Procedure
udpt            UltimateDebugProcedureTracker
                            !FILE:queue                  QUEUE,PRE(File),TYPE
                            !name                            STRING(FILE:MAXFILENAME)  !FILE:MAXFILENAME is an EQUATE
                            !shortname                       STRING(13)
                            !date                            LONG
                            !time                            LONG
                            !size                            LONG
                            !attrib                          BYTE   !A bitmap, the same as the attributes EQUATEs
                            !                            END
qAllFiles                   QUEUE(File:queue),PRE(FIL)    
                                !Inherit exact declaration of File:queue
                                !This is the structure used by DIRECTORY command
                            END
i                           LONG
lngRecs                     LONG
j                           LONG

  CODE
        udpt.Init(UD,'DirectoriesOnly','clFixer013.clw','clFixer.EXE','10/19/2023 @ 04:28PM')    
             
    !dbg('strDir=' & clip(strDir))
    glo:qRecords  = RECORDS(clFiles)
    if glo:qRecords = 0 then ! very first folder
        ! Add the first folder to clFiles
        CLF:name = CLIP(strDir)
        CLF:path = CLIP(strDir) 
        CLF:uname = UPPER(strDir)
        CLF:attrib = ff_:DIRECTORY
        CLF:scanned = TRUE 
        ADD(clFiles)
        !dbg('First Folder=' & CLIP(strDir) )
    end ! very first folder
    !
    !// Find all the folder names and add them to the clFiles queue
    !
    DIRECTORY(qAllFiles, CLIP(strDir) & '\*.*',ff_:DIRECTORY)   !Get all files and directories
    lngRecs = RECORDS(qAllFiles) 
    !
    LOOP i = 1 to lngRecs ! Loop i
        GET(qAllFiles,i)  ! qAllfiles is the queue with the names of all the folders
        !dbg(i & ' Attrib=' & FIL:attrib & ' name=' & CLIP(FIL:name))
        IF (FIL:Attrib = ff_:DIRECTORY) AND FIL:ShortName <> '..' AND FIL:ShortName <> '.'
            ! Add folder names to the clFiles queue
            CLF:name = FIL:name
            CLF:path = CLIP(strDir) & '\' & CLIP(FIL:name)
            CLF:uname = UPPER(FIL:name)
            CLF:attrib = ff_:DIRECTORY
            CLF:scanned = FALSE  
            ADD(clFiles)
            !dbg(i & ' ' & j & ' folder=' & CLF:path)
            !dbg(i & ' ' & j & ' name=' & CLF:name)
        ELSE
            !Ignore non-directory entries             
        END  
    END ! Loop i
    glo:qRecords  = RECORDS(clFiles)
    DISPLAY()   
    
    RETURN
           
  
