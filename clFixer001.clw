

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module


   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE
   INCLUDE('winext.inc'),ONCE

                     MAP
                       INCLUDE('CLFIXER001.INC'),ONCE        !Local module procedure declarations
                       INCLUDE('CLFIXER002.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('CLFIXER006.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('CLFIXER007.INC'),ONCE        !Req'd for module callout resolution
                       INCLUDE('CLFIXER011.INC'),ONCE        !Req'd for module callout resolution
                     END


!!! <summary>
!!! Generated from procedure template - Frame
!!! Wizard Application for F:\dev\clFixer\clFixer.dct
!!! </summary>
Main PROCEDURE 


!region Principled programming
! ---------------------------------------------------------------------------
! From www.developerdotstar.com:
!
! Principled Programming:
! =======================
!
! Personal Character
! ------------------
! Write your code so that it reflects, or rises above, the best parts of your
! personal character.
!
! Aesthetics
! ----------
! Strive for beauty and elegance in every aspect of your work.
!
! Clarity
! -------
! Value clarity equally with correctness. Utilize the proven techniques that
! will produce clarity in your code. Correctness will likely follow suit.
!
! Layout
! ------
! Use the visual layout of your code to communicate the structure of your code
! to human readers.
!
! Explicitness
! ------------
! Always favour the explicit over the implicit.
!
! Self-Documenting Code
! ---------------------
! The most reliable document of software is the code itself. In many cases,
! the code is the *only* documentation. Therefore, strive to make your code
! self-documenting, and where you can't, add comments.
!
! Comments
! --------
! Comment in full sentences in order to summarize and communicate intent.
!
! Assumptions
! -----------
! Take reasonable steps to test, document, and otherwise draw attention to the
! assumptions made in every module and routine.
!
! User Interaction
! ----------------
! Never make the user feel stupid.
!
! Going Back
! ----------
! The time to write good code is at the time you are writing it.
!
! Other People's Time and Money
! -----------------------------
! A true professional does not waste the time and money of other people by
! handing over software that is not reasonably free of obvious bugs; that has
! not undergone minimal unit testing; that does not meet the specifications and
! requirements; that is gold-plated with unnecessary features; or that looks
! like junk.
!
! Written by Daniel Read dan (at) developerdotstar.com
! Full version at http://www.developerdotstar.com/mag/articles/read_princprog.html
!
! -----------------------------------------------------------------------------
!endregion

EnhancedFocusManager EnhancedFocusClassType
AppFrame             APPLICATION(' Clarion Fixer '),AT(,,525,357),FONT('Segoe UI',8,,FONT:regular,CHARSET:DEFAULT), |
  RESIZE,CENTERED,CENTER,ICON('toolbox.ico'),MAX,STATUS(-1,80,120,45),SYSTEM,WALLPAPER('toolbox.png'),IMM
                       MENUBAR,USE(?Menubar)
                         MENU('&File'),USE(?FileMenu)
                           ITEM('&Print Setup ...'),USE(?PrintSetup),MSG('Setup printer'),STD(STD:PrintSetup)
                           ITEM,USE(?SEPARATOR1),SEPARATOR
                           ITEM('E&xit'),USE(?Exit),MSG('Exit this application'),STD(STD:Close)
                         END
                         MENU('&Edit'),USE(?EditMenu)
                           ITEM('Cu&t'),USE(?Cut),MSG('Cut Selection To Clipboard'),STD(STD:Cut)
                           ITEM('&Copy'),USE(?Copy),MSG('Copy Selection To Clipboard'),STD(STD:Copy)
                           ITEM('&Paste'),USE(?Paste),MSG('Paste From Clipboard'),STD(STD:Paste)
                         END
                         MENU('&Data'),USE(?BrowseMenu),FONT(,,,FONT:bold)
                           ITEM('Main &Dashboard'),USE(?mnuDashboard),MSG('Display the Main Dashboard')
                           ITEM,USE(?SEPARATOR2),SEPARATOR
                           ITEM('Replacement &Actions'),USE(?BrowseAction),FONT(,,,FONT:regular),MSG('Browse Repla' & |
  'cement Actions')
                           ITEM('Application &Settings'),USE(?BrowseSetting),FONT(,,,FONT:regular),MSG('Change App' & |
  'lication Settings')
                         END
                         MENU('&Window'),USE(?WindowMenu),STD(STD:WindowList)
                           ITEM('T&ile'),USE(?Tile),MSG('Arrange multiple opened windows'),STD(STD:TileWindow)
                           ITEM('&Cascade'),USE(?Cascade),MSG('Arrange multiple opened windows'),STD(STD:CascadeWindow)
                           ITEM('&Arrange Icons'),USE(?Arrange),MSG('Arrange the icons for minimized windows'),STD(STD:ArrangeIcons)
                         END
                         MENU('&Help'),USE(?HelpMenu)
                           ITEM('&About clFixer'),USE(?AboutBox),MSG('Information about this application')
                           ITEM('&Diagnostics Information'),USE(?SystemInfo),MSG('Information about Windows')
                         END
                       END
                       TOOLBAR,AT(0,0,525,16),USE(?Toolbar)
                         BUTTON,AT(4,2,14,14),USE(?Toolbar:Top, Toolbar:Top),ICON('WAVCRFIRST.ICO'),DISABLE,FLAT,TIP('Go to the ' & |
  'First Page')
                         BUTTON,AT(18,2,14,14),USE(?Toolbar:PageUp, Toolbar:PageUp),ICON('WAVCRPRIOR.ICO'),DISABLE, |
  FLAT,TIP('Go to the Prior Page')
                         BUTTON,AT(32,2,14,14),USE(?Toolbar:Up, Toolbar:Up),ICON('WAVCRUP.ICO'),DISABLE,FLAT,TIP('Go to the ' & |
  'Prior Record')
                         BUTTON,AT(46,2,14,14),USE(?Toolbar:Locate, Toolbar:Locate),ICON('WAFIND.ICO'),DISABLE,FLAT, |
  TIP('Locate record')
                         BUTTON,AT(60,2,14,14),USE(?Toolbar:Down, Toolbar:Down),ICON('WAVCRDOWN.ICO'),DISABLE,FLAT, |
  TIP('Go to the Next Record')
                         BUTTON,AT(74,2,14,14),USE(?Toolbar:PageDown, Toolbar:PageDown),ICON('WAVCRNEXT.ICO'),DISABLE, |
  FLAT,TIP('Go to the Next Page')
                         BUTTON,AT(88,2,14,14),USE(?Toolbar:Bottom, Toolbar:Bottom),ICON('WAVCRLAST.ICO'),DISABLE,FLAT, |
  TIP('Go to the Last Page')
                         BUTTON,AT(102,2,14,14),USE(?Toolbar:Select, Toolbar:Select),ICON('WAMARK.ICO'),DISABLE,FLAT, |
  TIP('Select This Record')
                         BUTTON,AT(116,2,14,14),USE(?Toolbar:Insert, Toolbar:Insert),ICON('WAINSERT.ICO'),DISABLE,FLAT, |
  TIP('Insert a New Record')
                         BUTTON,AT(130,2,14,14),USE(?Toolbar:Change, Toolbar:Change),ICON('WACHANGE.ICO'),DISABLE,FLAT, |
  TIP('Edit This Record')
                         BUTTON,AT(144,2,14,14),USE(?Toolbar:Delete, Toolbar:Delete),ICON('WADELETE.ICO'),DISABLE,FLAT, |
  TIP('Delete This Record')
                         BUTTON,AT(158,2,14,14),USE(?Toolbar:History, Toolbar:History),ICON('WADITTO.ICO'),DISABLE, |
  FLAT,TIP('Previous value')
                         !            BUTTON,AT(172,2,14,14),USE(?Toolbar:Help, Toolbar:Help),ICON('WAVCRHELP.ICO'), |
                         !              DISABLE,FLAT,TIP('Get Help'),#SEQ(1),#ORDINAL(35)
                       END
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
FrameExtension       WindowExtenderClass

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop
  GLO:oneInstance_Main_thread = 0

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------
Menu::Menubar ROUTINE                                      ! Code for menu items on ?Menubar
Menu::FileMenu ROUTINE                                     ! Code for menu items on ?FileMenu
Menu::EditMenu ROUTINE                                     ! Code for menu items on ?EditMenu
Menu::BrowseMenu ROUTINE                                   ! Code for menu items on ?BrowseMenu
  CASE ACCEPTED()
  OF ?mnuDashboard
    START(MainDashboard, 25000)
  OF ?BrowseAction
    START(BrowseAction, 050000)
  OF ?BrowseSetting
    IF GLO:oneInstance_UpdateSetting_thread = 0
       GLO:oneInstance_UpdateSetting_thread = START(UpdateSetting, 050000)
    ELSE
       NOTIFY(EVENT:GainFocus, GLO:oneInstance_UpdateSetting_thread)
    END
  END
Menu::WindowMenu ROUTINE                                   ! Code for menu items on ?WindowMenu
Menu::HelpMenu ROUTINE                                     ! Code for menu items on ?HelpMenu
  CASE ACCEPTED()
  OF ?AboutBox
    START(AboutBox, 25000)
  OF ?SystemInfo
    START(SystemInfo, 25000)
  END

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Main')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = 1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  Relate:Setting.Open()                                    ! File Setting used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  SELF.Open(AppFrame)                                      ! Open window
  Do DefineListboxStyle
  Alert(AltKeyPressed)  ! WinEvent : These keys cause a program to crash on Windows 7 and Windows 10.
  Alert(F10Key)         !
  Alert(CtrlF10)        !
  Alert(ShiftF10)       !
  Alert(CtrlShiftF10)   !
  Alert(AltSpace)       !
  WinAlertMouseZoom()
  WinAlert(WE::WM_QueryEndSession,,Return1+PostUser)
  FrameExtension.Init(AppFrame,0,0,0{PROP:Icon},'')
  INIMgr.Fetch('Main',AppFrame)                            ! Restore window settings from non-volatile store
  ds_SetApplicationWindow(AppFrame)
  SELF.SetAlerts()
      AppFrame{PROP:TabBarVisible}  = False
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
    INIMgr.Update('Main',AppFrame)                         ! Save window data to non-volatile store
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
    CASE ACCEPTED()
    OF ?Toolbar:Top
    OROF ?Toolbar:PageUp
    OROF ?Toolbar:Up
    OROF ?Toolbar:Locate
    OROF ?Toolbar:Down
    OROF ?Toolbar:PageDown
    OROF ?Toolbar:Bottom
    OROF ?Toolbar:Select
    OROF ?Toolbar:Insert
    OROF ?Toolbar:Change
    OROF ?Toolbar:Delete
    OROF ?Toolbar:History
      IF SYSTEM{PROP:Active} <> THREAD()
        POST(EVENT:Accepted,ACCEPTED(),SYSTEM{Prop:Active} )
        CYCLE
      END
    ELSE
      DO Menu::Menubar                                     ! Process menu items on ?Menubar menu
      DO Menu::FileMenu                                    ! Process menu items on ?FileMenu menu
      DO Menu::EditMenu                                    ! Process menu items on ?EditMenu menu
      DO Menu::BrowseMenu                                  ! Process menu items on ?BrowseMenu menu
      DO Menu::WindowMenu                                  ! Process menu items on ?WindowMenu menu
      DO Menu::HelpMenu                                    ! Process menu items on ?HelpMenu menu
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
    IF EVENT()
       FrameExtension.TakeEvent()
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
      ! Get the EXE version number and global values      ! (c) 2022-2023 Black and White Inc
      !dbg('COMMAND: ' & COMMAND(''))                     ! Catch a command line parameter
      glo:dbugoff = FALSE                                 ! Do not suppress debug messages
      glo:AppVersion = 'Version ' & CLIP(ds_GetFileVersionInfo()) 
      glo:MachineName = clip(ds_GetWorkstationName())
      0{PROP:StatusText,3} = clip(glo:AppVersion)         ! Display the version number in the main status bar
      0{PROP:StatusText,2} = clip(glo:MachineName)        ! Display the workstation name in the main status bar
      !// Get the setting data
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
      glo:AppDescription = set:stDescription
      glo:RootPath = set:RootPath
      glo:FileExtensions = set:FileExtensions
      glo:ExcludeFiles = set:ExcludeFiles
      !dbg(set:GUID)       
        
        post(event:visibleondesktop)
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

