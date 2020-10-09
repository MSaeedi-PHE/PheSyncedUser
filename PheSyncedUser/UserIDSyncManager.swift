//
//  UserIDSyncManager.swift
//
//  Created by Mohamad Saeedi on 17/09/2020.
//  Copyright © 2020 Mohamad Saeedi. All rights reserved.
//

import Foundation

public protocol IDSyncManagerType {
    var userId: String? { get }

    // generates id if does not exist and stores it in keychain otherwise returns existing
    func syncId() -> String?

    // clears id in keychain, only use if user wants to reset and remove their usage data
    func clearId() -> OSStatus
}

public class UserIDSyncManager: IDSyncManagerType {

    private let userIDKey = "userID"
    private let defaultServiceId = "com.phe.securestore"
    private let sharedAccessGroup = "6KQH7L94KJ.com.phe.sharedAccess"

    public private(set) var userId: String?

    public func syncId() -> String? {
        userId = retrieveId()
        if userId == nil {
            let generatedId = UUID().uuidString
            let status = save(id: generatedId)
            guard status == errSecSuccess else { return nil }
            debugPrint("generated and synced new user id")
            userId = generatedId
        } else {
            debugPrint("returned existing user ID")
        }
        return userId
    }

    public func clearId() -> OSStatus {
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrService: defaultServiceId,
                     kSecAttrAccount: userIDKey,
                     kSecAttrAccessGroup: sharedAccessGroup] as [String: Any]

        return SecItemDelete(query as CFDictionary)
    }
}

private extension UserIDSyncManager {
    private func save(id: String) -> OSStatus {
        let idData = id.data(using: .utf8)
        guard let id = idData else { return errSecInvalidData }
        let attributes = [kSecClass: kSecClassGenericPassword,
                          kSecAttrService: defaultServiceId,
                          kSecAttrAccount: userIDKey,
                          kSecAttrAccessGroup: sharedAccessGroup,
                          kSecValueData: id] as [String: Any]
        return SecItemAdd(attributes as CFDictionary, nil)
    }

    private func retrieveId() -> String? {
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
}
