

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module


   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('CLFIXER009.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Window
!!! System Diagnostics from CapeSoft WinEvents
!!! </summary>
SystemInfo PROCEDURE 


! This window shamelessly copied from the CapeSoft WinEvent demo program, written by Bruce Johnson
! Copyright (c) CapeSoft
! Minor layout tweaks by Donn Edwards and removal of several options to simplify
LocalRequest         LONG                                  ! 
SwapUsed             ULONG                                 ! 
SwapFree             ULONG                                 ! 
SwapTotal            ULONG                                 ! 
RamFree              ULONG                                 ! 
RamUsed              ULONG                                 ! 
RamTotal             ULONG                                 ! 
VirtualUsed          ULONG                                 ! 
VirtualFree          ULONG                                 ! 
VirtualTotal         ULONG                                 ! 
UserMemory           ULONG                                 ! 
FilesOpened          BYTE                                  ! 
WinVer               BYTE                                  ! 
WinRel               BYTE                                  ! 
DosVer               BYTE                                  ! 
DosRel               BYTE                                  ! 
allver               ULONG                                 ! 
DiskFree             REAL                                  ! 
DiskTotal            REAL                                  ! 
ThisMachine          STRING(30)                            ! 
NewWinVersion        STRING(60)                            ! 
MyDocuments          STRING(80)                            ! 
MyPictures           STRING(80)                            ! 
Desktop              STRING(80)                            ! 
WindowsFolder        STRING(80)                            ! 
SystemFolder         STRING(80)                            ! 
WorkStation          STRING(252)                           ! 
UserName             STRING(252)                           ! 
UserAccountName      STRING(252)                           ! 
RegistryKey          STRING(50)                            ! 
RegistryKeyLong      LONG                                  ! 
KeyPath              STRING('Software\CapeSoft\WinEventDemo {222}') ! 
ValueName            STRING('Test {96}')                   ! 
Value                STRING(100)                           ! 
KeyType              STRING('WE::REG_SZ {10}')             ! 
KeyTypeLong          LONG                                  ! 
ScreenWidth          STRING(20)                            ! 
ScreenHeight         LONG                                  ! 
ScreenDepth          LONG                                  ! 
ScreenxDPI           LONG                                  ! 
ScreenyDPI           LONG                                  ! 
IsMediaCenter        LONG                                  ! 
IsTerminalServer     LONG                                  ! 
IsTablet             LONG                                  ! 
IsStarter            LONG                                  ! 
OnNetwork            LONG                                  ! 
OsBits               LONG                                  ! 
EnhancedFocusManager EnhancedFocusClassType
window               WINDOW('WinEvent System Info'),AT(,,301,227),FONT('Segoe UI',10,,FONT:regular),DOUBLE,CENTER, |
  ICON('System.ico'),IMM,SYSTEM
                       BUTTON(' Close'),AT(238,200,54),USE(?Close),LEFT,ICON('System.ico')
                       STRING('Windows Version:'),AT(13,26,83),USE(?String1),RIGHT
                       STRING(@s3),AT(102,26),USE(WinVer),LEFT
                       STRING('Release:'),AT(126,26),USE(?String3)
                       STRING(@s3),AT(157,26,17,10),USE(WinRel)
                       STRING(@s3),AT(157,37),USE(DosRel)
                       PROMPT('Windows Version Name:'),AT(13,13,83),USE(?NewWinVersion:Prompt),RIGHT
                       STRING(@s60),AT(102,13,187),USE(NewWinVersion),TRN
                       STRING('Available Space (C:):'),AT(13,57,83),USE(?String10),RIGHT
                       STRING(@n13),AT(102,57),USE(DiskFree),RIGHT
                       PROMPT('MB'),AT(170,57,26),USE(?Prompt2)
                       STRING('Maximum Capacity (C:):'),AT(13,69,83),USE(?String12),RIGHT
                       STRING(@n13),AT(102,69),USE(DiskTotal),RIGHT
                       PROMPT('MB'),AT(170,69,26),USE(?Prompt3)
                       STRING('Memory Used by this program (Kb):'),AT(21,90,133),USE(?String30),FONT(,,COLOR:Navy), |
  RIGHT
                       STRING(@n13),AT(154,90),USE(UserMemory),FONT(,,COLOR:Navy),RIGHT
                       STRING('Memory Analysis for the whole machine (in Kb)'),AT(21,101),USE(?String28),FONT(,,COLOR:Navy)
                       STRING('Total'),AT(122,111,23),USE(?String25),FONT(,,COLOR:Navy,FONT:regular,CHARSET:ANSI), |
  RIGHT
                       STRING('Free'),AT(259,111,23),USE(?String27),FONT(,,COLOR:Navy,FONT:regular,CHARSET:ANSI), |
  RIGHT
                       STRING('Physical Ram:'),AT(19,121,65),USE(?String29),FONT(,,COLOR:Navy,FONT:regular,CHARSET:ANSI), |
  RIGHT
                       STRING(@n13),AT(89,121),USE(RamTotal),FONT(,,COLOR:Navy),RIGHT
                       STRING(@n13),AT(154,121),USE(RamUsed),FONT(,,COLOR:Navy),RIGHT
                       STRING(@n13),AT(227,121),USE(RamFree),FONT(,,COLOR:Navy),RIGHT
                       STRING('Swap File:'),AT(19,132,65),USE(?String31),FONT(,,COLOR:Navy,FONT:regular,CHARSET:ANSI), |
  RIGHT
                       STRING(@n13),AT(89,132),USE(SwapTotal),FONT(,,COLOR:Navy),RIGHT
                       STRING(@n13),AT(154,132),USE(SwapUsed),FONT(,,COLOR:Navy),RIGHT
                       STRING(@n13),AT(227,132),USE(SwapFree),FONT(,,COLOR:Navy),RIGHT
                       STRING('Virtual Memory:'),AT(19,143,65),USE(?String32),FONT(,,COLOR:Navy,FONT:regular,CHARSET:ANSI), |
  RIGHT
                       STRING(@n13),AT(89,143),USE(VirtualTotal),FONT(,,COLOR:Navy),RIGHT
                       STRING(@n13),AT(154,143),USE(VirtualUsed),FONT(,,COLOR:Navy),RIGHT
                       STRING(@n13),AT(227,143),USE(VirtualFree),FONT(,,COLOR:Navy),RIGHT
                       PROMPT('Screen Width:'),AT(34,174,79),USE(?ScreenWidth:Prompt),RIGHT
                       STRING(@n-14),AT(112,173),USE(ScreenWidth),RIGHT(1)
                       STRING('Used'),AT(186,111,23),USE(?String26),FONT(,,COLOR:Navy,FONT:regular,CHARSET:ANSI), |
  RIGHT
                       STRING('Release:'),AT(126,37),USE(?String3:2)
                       STRING(@s3),AT(102,37),USE(DosVer),LEFT
                       STRING('Dos Version:'),AT(13,37,83),USE(?String1:2),RIGHT
                       PROMPT('Screen Height:'),AT(34,185,79),USE(?ScreenHeight:Prompt),RIGHT
                       STRING(@n-14),AT(112,185),USE(ScreenHeight),RIGHT(1)
                       PROMPT('Screen Depth:'),AT(34,197,79),USE(?ScreenDepth:Prompt),RIGHT
                       STRING(@n-14),AT(112,197),USE(ScreenDepth),RIGHT(1)
                       PROMPT('Screenx DPI:'),AT(34,162,79),USE(?ScreenxDPI:Prompt),RIGHT
                       STRING(@n-14),AT(112,162),USE(ScreenxDPI),RIGHT(1)
                       STRING(@n-14),AT(185,162),USE(ScreenyDPI)
                       STRING('OS Bits:'),AT(185,37),USE(?STRING2)
                       STRING(@n3),AT(215,37),USE(OsBits)
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
  GlobalErrors.SetProcedureName('SystemInfo')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Close
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
    NewWinVersion = ds_GetWinVersion()
    WinVer = WindowsVersion()
    WinRel = WindowsRelease()
    DosVer = DosVersion()
    DosRel = DosRelease()
    DiskFree = ds_GetDiskMegs('c:','User Free')
    DiskTotal = ds_GetDiskMegs('c:','Total')
  
    SwapUsed     = ds_Memory('SWAP USED')
    SwapFree     = ds_Memory('SWAP FREE')
    SwapTotal    = ds_Memory('SWAP TOTAL')
    RamFree      = ds_Memory('RAM FREE')
    RamUsed      = ds_Memory('RAM USED')
    RamTotal     = ds_Memory('RAM TOTAL')
    VirtualUsed  = ds_Memory('VMEM USED')
    VirtualFree  = ds_Memory('VMEM FREE')
    VirtualTotal = ds_Memory('VMEM TOTAL')
    UserMemory   = ds_Memory('USER')
  
    ScreenyDPI = ds_GetScreenDPI(1)
    ScreenxDPI = ds_GetScreenDPI()
    ScreenWidth = ScreenWidth()
    ScreenHeight = ScreenHeight()
    ScreenDepth = ScreenDepth()
    OsBits = ds_OsBits()
  SELF.Open(window)                                        ! Open window
  Do DefineListboxStyle
  Alert(AltKeyPressed)  ! WinEvent : These keys cause a program to crash on Windows 7 and Windows 10.
  Alert(F10Key)         !
  Alert(CtrlF10)        !
  Alert(ShiftF10)       !
  Alert(CtrlShiftF10)   !
  Alert(AltSpace)       !
  WinAlertMouseZoom()
  WinAlert(WE::WM_QueryEndSession,,Return1+PostUser)
  INIMgr.Fetch('SystemInfo',window)                        ! Restore window settings from non-volatile store
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
    INIMgr.Update('SystemInfo',window)                     ! Save window data to non-volatile store
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
    OF ?Close
       POST(EVENT:CloseWindow)
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

