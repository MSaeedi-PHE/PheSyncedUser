# PheSyncedUser
Generate unique user Id and sync across PHE apps

How to use

1 - include PheSyncedUser in the podfile using: pod 'PheSyncedUser'
2 - call pod install
3 - Click on project name in project navigator then switch to Signing & Capabilities section
4 - Add "Keychain Sharing" capability if it does not exist already by click "+ Capablility"
5 - Add Keychain Access Group by clicking + sign at the bottom of Keychain Groups section
6 - Enter "com.phe.sharedAccess" as the name for the access group

7 - import PheSyncedUser into swift file 
8 - call syncId() on UserIDSyncManager object before accessing userId

        let idManager = UserIDSyncManager()
        let userId = idManager.syncId()

        also  print(idManager.userId)
