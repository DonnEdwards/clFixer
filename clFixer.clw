   PROGRAM


StringTheory:TemplateVersion equate('3.63')
WinEvent:TemplateVersion      equate('5.36')

   INCLUDE('ABERROR.INC'),ONCE
   INCLUDE('ABFILE.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('EFOCUS.INC'),ONCE
   INCLUDE('ERRORS.CLW'),ONCE
   INCLUDE('KEYCODES.CLW'),ONCE
   INCLUDE('ABFUZZY.INC'),ONCE
   INCLUDE('WINEXT.INC'),ONCE
  include('StringTheory.Inc'),ONCE
  INCLUDE('UltimateDebug.INC'),ONCE
  INCLUDE('UltimateDebugProcedureTracker.INC'),ONCE
    Include('WinEvent.Inc'),Once

   MAP
     MODULE('CLFIXER_BC.CLW')
DctInit     PROCEDURE                                      ! Initializes the dictionary definition module
DctKill     PROCEDURE                                      ! Kills the dictionary definition module
     END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('CLFIXER001.CLW')
Main                   PROCEDURE   !Wizard Application for F:\dev\clFixer\clFixer.dct
     END
     MODULE('CLFIXER009.CLW')
SystemInfo             PROCEDURE   !System Diagnostics from CapeSoft WinEvents
     END
     MODULE('CLFIXER010.CLW')
dbg                    PROCEDURE(string pstrDebugMessage)   !Display a debug message using StringTheory
     END
     MODULE('CLFIXER012.CLW')
DirFilesOnly           PROCEDURE(STRING strDir, STRING strFilter)   !Get DIR of just file names, not folders
     END
     MODULE('CLFIXER013.CLW')
DirectoriesOnly        PROCEDURE(STRING strDir)   !Scan for Folders Only
     END
     MODULE('CLFIXER014.CLW')
DirFilesMask           PROCEDURE(STRING strDir, STRING strMultiFilter)   !Find files based on multipe extension mask
     END
     MODULE('CLFIXER015.CLW')
DirAllFileAndFolders   PROCEDURE(STRING strDir, STRING strMultiFilter)   !Scan entire directory structure including all subfolders
     END
     MODULE('CLFIXER016.CLW')
GetExcluded            PROCEDURE   !Create a queue with the list of excluded files
     END
     MODULE('CLFIXER017.CLW')
ProcessFile            PROCEDURE(LONG lngPointer)   !Process each file in turn
     END

DebugABCGlobalInformation_clFixer PROCEDURE()                                            ! DEBUG Prototype
DebugABCGlobalVariables_clFixer PROCEDURE()                                              ! DEBUG Prototype

       MyOKToEndSessionHandler(long pLogoff),long,pascal
       MyEndSessionHandler(long pLogoff),pascal
   END

  include('StringTheory.Inc'),ONCE
glo:qRecords         LONG(0)
glo:st               StringTheory
glo:AppVersion       STRING(30)
glo:MachineName      STRING(20)
glo:dbugoff          BYTE(0)
glo:AppDescription   STRING(50)
glo:RootPath         STRING(255)
glo:FileExtensions   STRING(250)
glo:ExcludeFiles     STRING(1000)
glo:ProgressMessage  STRING('Copyright (c) 2023 Black and White Inc {42}')
glo:FilesChanged     LONG(0)
glo:FileErrors       LONG(0)
glo:stfiles          StringTheory
glo:qFolders         LONG
GLO:oneInstance_Main_thread LONG(0)
GLO:oneInstance_UpdateSetting_thread LONG(0)
SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
Action               FILE,DRIVER('TOPSPEED'),NAME('Action.tps'),PRE(act),CREATE,BINDABLE,THREAD ! Replacement Action  
ActionStepPK             KEY(act:StepId),NOCASE,PRIMARY    ! Primary Key         
ActionReorder            KEY(-act:ReorderNo),DUP,NOCASE    ! Use this to renumber steps
stBefore                    MEMO(9000)                     ! String Before       
stAfter                     MEMO(9000)                     ! String After        
Record                   RECORD,PRE()
StepId                      LONG                           ! Step number         
stDescription               STRING(128)                    ! Description of this step
ExcludeFilesYN              BYTE                           !                     
FileName                    STRING(128)                    ! Single file name for changes. Leave blank if global change
LineNo                      LONG                           ! Start Line Number   
ReorderNo                   LONG                           ! Reorder Number      
DisableYN                   BYTE                           ! Disable YN          
                         END
                     END                       

Setting              FILE,DRIVER('TOPSPEED'),NAME('Setting.tps'),PRE(set),CREATE,BINDABLE,THREAD ! Application Settings
SettingPK                KEY(set:GUID),NOCASE,PRIMARY      !                     
ExcludeFiles                MEMO(9000)                     ! Exclude Files       
Record                   RECORD,PRE()
GUID                        STRING(36)                     !                     
stDescription               STRING(50)                     !                     
RootPath                    STRING(255)                    !                     
FileExtensions              STRING(250)                    ! Separate extensions with a semicolon
                         END
                     END                       

ActionAlias          FILE,DRIVER('TOPSPEED'),NAME('Action.tps'),PRE(act1),CREATE,BINDABLE,THREAD !                     
ActionStepPK             KEY(act1:StepId),NOCASE,PRIMARY   ! Primary Key         
ActionReorder            KEY(-act1:ReorderNo),DUP,NOCASE   ! Use this to renumber steps
stBefore                    MEMO(9000)                     ! String Before       
stAfter                     MEMO(9000)                     ! String After        
Record                   RECORD,PRE()
StepId                      LONG                           ! Step number         
stDescription               STRING(128)                    ! Description of this step
ExcludeFilesYN              BYTE                           !                     
FileName                    STRING(128)                    ! Single file name for changes. Leave blank if global change
LineNo                      LONG                           ! Start Line Number   
ReorderNo                   LONG                           ! Reorder Number      
DisableYN                   BYTE                           ! Disable YN          
                         END
                     END                       

!endregion

WE::ProgramName     string(512)
WE::MustClose       long
WE::CantCloseNow    long
UD         CLASS(UltimateDebug)  
                     END
 

!// This is a global queue, partially based on the queue structure needed by DIRECTORY function
clFiles             QUEUE,PRE(CLF),THREAD
name                    STRING(FILE:MAXFILENAME)  !FILE:MAXFILENAME is an EQUATE string(256)
path                    STRING(FILE:MAXFILEPATH)  !FILE:MAXFILEPATH is an EQUATE string(260)
uname                   STRING(FILE:MAXFILENAME) ! UPPER(name)
                        !shortname               STRING(13)
                        !date                    LONG
                        !time                    LONG
                        !size                    LONG
attrib                  BYTE   ! A bitmap, the same as the attributes EQUATEs
scanned                 BYTE   ! has this folder been run through DIRECTORY yet?
excluded                BYTE   ! Is this file in the global Excluded list?
                    END

!// This is a list of excluded file names
clExclude           QUEUE,PRE(CLE),THREAD
name                    STRING(FILE:MAXFILENAME)  !FILE:MAXFILENAME is an EQUATE string(256)
uname                   STRING(FILE:MAXFILENAME) ! UPPER(name)
wild                    BYTE  ! Contains wild cards
                    END

!// Bear in mind that global queus can be risky if several threads are all manipulating 
!   different queue records at the same time. It's not happening here, only one process at a time
GlobalFrameExtension WindowExtenderClass                   ! Global FrameExtension Manager
Access:Action        &FileManager,THREAD                   ! FileManager for Action
Relate:Action        &RelationManager,THREAD               ! RelationManager for Action
Access:Setting       &FileManager,THREAD                   ! FileManager for Setting
Relate:Setting       &RelationManager,THREAD               ! RelationManager for Setting
Access:ActionAlias   &FileManager,THREAD                   ! FileManager for ActionAlias
Relate:ActionAlias   &RelationManager,THREAD               ! RelationManager for ActionAlias

FuzzyMatcher         FuzzyClass                            ! Global fuzzy matcher
GlobalErrorStatus    ErrorStatusClass,THREAD
GlobalErrors         ErrorClass                            ! Global error manager
INIMgr               INIClass                              ! Global non-volatile storage manager
GlobalRequest        BYTE(0),THREAD                        ! Set when a browse calls a form, to let it know action to perform
GlobalResponse       BYTE(0),THREAD                        ! Set to the response from the form
VCRRequest           LONG(0),THREAD                        ! Set to the request from the VCR buttons

Dictionary           CLASS,THREAD
Construct              PROCEDURE
Destruct               PROCEDURE
                     END


  CODE
  IF GlobalFrameExtension.RestoreInstanceRunning()
     HALT()
  END
  GlobalErrors.Init(GlobalErrorStatus)
  FuzzyMatcher.Init                                        ! Initilaize the browse 'fuzzy matcher'
  FuzzyMatcher.SetOption(MatchOption:NoCase, 1)            ! Configure case matching
  FuzzyMatcher.SetOption(MatchOption:WordOnly, 0)          ! Configure 'word only' matching
  INIMgr.Init('.\clFixer.INI', NVD_INI)                    ! Configure INIManager to use INI file
  DctInit()
  UD.DebugOff       =  0
  UD.DebugPrefix    =  '!'
  UD.SaveToFile     =  0
  UD.ASCIIFileName  =  'DebugLog.txt'
  UD.SaveToJson     =  0
  UD.JSONFileName   =  'JSONDebugLog.txt'
  UD.DebugNoCR      =  1
  UD.LineWrap       =  0 
  UD.UsePlainFormat =  0
  
  SYSTEM{PROP:Icon} = 'toolbox.ico'
    ds_SetOKToEndSessionHandler(address(MyOKToEndSessionHandler))
    ds_SetEndSessionHandler(address(MyEndSessionHandler))
    WE::ProgramName = command('0')
    glo:AppVersion = ds_GetFileVersionInfo(,WE::ProgramName)
  Main
  INIMgr.Update
  INIMgr.Kill                                              ! Destroy INI manager
  FuzzyMatcher.Kill                                        ! Destroy fuzzy matcher
    
! ------ winevent -------------------------------------------------------------------
MyOKToEndSessionHandler procedure(long pLogoff)
OKToEndSession    long(TRUE)
! Setting the return value OKToEndSession = FALSE
! will tell windows not to shutdown / logoff now.
! If parameter pLogoff = TRUE if the user is logging off.

  code
  return(OKToEndSession)

! ------ winevent -------------------------------------------------------------------
MyEndSessionHandler procedure(long pLogoff)
! If parameter pLogoff = TRUE if the user is logging off.

  code
 
!BOE: DEBUG Global
DebugABCGlobalInformation_clFixer PROCEDURE()

udpt            UltimateDebugProcedureTracker
                     
  CODE
  
  udpt.Init(UD,'DebugABCGlobalInformation_clFixer')
  
 
  RETURN

DebugABCGlobalVariables_clFixer PROCEDURE()

udpt            UltimateDebugProcedureTracker

  CODE
  
  udpt.Init(UD,'DebugABCGlobalVariables_clFixer')
  
  RETURN
!EOE: DEBUG Global



Dictionary.Construct PROCEDURE

  CODE
  IF THREAD()<>1
     DctInit()
  END


Dictionary.Destruct PROCEDURE

  CODE
  DctKill()

