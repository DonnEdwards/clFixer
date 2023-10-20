

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE
   INCLUDE('BRWEXT.INC'),ONCE

                     MAP
                       INCLUDE('CLFIXER002.INC'),ONCE        !Local module procedure declarations
                       INCLUDE('CLFIXER004.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('CLFIXER005.INC'),ONCE        !Req'd for module callout resolution
                     END


!!! <summary>
!!! Generated from procedure template - Window
!!! Browse the Action table
!!! </summary>
BrowseAction PROCEDURE 

udpt            UltimateDebugProcedureTracker
loc:StepId          LONG    ! Local copy of StepId
CurrentTab           STRING(80)                            ! 
BRW1::View:Browse    VIEW(Action)
                       PROJECT(act:StepId)
                       PROJECT(act:stDescription)
                       PROJECT(act:ExcludeFilesYN)
                       PROJECT(act:DisableYN)
                       PROJECT(act:LineNo)
                       PROJECT(act:FileName)
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?Browse:1
act:StepId             LIKE(act:StepId)               !List box control field - type derived from field
act:stDescription      LIKE(act:stDescription)        !List box control field - type derived from field
act:ExcludeFilesYN     LIKE(act:ExcludeFilesYN)       !List box control field - type derived from field
act:ExcludeFilesYN_Tip STRING(80)                     !Field tooltip
act:DisableYN          LIKE(act:DisableYN)            !List box control field - type derived from field
act:DisableYN_Tip      STRING(80)                     !Field tooltip
act:LineNo             LIKE(act:LineNo)               !List box control field - type derived from field
act:LineNo_Tip         STRING(80)                     !Field tooltip
act:FileName           LIKE(act:FileName)             !List box control field - type derived from field
act:FileName_Tip       STRING(80)                     !Field tooltip
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
EnhancedFocusManager EnhancedFocusClassType
QuickWindow          WINDOW('Browse the Action table'),AT(,,499,298),FONT('Segoe UI',8,,FONT:regular,CHARSET:DEFAULT), |
  RESIZE,CENTER,ICON('toolbox.ico'),GRAY,IMM,MDI,HLP('BrowseAction'),SYSTEM
                       LIST,AT(8,10,488,260),USE(?Browse:1),FONT(,9),HVSCROLL,FORMAT('50R(5)|M~Step #~C(0)@n-1' & |
  '2@160L(2)|M~Description~C(0)@s128@15C(2)|MP~Excl~C(0)@n~Y~1B@Q''Exclude some files Y' & |
  '/N''15C(2)|MP~Dis~C(0)@n~Y~1B@Q''Disable Y/N''50R(5)|MP~Line #~C(1)@n-12B@140L(2)|MP' & |
  '~File Name~L(3)@s128@'),FROM(Queue:Browse:1),IMM,MSG('Browsing the Action table')
                       BUTTON('&View'),AT(73,274,49,14),USE(?View:2),LEFT,ICON('WAVIEW.ICO'),MSG('View Record'),TIP('View Record')
                       BUTTON('&Insert'),AT(126,274,49,14),USE(?Insert:3),LEFT,ICON('WAINSERT.ICO'),MSG('Insert a Record'), |
  TIP('Insert a Record')
                       BUTTON('&Change'),AT(179,274,49,14),USE(?Change:3),LEFT,ICON('WACHANGE.ICO'),MSG('Change the Record'), |
  TIP('Change the Record')
                       BUTTON('&Delete'),AT(231,274,49,14),USE(?Delete:3),FONT(,,COLOR:Red),LEFT,ICON('WADELETE.ICO'), |
  MSG('Delete the Record'),TIP('Delete the Record')
                       BUTTON('&Close'),AT(447,274,49,14),USE(?Close),LEFT,ICON('WACLOSE.ICO'),MSG('Close Window'), |
  TIP('Close Window')
                       BUTTON('Renumber'),AT(7,274),USE(?btnRenumber),MSG('Use this to renumber the steps in e' & |
  'ven increments'),TIP('Use this to renumber the steps in even increments')
                     END

BRW1::LastSortOrder       BYTE
BRW1::SortHeader  CLASS(SortHeaderClassType) !Declare SortHeader Class
QueueResorted          PROCEDURE(STRING pString),VIRTUAL
                  END
    omit('***',WE::CantCloseNowSetHereDone=1)  !Getting Nested omit compile error, then uncheck the "Check for duplicate CantCloseNowSetHere variable declaration" in the WinEvent local template
WE::CantCloseNowSetHereDone equate(1)
WE::CantCloseNowSetHere     long
    !***
ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
SetAlerts              PROCEDURE(),DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)                    ! Browse using ?Browse:1
Q                      &Queue:Browse:1                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
SetQueueRecord         PROCEDURE(),DERIVED
SetSort                PROCEDURE(BYTE NewOrder,BYTE Force),BYTE,PROC,DERIVED
                     END

