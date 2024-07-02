//
//  Extension + bundle.swift
//  UserList
//
//  Created by paytalab on 5/30/24.
//

import Foundation

extension Bundle {
    
    var apiKey: String? {
        guard let file = self.path(forResource: "Secret", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["AccessToken"] as? String else {
            debugPrint("AQI - API KEY를 가져오는데 실패하였습니다.")
            return nil
        }
        return key
    }
    var googleKey: String? {
        guard let file = self.path(forResource: "Secret", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["GoogleAPIKey"] as? String else {
            debugPrint("Google - API KEY를 가져오는데 실패하였습니다.")
            return nil
        }
        return key
    }
}
