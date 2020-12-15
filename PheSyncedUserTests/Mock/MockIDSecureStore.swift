//
//  MockIDSecureStore.swift
//  PheSyncedUserTests
//
//  Created by Mohamad Saeedi on 09/11/2020.
//  Copyright © 2020 Mohamad Saeedi. All rights reserved.
//

import Foundation
@testable import PheSyncedUser

class MockIDSecureStore: IDSecureStoreType {

    var storedId: String?

    func save(userId: String) -> OSStatus {
        storedId = userId
        return errSecSuccess
    }

    func retrieveId() -> String? {
        return storedId
    }

    func clearId() -> OSStatus {
        storedId = nil
        return errSecSuccess
    }
}