BRW1::Sort0:Locator  StepLocatorClass                      ! Default Locator
BRW1::Sort0:StepClass StepLongClass                        ! Default Step Manager
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
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
RenumberRecords ROUTINE
    !
    !// First pass: update all the act:ReorderNo fields
    !
    if Access:ActionAlias.Open() = Level:Benign then ! open (1)
        Access:ActionAlias.ClearKey(act1:ActionStepPK)
        SET(act1:ActionStepPK)
        loc:StepId = 90
        LOOP UNTIL Access:ActionAlias.Next() <> Level:Benign ! Next
            loc:StepId += 10
            act1:ReorderNo = 1000000 + loc:StepId
            if Access:ActionAlias.Update() <> Level:Benign then ! Trouble
                MESSAGE('Trouble updating the ActionAlias table (1)','Window will close',ICON:Exclamation,BUTTON:ABORT)
                post(EVENT:CloseDown) ! Close this window
                EXIT
            end ! trouble
            !dbg(act1:StepId & ' - ' & act1:ReorderNo & ' - ' & loc:StepId)            
        END ! Next
        Access:ActionAlias.Close()
        !
        !// Second pass: update all the act1:StepId fields with
        !   big numbers
        if Access:ActionAlias.Open() = Level:Benign then ! open (2)
            Access:ActionAlias.ClearKey(act1:ActionStepPK)
            SET(act1:ActionReorder)
            LOOP UNTIL Access:ActionAlias.Next() <> Level:Benign ! Next
                act1:StepId = act1:ReorderNo
                if Access:ActionAlias.Update() <> Level:Benign then ! Trouble
                    MESSAGE('Trouble updating the ActionAlias table (2)','Window will close',ICON:Exclamation,BUTTON:ABORT)
                    post(EVENT:CloseDown) ! Close this window
                    EXIT
                end ! trouble
                !dbg(act1:StepId & ' - ' & act1:ReorderNo)            
            END ! Next
            Access:ActionAlias.Close()     
            !
            !// Third pass: update all the act1:StepId fields with
            !   correct step numbers
            if Access:ActionAlias.Open() = Level:Benign then ! open (3)
                Access:ActionAlias.ClearKey(act1:ActionStepPK)
                SET(act1:ActionReorder)
                LOOP UNTIL Access:ActionAlias.Next() <> Level:Benign ! Next
                    act1:StepId = act1:ReorderNo - 1000000
                    if Access:ActionAlias.Update() <> Level:Benign then ! Trouble
                        MESSAGE('Trouble updating the ActionAlias table (3)','Window will close',ICON:Exclamation,BUTTON:ABORT)
                        post(EVENT:CloseDown) ! Close this window
                        EXIT
                    end ! trouble
                    !dbg(act1:StepId & ' - ' & act1:ReorderNo)            
                END ! Next
                Access:ActionAlias.Close()
            else ! Open (3)
                MESSAGE('Trouble opening the ActionAlias table (3)','Window will close',ICON:Exclamation,BUTTON:ABORT)
                post(EVENT:CloseDown) ! Close this window
            end ! Open
        else ! Open (2)
            MESSAGE('Trouble opening the ActionAlias table (2)','Window will close',ICON:Exclamation,BUTTON:ABORT)
            post(EVENT:CloseDown) ! Close this window
        end ! Open
    else ! Open (1)
        MESSAGE('Trouble opening the ActionAlias table (1)','Window will close',ICON:Exclamation,BUTTON:ABORT)
        post(EVENT:CloseDown) ! Close this window
    end ! Open

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
        udpt.Init(UD,'BrowseAction','clFixer002.clw','clFixer.EXE','10/19/2023 @ 06:07PM')    
             
  GlobalErrors.SetProcedureName('BrowseAction')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Browse:1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  Relate:Action.Open()                                     ! File Action used by this procedure, so make sure it's RelationManager is open
  Relate:ActionAlias.Open()                                ! File ActionAlias used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?Browse:1,Queue:Browse:1.ViewPosition,BRW1::View:Browse,Queue:Browse:1,Relate:Action,SELF) ! Initialize the browse manager
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
  QuickWindow{Prop:Alrt,255} = CtrlShiftP
  BRW1.Q &= Queue:Browse:1
  BRW1::Sort0:StepClass.Init(+ScrollSort:AllowAlpha)       ! Moveable thumb based upon act:StepId for sort order 1
  BRW1.AddSortOrder(BRW1::Sort0:StepClass,act:ActionStepPK) ! Add the sort order for act:ActionStepPK for sort order 1
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort0:Locator.Init(,act:StepId,1,BRW1)             ! Initialize the browse locator using  using key: act:ActionStepPK , act:StepId
  BRW1.AddField(act:StepId,BRW1.Q.act:StepId)              ! Field act:StepId is a hot field or requires assignment from browse
  BRW1.AddField(act:stDescription,BRW1.Q.act:stDescription) ! Field act:stDescription is a hot field or requires assignment from browse
  BRW1.AddField(act:ExcludeFilesYN,BRW1.Q.act:ExcludeFilesYN) ! Field act:ExcludeFilesYN is a hot field or requires assignment from browse
  BRW1.AddField(act:DisableYN,BRW1.Q.act:DisableYN)        ! Field act:DisableYN is a hot field or requires assignment from browse
  BRW1.AddField(act:LineNo,BRW1.Q.act:LineNo)              ! Field act:LineNo is a hot field or requires assignment from browse
  BRW1.AddField(act:FileName,BRW1.Q.act:FileName)          ! Field act:FileName is a hot field or requires assignment from browse
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('BrowseAction',QuickWindow)                 ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  BRW1.AskProcedure = 1                                    ! Will call: UpdateAction
  BRW1.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  SELF.SetAlerts()
  !Initialize the Sort Header using the Browse Queue and Browse Control
  BRW1::SortHeader.Init(Queue:Browse:1,?Browse:1,'','',BRW1::View:Browse)
  BRW1::SortHeader.UseSortColors = False
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
  !Kill the Sort Header
  BRW1::SortHeader.Kill()
  END
  IF SELF.Opened
    INIMgr.Update('BrowseAction',QuickWindow)              ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
            
   
  RETURN ReturnValue


