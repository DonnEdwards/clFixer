  MEMBER('clFixer.clw')

  PRAGMA('define(init_priority=>3)')

  MAP
    MODULE('clFixer_BC0.CLW')
clFixer_BC0:DctInit             PROCEDURE()
clFixer_BC0:DctKill             PROCEDURE()
clFixer_BC0:FilesInit           PROCEDURE()
    END
  END

DctInit PROCEDURE()
  CODE
  clFixer_BC0:DctInit
  clFixer_BC0:FilesInit


DctKill PROCEDURE()
  CODE
  clFixer_BC0:DctKill

