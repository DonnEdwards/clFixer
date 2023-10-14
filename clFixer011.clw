

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module


   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('CLFIXER011.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Window
!!! Window
!!! </summary>
MainDashboard PROCEDURE 


i                   LONG
lngRecords          LONG

EnhancedFocusManager EnhancedFocusClassType
QuickWindow          WINDOW('Main Dashboard'),AT(,,401,227),FONT('Segoe UI',9,,FONT:regular,CHARSET:DEFAULT),RESIZE, |
  CENTER,ICON('toolbox.ico'),GRAY,IMM,HLP('MyDashboard'),SYSTEM
                       BUTTON('  &OK'),AT(343,204,47,14),USE(?Ok),LEFT,ICON('WAOK.ICO'),MSG('Close this screen'), |
  TIP('Close this screen')
                       BUTTON('Process the Files'),AT(11,11,81,18),USE(?btnScanFiles),FONT(,,,FONT:bold),LEFT,ICON('WIZFIND.ICO'), |
  MSG('Find the files and make the requested changes'),TIP('Find the files and make the' & |
  ' requested changes')
                       PROMPT('Files Found:'),AT(95,16,63),USE(?glo:qRecords:Prompt),RIGHT
                       ENTRY(@n-14B),AT(163,15,60,12),USE(glo:qRecords),RIGHT(1),FLAT,MSG('Queue Records'),READONLY, |
  TIP('Queue Records')
                       PROMPT('Folders:'),AT(287,16,38),USE(?glo:qFolders:Prompt),RIGHT
                       ENTRY(@n-14B),AT(329,15,60,12),USE(glo:qFolders),RIGHT(1),FLAT,MSG('Number of Folders scanned'), |
  READONLY,TIP('Number of Folders scanned')
                       PROMPT('App Description:'),AT(107,40),USE(?glo:AppDescription:Prompt),RIGHT
                       ENTRY(@s50),AT(163,39,225,12),USE(glo:AppDescription),FLAT,MSG('Description'),READONLY,TIP('Description')
                       PROMPT('Root Path:'),AT(99,54,58),USE(?glo:RootPath:Prompt),RIGHT
                       ENTRY(@s255),AT(163,54,225,12),USE(glo:RootPath),FLAT,MSG('Root Path'),READONLY,TIP('Root Path')
                       PROMPT('File Extensions:'),AT(99,70,58),USE(?glo:FileExtensions:Prompt),RIGHT
                       ENTRY(@s250),AT(163,68,225,12),USE(glo:FileExtensions),FLAT,MSG('File Extensions'),READONLY, |
  TIP('File Extensions')
                       PROMPT('Exclude Files:'),AT(99,85,58),USE(?glo:ExcludeFiles:Prompt),RIGHT
                       TEXT,AT(163,83,225,100),USE(glo:ExcludeFiles),VSCROLL,FLAT,MSG('Exclude Files'),READONLY,TIP('Exclude Files')
                       ENTRY(@s80),AT(11,187,376,10),USE(glo:ProgressMessage),CENTER,FLAT,MSG('Progress Message'), |
  READONLY,TIP('Progress Message'),TRN
                     END

    omit('***',WE::CantCloseNowSetHereDone=1)  !Getting Nested omit compile error, then uncheck the "Check for duplicate CantCloseNowSetHere variable declaration" in the WinEvent local template
WE::CantCloseNowSetHereDone equate(1)
WE::CantCloseNowSetHere     long
    !***
ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
TakeWindowEvent        PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
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

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('MainDashboard')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Ok
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Ok,RequestCancelled)                    ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Ok,RequestCompleted)                    ! Add the close control to the window manger
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
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('MainDashboard',QuickWindow)                ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
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
  IF SELF.Opened
    INIMgr.Update('MainDashboard',QuickWindow)             ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
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
    OF ?btnScanFiles
      ThisWindow.Update()
        ! Click the Scan Files button
        DirAllFileAndFolders(glo:RootPath,glo:FileExtensions) 
        ! 'c:\Clarion11.1','*.inc;*.clw;*.txa;*.dctx;*.def;*.equ;*.tpl;*.tft;*.xml;*.tpw;*.tpl;')
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
        !// Reset clFiles
        lngRecords = RECORDS(clFiles)
        LOOP i = lngRecords to 1 BY -1 ! Loop i
            GET(clFiles,i)
            CLEAR(clFiles)
            DELETE(clFiles)
        END ! Loop i
        glo:qRecords  = RECORDS(clFiles)
        glo:ProgressMessage = 'Freeware copyright <169> 2023 Black and White Inc'
        DISPLAY()
        post(event:visibleondesktop)
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

