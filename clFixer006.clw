

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module


   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('CLFIXER006.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Window
!!! Form Setting
!!! </summary>
UpdateSetting PROCEDURE 

CurrentTab           STRING(80)                            ! 
ActionMessage        CSTRING(40)                           ! 
EnhancedFocusManager EnhancedFocusClassType
History::set:Record  LIKE(set:RECORD),THREAD
QuickWindow          WINDOW(' Update Application Settings'),AT(,,358,273),FONT('Segoe UI',8,,FONT:regular,CHARSET:DEFAULT), |
  RESIZE,CENTER,ICON('toolbox.ico'),GRAY,IMM,MDI,HLP('UpdateSetting'),SYSTEM
                       PROMPT('GUID:'),AT(10,9,61),USE(?set:GUID:Prompt),RIGHT,TRN
                       PROMPT('Description:'),AT(10,34,61),USE(?set:stDescription:Prompt),RIGHT,TRN
                       ENTRY(@s50),AT(76,34,247,10),USE(set:stDescription),REQ
                       PROMPT('Root Path:'),AT(10,48,61),USE(?set:RootPath:Prompt),RIGHT,TRN
                       ENTRY(@s255),AT(76,48,247,10),USE(set:RootPath)
                       PROMPT('File Extensions:'),AT(10,63,61),USE(?set:FileExtensions:Prompt),RIGHT,TRN
                       ENTRY(@s250),AT(76,63,274,10),USE(set:FileExtensions),MSG('Separate extensions with a semicolon'), |
  TIP('Separate extensions with a semicolon')
                       BUTTON('...'),AT(327,47,12,12),USE(?LookupFile)
                       PROMPT('Exclude Files:'),AT(10,86,61),USE(?set:ExcludeFiles:Prompt),RIGHT,TRN
                       TEXT,AT(76,86,274,160),USE(set:ExcludeFiles),VSCROLL,MSG('Exclude these files if requested'), |
  SCROLL,TIP('Exclude these files if requested')
                       BUTTON('&OK'),AT(248,250,49,14),USE(?OK),LEFT,ICON('WAOK.ICO'),MSG('Accept data and clo' & |
  'se the window'),TIP('Accept data and close the window')
                       BUTTON('&Cancel'),AT(301,250,49,14),USE(?Cancel),LEFT,ICON('WACANCEL.ICO'),MSG('Cancel operation'), |
  TIP('Cancel operation')
                       ENTRY(@s36),AT(75,9,148,10),USE(set:GUID),DISABLE,FLAT,READONLY,REQ
                     END

    omit('***',WE::CantCloseNowSetHereDone=1)  !Getting Nested omit compile error, then uncheck the "Check for duplicate CantCloseNowSetHere variable declaration" in the WinEvent local template
WE::CantCloseNowSetHereDone equate(1)
WE::CantCloseNowSetHere     long
    !***
ThisWindow           CLASS(WindowManager)
Ask                    PROCEDURE(),DERIVED
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
Update                 PROCEDURE(),DERIVED
                     END

Toolbar              ToolbarClass
FileLookup8          SelectFileClass
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END

CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
                    END

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop
  GLO:oneInstance_UpdateSetting_thread = 0

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------
!// Update Global values
UpdateGlobalFields  ROUTINE
    glo:AppDescription = set:stDescription
    glo:RootPath = set:RootPath
    glo:FileExtensions = set:FileExtensions
    glo:ExcludeFiles = set:ExcludeFiles
    DISPLAY()

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request                                        ! Configure the action message text
  OF ViewRecord
    ActionMessage = 'View Record'
  OF InsertRecord
    ActionMessage = 'Record Will Be Added'
  OF ChangeRecord
    ActionMessage = 'Update the Settings'
  END
  QuickWindow{PROP:StatusText,0} = ActionMessage           ! Display status message in status bar
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('UpdateSetting')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?set:GUID:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  SELF.HistoryKey = CtrlH
  SELF.AddHistoryFile(set:Record,History::set:Record)
  SELF.AddHistoryField(?set:stDescription,2)
  SELF.AddHistoryField(?set:RootPath,3)
  SELF.AddHistoryField(?set:FileExtensions,4)
  SELF.AddHistoryField(?set:ExcludeFiles,5)
  SELF.AddHistoryField(?set:GUID,1)
  SELF.AddUpdateFile(Access:Setting)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:Setting.Open()                                    ! File Setting used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:Setting
  IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing ! Setup actions for ViewOnly Mode
    SELF.InsertAction = Insert:None
    SELF.DeleteAction = Delete:None
    SELF.ChangeAction = Change:None
    SELF.CancelAction = Cancel:Cancel
    SELF.OkControl = 0
  ELSE
    SELF.ChangeAction = Change:Caller                      ! Changes allowed
    SELF.CancelAction = Cancel:Cancel+Cancel:Query         ! Confirm cancel
    SELF.OkControl = ?OK
    IF SELF.PrimeUpdate() THEN RETURN Level:Notify.
  END
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  Alert(AltKeyPressed)  ! WinEvent : These keys cause a program to crash on Windows 7 and Windows 10.
  Alert(F10Key)         !
  Alert(CtrlF10)        !
  Alert(ShiftF10)       !
  Alert(CtrlShiftF10)   !
  Alert(AltSpace)       !
  WinAlertMouseZoom()
  WinAlert(WE::WM_QueryEndSession,,Return1+PostUser)
  IF SELF.Request = ViewRecord                             ! Configure controls for View Only mode
    ?set:stDescription{PROP:ReadOnly} = True
    ?set:RootPath{PROP:ReadOnly} = True
    ?set:FileExtensions{PROP:ReadOnly} = True
    HIDE(?LookupFile)
    ?set:ExcludeFiles{PROP:ReadOnly} = True
    HIDE(?OK)
    ?set:GUID{PROP:ReadOnly} = True
  END
    ! Configure controls for View Only mode
    IF SELF.Request = ViewRecord              
        ?set:stDescription{PROP:Flat} = True
        ?set:RootPath{PROP:Flat} = True
        ?set:FileExtensions{PROP:Flat} = True
        ?set:GUID{PROP:Flat} = True
        ?set:ExcludeFiles{PROP:Flat} = True
    END  
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('UpdateSetting',QuickWindow)                ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  FileLookup8.Init
  FileLookup8.ClearOnCancel = True
  FileLookup8.Flags=BOR(FileLookup8.Flags,FILE:LongName)   ! Allow long filenames
  FileLookup8.Flags=BOR(FileLookup8.Flags,FILE:Directory)  ! Allow Directory Dialog
  FileLookup8.SetMask('All Files','*.*')                   ! Set the file mask
  FileLookup8.DefaultDirectory='''c:\Clarion'''
  SELF.SetAlerts()
  EnhancedFocusManager.Init(1,12648447,0,0,16777152,0,65535,0,2,65535,0,0,0,'»',8)
  EnhancedFocusManager.SetOnScreenKeyboard(False) !Will disable the OSK
  EnhancedFocusManager.DisableControlType(CREATE:Check)
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  If self.opened Then WinAlert().
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Setting.Close()
  END
  IF SELF.Opened
    INIMgr.Update('UpdateSetting',QuickWindow)             ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
    GlobalRequest = changeRecord
    Access:Setting.Open()
    Access:Setting.UseFile()
    If Records(Setting) < 1
        Access:Setting.PrimeRecord()
        set:GUID = glo:st.MakeGuid()
        Access:Setting.Insert()
    else
        set(set:SettingPK)
        Access:Setting.Next()
    End
    dbg(set:GUID)
    do UpdateGlobalFields ! Update record val;ues to global variables    
  ReturnValue = PARENT.Run()
  IF SELF.Request = ViewRecord                             ! In View Only mode always signal RequestCancelled
    ReturnValue = RequestCancelled
  END
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?LookupFile
      ThisWindow.Update()
      set:RootPath = FileLookup8.Ask(1)
      DISPLAY
    OF ?OK
      ThisWindow.Update()
      IF SELF.Request = ViewRecord AND NOT SELF.BatchProcessing THEN
         POST(EVENT:CloseWindow)
      END
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  EnhancedFocusManager.TakeEvent()
  ReturnValue = PARENT.TakeEvent()
  If event() = event:VisibleOnDesktop !or event() = event:moved
    ds_VisibleOnDesktop()
  end
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeWindowEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all window specific events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    CASE EVENT()
    OF EVENT:CloseDown
      if WE::CantCloseNow
        WE::MustClose = 1
        cycle
      else
        self.CancelAction = cancel:cancel
        self.response = requestcancelled
      end
    END
  ReturnValue = PARENT.TakeWindowEvent()
    CASE EVENT()
    OF EVENT:OpenWindow
        post(event:visibleondesktop)
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.Update PROCEDURE

  CODE
  PARENT.Update
  do UpdateGlobalFields  !// Note the changed data into global variables


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

