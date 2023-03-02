Backup-DbaDatabase -SqlInstance WIN-K2NV3D17HHC\SERVER1 -Checksum `
-CompressBackup -CreateFolder -Path '\\WIN-K2NV3D17HHC\Backups\WIN-K2NV3D17HHC$SERVER1' `
-Database AdventureWorks_1, AdventureWorks_2, AdventureWorks_3, AdventureWorks_4 -Type Diff `
-FilePath dbname_timestamp.dif -ReplaceInName 






