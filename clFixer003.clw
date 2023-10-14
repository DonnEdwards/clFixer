

   MEMBER('clFixer.clw')                                   ! This is a MEMBER module


   INCLUDE('ABBROWSE.INC'),ONCE
   INCLUDE('ABPOPUP.INC'),ONCE
   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('CLFIXER003.INC'),ONCE        !Local module procedure declarations
                       INCLUDE('CLFIXER006.INC'),ONCE        !Req'd for module callout resolution
                     END


!!! <summary>
!!! Generated from procedure template - Window
!!! Browse the Setting table
!!! </summary>
BrowseSetting PROCEDURE 

udpt            UltimateDebugProcedureTracker
CurrentTab           STRING(80)                            ! 
BRW1::View:Browse    VIEW(Setting)
                       PROJECT(set:GUID)
                       PROJECT(set:stDescription)
                       PROJECT(set:RootPath)
                       PROJECT(set:FileExtensions)
                     END
Queue:Browse:1       QUEUE                            !Queue declaration for browse/combo box using ?Browse:1
set:GUID               LIKE(set:GUID)                 !List box control field - type derived from field
set:stDescription      LIKE(set:stDescription)        !List box control field - type derived from field
set:RootPath           LIKE(set:RootPath)             !List box control field - type derived from field
set:FileExtensions     LIKE(set:FileExtensions)       !List box control field - type derived from field
Mark                   BYTE                           !Entry's marked status
ViewPosition           STRING(1024)                   !Entry's view position
                     END
QuickWindow          WINDOW('Browse the Setting table'),AT(,,328,198),FONT('Segoe UI',8,,FONT:regular,CHARSET:DEFAULT), |
  RESIZE,CENTER,ICON('toolbox.ico'),GRAY,IMM,MDI,HLP('BrowseSetting'),SYSTEM
                       LIST,AT(8,30,312,124),USE(?Browse:1),HVSCROLL,FORMAT('80L(2)|M~GUID~L(2)@s36@80L(2)|M~D' & |
  'escription~L(2)@s50@80L(2)|M~Root Path~L(2)@s255@80L(2)|M~File Extensions~L(2)@s250@'), |
  FROM(Queue:Browse:1),IMM,MSG('Browsing the Setting table')
                       BUTTON('&View'),AT(112,158,49,14),USE(?View:2),LEFT,ICON('WAVIEW.ICO'),FLAT,MSG('View Record'), |
  TIP('View Record')
                       BUTTON('&Insert'),AT(165,158,49,14),USE(?Insert:3),LEFT,ICON('WAINSERT.ICO'),FLAT,MSG('Insert a Record'), |
  TIP('Insert a Record')
                       BUTTON('&Change'),AT(218,158,49,14),USE(?Change:3),LEFT,ICON('WACHANGE.ICO'),DEFAULT,FLAT, |
  MSG('Change the Record'),TIP('Change the Record')
                       BUTTON('&Delete'),AT(271,158,49,14),USE(?Delete:3),LEFT,ICON('WADELETE.ICO'),FLAT,MSG('Delete the Record'), |
  TIP('Delete the Record')
                       SHEET,AT(4,4,320,172),USE(?CurrentTab)
                         TAB('&1) SettingPK'),USE(?Tab:2)
                         END
                       END
                       BUTTON('&Close'),AT(222,180,49,14),USE(?Close),LEFT,ICON('WACLOSE.ICO'),FLAT,MSG('Close Window'), |
  TIP('Close Window')
                       BUTTON('&Help'),AT(275,180,49,14),USE(?Help),LEFT,ICON('WAHELP.ICO'),FLAT,MSG('See Help Window'), |
  STD(STD:Help),TIP('See Help Window')
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
Run                    PROCEDURE(USHORT Number,BYTE Request),BYTE,PROC,DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
BRW1                 CLASS(BrowseClass)                    ! Browse using ?Browse:1
Q                      &Queue:Browse:1                !Reference to browse queue
Init                   PROCEDURE(SIGNED ListBox,*STRING Posit,VIEW V,QUEUE Q,RelationManager RM,WindowManager WM)
                     END

BRW1::Sort0:Locator  StepLocatorClass                      ! Default Locator
BRW1::Sort0:StepClass StepStringClass                      ! Default Step Manager
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
        udpt.Init(UD,'BrowseSetting','clFixer003.clw','clFixer.EXE','09/25/2023 @ 06:29PM')    
             
  GlobalErrors.SetProcedureName('BrowseSetting')
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
  Relate:Setting.Open()                                    ! File Setting used by this procedure, so make sure it's RelationManager is open
  SELF.FilesOpened = True
  BRW1.Init(?Browse:1,Queue:Browse:1.ViewPosition,BRW1::View:Browse,Queue:Browse:1,Relate:Setting,SELF) ! Initialize the browse manager
  SELF.Open(QuickWindow)                                   ! Open window
  Do DefineListboxStyle
  QuickWindow{Prop:Alrt,255} = CtrlShiftP
  BRW1.Q &= Queue:Browse:1
  BRW1::Sort0:StepClass.Init(+ScrollSort:AllowAlpha,ScrollBy:Runtime) ! Moveable thumb based upon set:GUID for sort order 1
  BRW1.AddSortOrder(BRW1::Sort0:StepClass,set:SettingPK)   ! Add the sort order for set:SettingPK for sort order 1
  BRW1.AddLocator(BRW1::Sort0:Locator)                     ! Browse has a locator for sort order 1
  BRW1::Sort0:Locator.Init(,set:GUID,1,BRW1)               ! Initialize the browse locator using  using key: set:SettingPK , set:GUID
  BRW1.AddField(set:GUID,BRW1.Q.set:GUID)                  ! Field set:GUID is a hot field or requires assignment from browse
  BRW1.AddField(set:stDescription,BRW1.Q.set:stDescription) ! Field set:stDescription is a hot field or requires assignment from browse
  BRW1.AddField(set:RootPath,BRW1.Q.set:RootPath)          ! Field set:RootPath is a hot field or requires assignment from browse
  BRW1.AddField(set:FileExtensions,BRW1.Q.set:FileExtensions) ! Field set:FileExtensions is a hot field or requires assignment from browse
  Resizer.Init(AppStrategy:Surface,Resize:SetMinSize)      ! Controls like list boxes will resize, whilst controls like buttons will move
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  INIMgr.Fetch('BrowseSetting',QuickWindow)                ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  BRW1.AskProcedure = 1                                    ! Will call: UpdateSetting
  BRW1.AddToolbarTarget(Toolbar)                           ! Browse accepts toolbar control
  BRW1.ToolbarItem.HelpButton = ?Help
  SELF.SetAlerts()
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.FilesOpened
    Relate:Setting.Close()
  END
  IF SELF.Opened
    INIMgr.Update('BrowseSetting',QuickWindow)             ! Save window data to non-volatile store
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
    UpdateSetting
    ReturnValue = GlobalResponse
  END
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
  ReturnValue = PARENT.TakeEvent()
     IF KEYCODE()=CtrlShiftP AND EVENT() = Event:PreAlertKey
       CYCLE
     END
     IF KEYCODE()=CtrlShiftP  
        UD.ShowProcedureInfo('BrowseSetting',UD.SetApplicationName('clFixer','EXE'),QuickWindow{PROP:Hlp},'09/25/2023 @ 06:29PM','09/25/2023 @ 06:29PM','09/25/2023 @ 07:33PM')  
    
       CYCLE
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


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window

