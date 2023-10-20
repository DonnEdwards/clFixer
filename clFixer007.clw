

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module


   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('CLFIXER007.INC'),ONCE        !Local module procedure declarations
                     END


!!! <summary>
!!! Generated from procedure template - Splash
!!! About Box
!!! </summary>
AboutBox PROCEDURE 

EnhancedFocusManager EnhancedFocusClassType
Window               WINDOW('About Clarion Fixer'),AT(75,75,299,105),FONT('Segoe UI',9),ICON('toolbox.ico'),IMM
                       ENTRY(@s1),AT(61,63),USE(?ENTRY1),FLAT,TRN
                       IMAGE('toolbox.png'),AT(10,13,75,75),USE(?IMAGE1)
                       STRING('clFixer 0.2'),AT(96,13,166),USE(?txtTitle),FONT(,14,,FONT:bold),LEFT,TRN
                       STRING('Freeware copyright © 2023 Black and White Inc'),AT(96,29,197,11),USE(?txtCopyright:2), |
  FONT(,9,,FONT:bold),LEFT,TRN
                       PROMPT('Written by Donn Edwards with lots of help from the ClarionHub and ClarionLive c' & |
  'ommunities.<0DH,0AH>Special thanks to CapeSoft for publishing ABC Defaults, StringTh' & |
  'eory and WinEvents.<0DH,0AH>Toolbox icons created by Roundicons Premium at Flaticon.com'), |
  AT(96,43,193,44),USE(?txtCopyright:3),FONT(,8,,FONT:regular)
                       ENTRY(@s30),AT(94,90,158,10),USE(glo:AppVersion),LEFT,FLAT,MSG('Program Version Number'),READONLY, |
  TIP('Program Version Number'),TRN
                     END

    omit('***',WE::CantCloseNowSetHereDone=1)  !Getting Nested omit compile error, then uncheck the "Check for duplicate CantCloseNowSetHere variable declaration" in the WinEvent local template
WE::CantCloseNowSetHereDone equate(1)
WE::CantCloseNowSetHere     long
    !***
ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
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
  GlobalErrors.SetProcedureName('AboutBox')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?ENTRY1
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  SELF.Open(Window)                                        ! Open window
  Do DefineListboxStyle
  Alert(AltKeyPressed)  ! WinEvent : These keys cause a program to crash on Windows 7 and Windows 10.
  Alert(F10Key)         !
  Alert(CtrlF10)        !
  Alert(ShiftF10)       !
  Alert(CtrlShiftF10)   !
  Alert(AltSpace)       !
  WinAlertMouseZoom()
  WinAlert(WE::WM_QueryEndSession,,Return1+PostUser)
  TARGET{Prop:Timer} = 6000                                ! Close window on timer event, so configure timer
  TARGET{Prop:Alrt,255} = MouseLeft                        ! Alert mouse clicks that will close window
  TARGET{Prop:Alrt,254} = MouseLeft2
  TARGET{Prop:Alrt,253} = MouseRight
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
  GlobalErrors.SetProcedureName
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
    OF EVENT:AlertKey
      CASE KEYCODE()
      OF MouseLeft
      OROF MouseLeft2
      OROF MouseRight
        POST(Event:CloseWindow)                            ! Splash window will close on mouse click
      END
    OF EVENT:LoseFocus
        POST(Event:CloseWindow)                            ! Splash window will close when focus is lost
    OF EVENT:OpenWindow
        post(event:visibleondesktop)
    OF Event:Timer
      POST(Event:CloseWindow)                              ! Splash window will close on event timer
    OF Event:AlertKey
      CASE KEYCODE()                                       ! Splash window will close on mouse click
      OF MouseLeft
      OROF MouseLeft2
      OROF MouseRight
        POST(Event:CloseWindow)
      END
    ELSE
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

