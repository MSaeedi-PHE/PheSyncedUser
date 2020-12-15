//
//  UserIDSyncManagerTests.swift
//  UserIDSyncManagerTests
//
//  Created by Mohamad Saeedi on 09/10/2020.
//  Copyright © 2020 Mohamad Saeedi. All rights reserved.
//

import XCTest
@testable import PheSyncedUser

class UserIDSyncManagerTests: XCTestCase {

    func testNewIdGeneration() {
        let storage = MockIDSecureStore()
        let idGenerator = UserIDSyncManager(with: storage)

        _ = idGenerator.syncId()
        let uid = idGenerator.userId

        XCTAssertNotNil(uid)
    }

    func testExistingID() {
        let storage = MockIDSecureStore()
        storage.storedId = "123456"

        let idGenerator = UserIDSyncManager(with: storage)
        _ = idGenerator.syncId()

        XCTAssertEqual(idGenerator.userId, "123456")
    }
}
