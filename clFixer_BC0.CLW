  MEMBER('clFixer.clw')

  INCLUDE('ABFILE.INC'),ONCE

  MAP
clFixer_BC0:DctInit    PROCEDURE()
clFixer_BC0:DctKill    PROCEDURE()
clFixer_BC0:FilesInit  PROCEDURE()
  END

Hide:Access:Action   CLASS(FileManager),TYPE               ! FileManager for Action
BindFields             PROCEDURE(),DERIVED
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
PrimeFields            PROCEDURE(),PROC,DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:Action   CLASS(RelationManager),TYPE           ! RelationManager for Action
Init                   PROCEDURE
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:Setting  CLASS(FileManager),TYPE               ! FileManager for Setting
BindFields             PROCEDURE(),DERIVED
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
PrimeFields            PROCEDURE(),PROC,DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:Setting  CLASS(RelationManager),TYPE           ! RelationManager for Setting
Init                   PROCEDURE
Kill                   PROCEDURE(),DERIVED
                     END

Hide:Access:ActionAlias CLASS(FileManager),TYPE            ! FileManager for ActionAlias
Init                   PROCEDURE(),DERIVED
Kill                   PROCEDURE(),DERIVED
UseFile                PROCEDURE(BYTE UseType = UseType:Uses),BYTE,PROC,DERIVED
                     END


Hide:Relate:ActionAlias CLASS(RelationManager),TYPE        ! RelationManager for ActionAlias
Init                   PROCEDURE
Kill                   PROCEDURE(),DERIVED
                     END


_Hide:Access:Action  &Hide:Access:Action,AUTO,THREAD
_Hide:Relate:Action  &Hide:Relate:Action,AUTO,THREAD
_Hide:Access:Setting &Hide:Access:Setting,AUTO,THREAD
_Hide:Relate:Setting &Hide:Relate:Setting,AUTO,THREAD
_Hide:Access:ActionAlias &Hide:Access:ActionAlias,AUTO,THREAD
_Hide:Relate:ActionAlias &Hide:Relate:ActionAlias,AUTO,THREAD


clFixer_BC0:DctInit PROCEDURE()
  CODE
  _Hide:Access:Action &= NEW(Hide:Access:Action)
  _Hide:Relate:Action &= NEW(Hide:Relate:Action)
  _Hide:Access:Setting &= NEW(Hide:Access:Setting)
  _Hide:Relate:Setting &= NEW(Hide:Relate:Setting)
  _Hide:Access:ActionAlias &= NEW(Hide:Access:ActionAlias)
  _Hide:Relate:ActionAlias &= NEW(Hide:Relate:ActionAlias)
  Relate:Action &= _Hide:Relate:Action
  Relate:Setting &= _Hide:Relate:Setting
  Relate:ActionAlias &= _Hide:Relate:ActionAlias


clFixer_BC0:FilesInit PROCEDURE()
  CODE
  _Hide:Relate:Action.Init
  _Hide:Relate:Setting.Init
  _Hide:Relate:ActionAlias.Init


clFixer_BC0:DctKill PROCEDURE()
  CODE
  _Hide:Relate:Action.Kill
  DISPOSE(_Hide:Relate:Action)
  _Hide:Relate:Setting.Kill
  DISPOSE(_Hide:Relate:Setting)
  _Hide:Relate:ActionAlias.Kill
  DISPOSE(_Hide:Relate:ActionAlias)


Hide:Relate:Action.Init PROCEDURE()
  CODE
  _Hide:Access:Action.Init
  SELF.Init(Access:Action,1)


Hide:Access:Action.BindFields PROCEDURE

  CODE
  PARENT.BindFields
  BIND('act:stBefore',act:stBefore)                        ! Bind memo field
  BIND('act:stAfter',act:stAfter)                          ! Bind memo field


Hide:Access:Action.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= act:Record
  SELF.FileNameValue = 'Action'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= Action
  PARENT.Init
  Access:Action &= SELF
  SELF.DoNotAssertOnCloseMisuse = 1  ! ABCDefaults
   IF SELF.File{prop:sqldriver} THEN SELF.create = 0.         ! ABCDefaults


Hide:Access:Action.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:Action &= NULL                                    ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:Action.PrimeFields PROCEDURE

  CODE
  act:StepId = 100                                         ! Assign initial field value
  act:ExcludeFilesYN = 1                                   ! Assign initial field value
  act:LineNo = 0                                           ! Assign initial field value
  act:ReorderNo = 0                                        ! Assign initial field value
  act:DisableYN = 0                                        ! Assign initial field value
  PARENT.PrimeFields


