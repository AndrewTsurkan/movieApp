import Foundation
import Security

final class KeychainManager {
    static let shared = KeychainManager() ; private init() {}
    
    func savePassword(password: String, for login: String) -> Bool {
         let passwordData = password.data(using: .utf8)!
         
         if isPasswordExists(for: login) {
             return false
         }
         
         let query: [CFString: Any] = [
             kSecClass: kSecClassInternetPassword,
             kSecAttrServer: login,
             kSecValueData: passwordData
         ]
         
         let status = SecItemAdd(query as CFDictionary, nil)
         
         return status == errSecSuccess
     }
    
        func getPassword(for login: String) -> String? {
            let query: [CFString: Any] = [
                kSecClass: kSecClassInternetPassword,
                kSecAttrServer: login,
                kSecReturnData: kCFBooleanTrue!,
                kSecMatchLimit: kSecMatchLimitOne
            ]
            
            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)
            
            if status == errSecSuccess, let data = result as? Data, let password = String(data: data, encoding: .utf8) {
                return password
            } else {
                return nil
            }
        }
        
        func isPasswordExists(for login: String) -> Bool {
            return getPassword(for: login) != nil
        }
}
