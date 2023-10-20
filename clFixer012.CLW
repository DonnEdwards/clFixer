

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('CLFIXER012.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Source
!!! Get DIR of just file names, not folders
!!! </summary>
DirFilesOnly         PROCEDURE  (STRING strDir,STRING strFilter) ! Declare Procedure
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
strMyFilter                 STRING(255)
j                           LONG
n                           LONG

  CODE
        udpt.Init(UD,'DirFilesOnly','clFixer012.clw','clFixer.EXE','10/19/2023 @ 04:59PM')    
             
    !strMyFilter = strFilter & ';'
    !i = INSTRING(';',strMyFilter)
    !strMyFilter = SUB(strMyFilter,1,i-1) ! Trim off the trailing ;
    !dbg('strFilter=' & clip(strMyFilter))
    !dbg('strDir=' & clip(strDir))
    strMyFilter = CLIP(strFilter)
    if LEN(CLIP(strMyFilter)) < 2 then ! not a valid filter
        RETURN 
    end ! not a valid filter
    
    !// Get a directory listing of all the normal files in this folder
    !   Put the file name and path in the clFiles queue
    
    DIRECTORY(qAllFiles, CLIP(strDir) & '\' & strMyFilter,ff_:NORMAL)   !Get all visible files 
    lngRecs = RECORDS(qAllFiles) 
    
    LOOP i = 1 to lngRecs ! Loop i
        GET(qAllFiles,i)    
        IF FIL:Attrib = ff_:DIRECTORY ! Attrib
            ! Don't process directory entries here           
        ELSE ! Attrib
            glo:ProgressMessage =  CLIP(strDir) & '\' & CLIP(FIL:name)
            DISPLAY()
            ! Note the file name in the clFiles Queue
            CLF:name = FIL:name
            CLF:path = strDir
            CLF:uname = UPPER(FIL:name)
            CLF:attrib = FIL:attrib
            CLF:scanned = FALSE  ! Not a folder
            CLF:excluded  = FALSE  ! Not an excluded file
            LOOP n = 1 TO RECORDS(clExclude) ! loop n
                GET(clExclude,n)
                if CLE:wild = TRUE then ! wild
                    if MATCH(CLF:uname,CLE:uname,Match:Wild) then ! Wild card match?
                        CLF:excluded  = TRUE
                    end ! Wild card match
                else ! not wild
                    if CLIP(CLF:uname) = CLIP(CLE:uname) then ! matching file name
                        CLF:excluded  = TRUE
                    end ! matching file name    
                end ! not wild
            END ! loop n
            ADD(clFiles) ! File name noted
        END        
    END ! Loop i
    glo:qRecords  = RECORDS(clFiles)
    DISPLAY()
    RETURN  
           
  