Hide:Access:Action.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(Action,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(act:ActionStepPK,'Primary Key',0)
    SELF.AddKey(act:ActionReorder,'Use this to renumber steps',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  IF SELF.File{prop:sqldriver} THEN SELF.create = 0.          ! ABCDefaults
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:Action.Kill PROCEDURE

  CODE
  _Hide:Access:Action.Kill                                 ! Kill the file manager
  PARENT.Kill
  Relate:Action &= NULL                                    ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:Action)                             ! destroy the file manager


Hide:Relate:Setting.Init PROCEDURE()
  CODE
  _Hide:Access:Setting.Init
  SELF.Init(Access:Setting,1)


Hide:Access:Setting.BindFields PROCEDURE

  CODE
  PARENT.BindFields
  BIND('set:ExcludeFiles',set:ExcludeFiles)                ! Bind memo field


Hide:Access:Setting.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= set:Record
  SELF.FileNameValue = 'Setting'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= Setting
  PARENT.Init
  Access:Setting &= SELF
  SELF.DoNotAssertOnCloseMisuse = 1  ! ABCDefaults
   IF SELF.File{prop:sqldriver} THEN SELF.create = 0.         ! ABCDefaults


Hide:Access:Setting.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:Setting &= NULL                                   ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:Setting.PrimeFields PROCEDURE

  CODE
  set:GUID = glo:st.MakeGuid()                             ! Assign initial field value
  set:RootPath = 'c:\Clarion'                              ! Assign initial field value
  set:FileExtensions = '*.inc;*.clw;*.txa;*.dctx;*.def;*.equ;*.tpl;*.tft;*.xml;*.tpw;*.tpl;' ! Assign initial field value
  PARENT.PrimeFields


Hide:Access:Setting.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(Setting,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(set:SettingPK,'set:SettingPK',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  IF SELF.File{prop:sqldriver} THEN SELF.create = 0.          ! ABCDefaults
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:Setting.Kill PROCEDURE

  CODE
  _Hide:Access:Setting.Kill                                ! Kill the file manager
  PARENT.Kill
  Relate:Setting &= NULL                                   ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:Setting)                            ! destroy the file manager


Hide:Relate:ActionAlias.Init PROCEDURE()
  CODE
  _Hide:Access:ActionAlias.Init
  SELF.Init(Access:ActionAlias,1)
  SELF.SetAlias(Relate:Action)


Hide:Access:ActionAlias.Init PROCEDURE

  CODE
  SELF.Initialized = False
  SELF.Buffer &= act1:Record
  SELF.AliasedFile &= Access:Action                        !This is a File Alias, so assign aliased file manager
  SELF.FileNameValue = 'ActionAlias'
  SELF.SetErrors(GlobalErrors)
  SELF.File &= ActionAlias
  PARENT.Init
  Access:ActionAlias &= SELF
  SELF.DoNotAssertOnCloseMisuse = 1  ! ABCDefaults
   IF SELF.File{prop:sqldriver} THEN SELF.create = 0.         ! ABCDefaults


Hide:Access:ActionAlias.Kill PROCEDURE

  CODE
  PARENT.Kill
  Access:ActionAlias &= NULL                               ! File manager has been destroyed to assign null, it is an error to reference this after this point


Hide:Access:ActionAlias.UseFile PROCEDURE(BYTE UseType = UseType:Uses)

ReturnValue          BYTE,AUTO

  CODE
  IF UseType ~= UseType:Initialize
    SELF.UseFile(UseType:Initialize)                       !Recursive call to ensure initialization takes place
  END
  IF UseType = UseType:Initialize AND ~SELF.Initialized
    SELF.InUseFile = True
    SELF.Init(ActionAlias,GlobalErrors)
    SELF.Create = 1
    SELF.LockRecover = 10
    SELF.AddKey(act1:ActionStepPK,'Primary Key',0)
    SELF.AddKey(act1:ActionReorder,'Use this to renumber steps',0)
  END
                                                           !SELF.InUseFile will be set to False in PARENT
  IF SELF.File{prop:sqldriver} THEN SELF.create = 0.          ! ABCDefaults
  ReturnValue = PARENT.UseFile(UseType)
  RETURN ReturnValue


Hide:Relate:ActionAlias.Kill PROCEDURE

  CODE
  _Hide:Access:ActionAlias.Kill                            ! Kill the file manager
  PARENT.Kill
  Relate:ActionAlias &= NULL                               ! Assign NULL to the RelationManager's FileManager reference, it is an error to reference this after this point
  DISPOSE(_Hide:Access:ActionAlias)                        ! destroy the file manager

