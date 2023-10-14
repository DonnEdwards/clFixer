

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module


   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('CLFIXER005.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Window
!!! Form Action
!!! </summary>
UpdateAction PROCEDURE 

loc:StepId          LONG        ! Local copy of StepId
i                   LONG
lngStepIdmax        LONG        ! Maximum value of StepId
CurrentTab           STRING(80)                            ! 
ActionMessage        CSTRING(40)                           ! 
EnhancedFocusManager EnhancedFocusClassType
History::act:Record  LIKE(act:RECORD),THREAD
QuickWindow          WINDOW('Form Action'),AT(,,483,278),FONT('Segoe UI',8,,FONT:regular,CHARSET:DEFAULT),RESIZE, |
  CENTER,ICON('toolbox.ico'),GRAY,IMM,MDI,HLP('UpdateAction'),SYSTEM
                       PROMPT('Step Id:'),AT(32,12),USE(?act:StepId:Prompt),RIGHT,TRN
                       BUTTON('New Step No'),AT(143,10,66),USE(?btnNextStep)
                       STRING('Don''t apply this action to excluded files'),AT(243,41,209),USE(?lblExclude),RIGHT
                       PROMPT('Description:'),AT(17,28),USE(?act:stDescription:Prompt)
                       ENTRY(@s128),AT(65,28,405,10),USE(act:stDescription),MSG('Description of this step'),REQ,TIP('Descriptio' & |
  'n of this step')
                       PROMPT('File Name:'),AT(22,54),USE(?act:FileName:Prompt)
                       ENTRY(@s128),AT(65,54,405,10),USE(act:FileName),MSG('(Optional) Single file name for ch' & |
  'anges. Leave blank if global change'),TIP('(Optional) Single file name for changes. ' & |
  'Leave blank if global change')
                       PROMPT('Line No:'),AT(29,69),USE(?act:LineNo:Prompt)
                       ENTRY(@n-14B),AT(65,69,65,10),USE(act:LineNo),MSG('(Optional) Start Line Number'),TIP('(Optional)' & |
  ' Start Line Number')
                       PROMPT('Before:'),AT(33,85),USE(?act:stBefore:Prompt:2),RIGHT,TRN
                       BUTTON('Paste ->'),AT(17,100,41,12),USE(?btnPasteBefore)
                       TEXT,AT(65,84,405,80),USE(act:stBefore),VSCROLL,MSG('String Before (Case sensitive)'),SCROLL, |
  TIP('String Before (Case sensitive)')
                       PROMPT('After:'),AT(39,172),USE(?act:stAfter:Prompt:2),RIGHT,TRN
                       BUTTON('Paste ->'),AT(17,186,41,12),USE(?btnPasteAfter)
                       TEXT,AT(65,172,405,80),USE(act:stAfter),VSCROLL,MSG('String After (Case sensitive)'),SCROLL, |
  TIP('String After (Case sensitive)')
                       BUTTON('&OK'),AT(369,255,49,14),USE(?OK),LEFT,ICON('WAOK.ICO'),MSG('Accept data and clo' & |
  'se the window'),TIP('Accept data and close the window')
                       BUTTON('&Cancel'),AT(421,255,49,14),USE(?Cancel),LEFT,ICON('WACANCEL.ICO'),MSG('Cancel operation'), |
  TIP('Cancel operation')
                       CHECK,AT(457,41,14,10),USE(act:ExcludeFilesYN),VALUE('1','0')
                       ENTRY(@n-14),AT(65,12,65,10),USE(act:StepId),RIGHT(1),MSG('Step number'),REQ,TIP('Step number')
                       PROMPT('Disable:'),AT(407,12,46),USE(?lblDisableYN),RIGHT
                       CHECK,AT(457,12,13),USE(act:DisableYN),MSG('Disable YN'),TIP('Disable YN'),VALUE('1','0')
                       PROMPT('<<- Leave blank unless you are doing a single replacement in the file listed here'), |
  AT(135,68,336),USE(?txtLineNo)
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
TakeFieldEvent         PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
ToolbarForm          ToolbarUpdateClass                    ! Form Toolbar Manager
CurCtrlFeq          LONG
FieldColorQueue     QUEUE
Feq                   LONG
OldColor              LONG
                    END

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------
! Dislay Routines
EnableDisabledYN    ROUTINE
    ! change description text to grey if DisabledYN
    if act:DisableYN then ! Disabled
        SETFONT(?act:stDescription,,,COLOR:GRAYTEXT)
        SETFONT(?act:StepId,,,COLOR:HIGHLIGHT)
    else ! not Disabled
        SETFONT(?act:stDescription,,,COLOR:BTNTEXT)
        SETFONT(?act:StepId,,,COLOR:BTNTEXT)
    end ! not Disabled 
    
EnableDisableLineNo ROUTINE   
    ! Disable Line No field if act:FileName is empty
    if len(CLIP(act:FileName)) < 5 then  ! empty
        ?act:LineNo{PROP:Flat} = True 
        act:LineNo = 0  
    else ! not empty
        ?act:LineNo{PROP:Flat} = False
    end ! not empty
    
CalcNextStep        ROUTINE
    ! Find the largest step number, add 10
    loc:StepId = act:StepId ! Save the current step number
    lngStepIdmax = 0      ! Start
    !// Open an alias of the table so as not to screw things up
    Access:ActionAlias.Open()
    Access:ActionAlias.ClearKey(act1:ActionStepPK)
    SET(act1:ActionStepPK)
    LOOP UNTIL Access:ActionAlias.Next() <> Level:Benign ! Next
        if lngStepIdmax < act1:StepId then ! lngStepIdmax
            lngStepIdmax = act1:StepId   ! The new max
        end ! lngStepIdmax
    END ! Next
    Access:ActionAlias.Close()
    if loc:stepId <> lngStepIdmax then
        ! Add to the most recent step to get the new one
        act:stepId = lngStepIdmax + 10  
        ! unless we already have the largest number
    end 

ThisWindow.Ask PROCEDURE

  CODE
  CASE SELF.Request                                        ! Configure the action message text
  OF ViewRecord
    ActionMessage = 'View Record'
  OF InsertRecord
    ActionMessage = 'Record Will Be Added'
  OF ChangeRecord
    ActionMessage = 'Record Will Be Changed'
  END
  QuickWindow{PROP:Text} = ActionMessage                   ! Display status message in title bar
  PARENT.Ask


ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('UpdateAction')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?act:StepId:Prompt
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  SELF.HistoryKey = CtrlH
  SELF.AddHistoryFile(act:Record,History::act:Record)
  SELF.AddHistoryField(?act:stDescription,2)
  SELF.AddHistoryField(?act:FileName,4)
  SELF.AddHistoryField(?act:LineNo,5)
  SELF.AddHistoryField(?act:stBefore,8)
  SELF.AddHistoryField(?act:stAfter,8)
  SELF.AddHistoryField(?act:ExcludeFilesYN,3)
  SELF.AddHistoryField(?act:StepId,1)
  SELF.AddHistoryField(?act:DisableYN,7)
  SELF.AddUpdateFile(Access:Action)
  SELF.AddItem(?Cancel,RequestCancelled)                   ! Add the cancel control to the window manager
  Relate:Action.Open()                                     ! File Action used by this procedure, so make sure it's RelationManager is open
  Relate:ActionAlias.Open()                                ! File ActionAlias used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Primary &= Relate:Action
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
    DISABLE(?btnNextStep)
    ?act:stDescription{PROP:ReadOnly} = True
    ?act:FileName{PROP:ReadOnly} = True
    ?act:LineNo{PROP:ReadOnly} = True
    DISABLE(?btnPasteBefore)
    ?act:stBefore{PROP:ReadOnly} = True
    DISABLE(?btnPasteAfter)
    HIDE(?OK)
    ?act:ExcludeFilesYN{PROP:ReadOnly} = True
    ?act:StepId{PROP:ReadOnly} = True
    ?act:DisableYN{PROP:ReadOnly} = True
  END
    ! Configure controls for View Only mode
    IF SELF.Request = ViewRecord                             
        ?act:StepId{PROP:Flat} = True
        !?act:ExcludeFilesYN{PROP:ReadOnly} = True ! Can't make it flat
        ?act:stDescription{PROP:Flat} = True
        ?act:stBefore{PROP:Flat} = True
        ?act:stAfter{PROP:Flat} = True
        ?act:FileName{PROP:Flat} = True
        ?act:LineNo{PROP:Flat} = True
        !?btnNextStep{PROP:Hide} = True
        ?btnPasteBefore{PROP:Hide} = True
        ?btnPasteAfter{PROP:Hide} = True
    END
  INIMgr.Fetch('UpdateAction',QuickWindow)                 ! Restore window settings from non-volatile store
  SELF.AddItem(ToolbarForm)
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
    Relate:Action.Close()
    Relate:ActionAlias.Close()
  END
  IF SELF.Opened
    INIMgr.Update('UpdateAction',QuickWindow)              ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.Run PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
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
    CASE ACCEPTED()
    OF ?btnNextStep
        do CalcNextStep ! Find the largest step number, add 10
        DISPLAY()
    OF ?btnPasteBefore
        ! CLIPBOARD(CF_TEXT)
        act:stBefore = CLIPBOARD(CF_TEXT)
        DISPLAY()
    OF ?btnPasteAfter
        ! CLIPBOARD(CF_TEXT)
        act:stAfter = CLIPBOARD(CF_TEXT)
        DISPLAY()        
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
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


ThisWindow.TakeFieldEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all field specific events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  CASE FIELD()
  OF ?act:FileName
        ! Disable Line No field if act:FileName is empty
        do EnableDisableLineNo
  OF ?act:DisableYN
        ! All events - change description text to grey if DisabledYN  
        do EnableDisabledYN
  END
  ReturnValue = PARENT.TakeFieldEvent()
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
        !// OpenWindow Display stuff
        do EnableDisabledYN    ! Change description text to grey if DisabledYN        
        do EnableDisableLineNo ! Disable Line No field if act:FileName is empty
        post(event:visibleondesktop)
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