ThisWindow.Run PROCEDURE(USHORT Number,BYTE Request)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Run(Number,Request)
  IF SELF.Request = ViewRecord
    ReturnValue = RequestCancelled                         ! Always return RequestCancelled if the form was opened in ViewRecord mode
  ELSE
    GlobalRequest = Request
    UpdateAction
    ReturnValue = GlobalResponse
  END
  RETURN ReturnValue


ThisWindow.SetAlerts PROCEDURE

  CODE
  PARENT.SetAlerts
  !Initialize the Sort Header using the Browse Queue and Browse Control
  BRW1::SortHeader.SetAlerts()


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
    OF ?btnRenumber
        ! Renumber, refresh
        do RenumberRecords      
        ThisWindow.Reset(1)
    END
  ReturnValue = PARENT.TakeAccepted()
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
  !Take Sort Headers Events
  IF BRW1::SortHeader.TakeEvents()
     RETURN Level:Notify
  END
  EnhancedFocusManager.TakeEvent()
  ReturnValue = PARENT.TakeEvent()
  If event() = event:VisibleOnDesktop !or event() = event:moved
    ds_VisibleOnDesktop()
  end
     IF KEYCODE()=CtrlShiftP AND EVENT() = Event:PreAlertKey
       CYCLE
     END
     IF KEYCODE()=CtrlShiftP  
        UD.ShowProcedureInfo('BrowseAction',UD.SetApplicationName('clFixer','EXE'),QuickWindow{PROP:Hlp},'09/25/2023 @ 06:29PM','10/19/2023 @ 06:07PM','10/19/2023 @ 06:13PM')  
    
       CYCLE
     END
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


BRW1.Init PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)

  CODE
  PARENT.Init(ListBox,Posit,V,Q,RM,WM)
  IF WM.Request <> ViewRecord                              ! If called for anything other than ViewMode, make the insert, change & delete controls available
    SELF.InsertControl=?Insert:3
    SELF.ChangeControl=?Change:3
    SELF.DeleteControl=?Delete:3
  END
  SELF.ViewControl = ?View:2                               ! Setup the control used to initiate view only mode


BRW1.SetQueueRecord PROCEDURE

  CODE
  PARENT.SetQueueRecord
  
  CLEAR (SELF.Q.act:ExcludeFilesYN_Tip)
  CLEAR (SELF.Q.act:DisableYN_Tip)
  CLEAR (SELF.Q.act:LineNo_Tip)
  CLEAR (SELF.Q.act:FileName_Tip)


BRW1.SetSort PROCEDURE(BYTE NewOrder,BYTE Force)

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.SetSort(NewOrder,Force)
  IF BRW1::LastSortOrder<>NewOrder THEN
     BRW1::SortHeader.ClearSort()
  END
  BRW1::LastSortOrder=NewOrder
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

BRW1::SortHeader.QueueResorted       PROCEDURE(STRING pString)
  CODE
    IF pString = ''
       BRW1.RestoreSort()
       BRW1.ResetSort(True)
    ELSE
       BRW1.ReplaceSort(pString,BRW1::Sort0:Locator)
       BRW1.SetLocatorFromSort()
    END
