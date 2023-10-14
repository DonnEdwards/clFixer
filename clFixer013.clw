

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('CLFIXER013.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Source
!!! Scan for Folders Only
!!! </summary>
DirectoriesOnly      PROCEDURE  (STRING strDir)            ! Declare Procedure
                            !FILE:queue                  QUEUE,PRE(File),TYPE
                            !name                            STRING(FILE:MAXFILENAME)  !FILE:MAXFILENAME is an EQUATE
                            !shortname                       STRING(13)
                            !date                            LONG
                            !time                            LONG
                            !size                            LONG
                            !attrib                          BYTE   !A bitmap, the same as the attributes EQUATEs
                            !                            END
AllFiles                    QUEUE(File:queue),PRE(FIL)    
                                !Inherit exact declaration of File:queue
                                !This is the structure used by DIRECTORY command
                            END
i                           LONG
lngRecs                     LONG
j                           LONG

  CODE
    !dbg('strDir=' & clip(strDir))
    glo:qRecords  = RECORDS(clFiles)
    if glo:qRecords = 0 then ! very first folder
        ADD(clFiles)
        CLF:name = CLIP(strDir)
        CLF:path = CLIP(strDir) 
        CLF:uname = UPPER(strDir)
        CLF:attrib = ff_:DIRECTORY
        CLF:scanned = TRUE 
        PUT(clFiles)
        !dbg('First Folder=' & CLIP(strDir) )
    end ! very first folder
    !
    !// Find all the folder names and add them to the clFiles queue
    !
    DIRECTORY(AllFiles, CLIP(strDir) & '\*.*',ff_:DIRECTORY)   !Get all files and directories
    lngRecs = RECORDS(AllFiles) 
    !
    LOOP i = 1 to lngRecs ! TO 1 BY -1 ! Loop i
        GET(AllFiles,i)  
        !dbg(i & ' Attrib=' & FIL:attrib & ' name=' & CLIP(FIL:name))
        IF (FIL:Attrib = ff_:DIRECTORY) AND FIL:ShortName <> '..' AND FIL:ShortName <> '.'
            ADD(clFiles)        ! Add folder names to the clFiles queue
            CLF:name = FIL:name
            CLF:path = CLIP(strDir) & '\' & CLIP(FIL:name)
            CLF:uname = UPPER(FIL:name)
            CLF:attrib = ff_:DIRECTORY
            CLF:scanned = FALSE  
            PUT(clFiles)
            !dbg(i & ' ' & j & ' folder=' & CLF:path)
            !dbg(i & ' ' & j & ' name=' & CLF:name)
        ELSE
            !DELETE(AllFiles)                        !Ignore non-directory entries             
        END  
    END ! Loop i
    glo:qRecords  = RECORDS(clFiles)
    DISPLAY()   
    
    RETURN
