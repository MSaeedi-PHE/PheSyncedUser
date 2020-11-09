//
//  UserIDSyncManager.swift
//
//  Created by Mohamad Saeedi on 17/09/2020.
//  Copyright © 2020 Mohamad Saeedi. All rights reserved.
//

import Foundation

public protocol IDSyncManagerType {
    // call syncId() before accessing userId
    var userId: String? { get }

    // generates id if does not exist and stores it in keychain otherwise returns existing
    func syncId() -> String?

    // clears id in keychain, only use if user wants to reset and remove their usage data
    func clearId()
}

public class UserIDSyncManager: IDSyncManagerType {

    public private(set) var userId: String?
    private let store: IDSecureStoreType

    public init(with store: IDSecureStoreType = IDSecureStore()) {
        self.store = store
    }

    public func syncId() -> String? {
        userId = store.retrieveId()
        if userId == nil {
            let generatedId = UUID().uuidString
            let status = store.save(userId: generatedId)
            guard status == errSecSuccess else { return nil }
            debugPrint("generated and synced new user id")
            userId = generatedId
        } else {
            debugPrint("returned existing user ID")
        }
        return userId
    }

    public func clearId() {
        _ = store.clearId()
    }
}

public protocol IDSecureStoreType {
    func save(userId: String) -> OSStatus
    func retrieveId() -> String?
    func clearId() -> OSStatus
}

public class IDSecureStore: IDSecureStoreType {

    private let userIDKey = "userID"
    private let defaultServiceId = "com.phe.securestore"
    private let accessGroup = "com.phe.sharedAccess"

    private let sharedAccessGroup: String

    public init(with teamId: String = "6KQH7L94KJ") {
        sharedAccessGroup = "\(teamId).\(accessGroup)"
    }

    public func save(userId: String) -> OSStatus {
        guard let idData = userId.data(using: .utf8) else { return errSecInvalidData }
        let attributes = [kSecClass: kSecClassGenericPassword,
                          kSecAttrService: defaultServiceId,
                          kSecAttrAccount: userIDKey,
                          kSecAttrAccessGroup: sharedAccessGroup,
                          kSecValueData: idData] as [String: Any]
        return SecItemAdd(attributes as CFDictionary, nil)
    }

    public func retrieveId() -> String? {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrService: defaultServiceId,
                     kSecAttrAccount: userIDKey,
                     kSecAttrAccessGroup: sharedAccessGroup,
                     kSecReturnData: true] as [String: Any]
        var item: CFTypeRef?
        SecItemCopyMatching(query as CFDictionary, &item)
        guard let data = item as? Data else { return nil }
        return String(decoding: data, as: UTF8.self)
    }

    public func clearId() -> OSStatus {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrService: defaultServiceId,
                     kSecAttrAccount: userIDKey,
                     kSecAttrAccessGroup: sharedAccessGroup] as [String: Any]

        return SecItemDelete(query as CFDictionary)
    }
}
