

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module

                     MAP
                       INCLUDE('CLFIXER012.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Source
!!! Get DIR of just file names, not folders
!!! </summary>
DirFilesOnly         PROCEDURE  (STRING strDir,STRING strFilter) ! Declare Procedure

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
strMyFilter                 STRING(255)
j                           LONG
n                           LONG

  CODE
    strMyFilter = strFilter & ';'
    i = INSTRING(';',strMyFilter)
    strMyFilter = SUB(strMyFilter,1,i-1) ! Trim off the trailing ;
    !dbg('strFilter=' & clip(strMyFilter))
    !dbg('strDir=' & clip(strDir))
    
    !// Get a directory listing of all the normal files in this folder
    !   Put the file name and path in the clFiles queue
    
    DIRECTORY(AllFiles, CLIP(strDir) & '\' & strMyFilter,ff_:NORMAL)   !Get all visible files 
    lngRecs = RECORDS(AllFiles) 
    
    LOOP i = 1 to lngRecs !TO 1 BY -1 ! Loop i
        GET(AllFiles,i)    
        IF FIL:Attrib = ff_:DIRECTORY 
            !DELETE(AllFiles)                        !Ignore directory entries            
        ELSE
            glo:ProgressMessage =  CLIP(strDir) & '\' & CLIP(FIL:name)
            DISPLAY()
            ADD(clFiles)    ! Note the file name in the clFiles Queue
            CLF:name = FIL:name
            CLF:path = strDir
            CLF:uname = UPPER(FIL:name)
            CLF:attrib = FIL:attrib
            CLF:scanned = FALSE  ! Not a folder
            CLF:excluded  = FALSE  ! Not an excluded file
            loop n = 1 TO RECORDS(clExclude) ! loop n
                GET(clExclude,n)
                if CLE:wild = TRUE then ! wild
                    if MATCH(CLF:uname,CLE:uname) then
                        CLF:excluded  = TRUE
                    end
                else ! not wild
                    if CLIP(CLF:uname) = CLIP(CLE:uname) then ! matching file name
                        CLF:excluded  = TRUE
                    end ! matching file name    
                end ! not wild
            end ! loop n
            PUT(clFiles)
        END        
    END ! Loop i
    glo:qRecords  = RECORDS(clFiles)
    DISPLAY()
    RETURN  
