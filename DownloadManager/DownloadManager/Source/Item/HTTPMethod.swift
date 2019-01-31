//
//  HTTPMethod.swift
//  DownloadManager
//
//  Created by Omar Allaham on 1/24/19.
//  Copyright © 2019 Martian Bears. All rights reserved.
//

import Foundation

@objc
public enum HTTPMethod: Int, CaseIterable {
    case connect
    case delete
    case get
    case head
    case options
    case patch
    case post
    case put
    case trace
}

extension HTTPMethod {
    
    init?(_ stringValue: String) {
        
        let value = stringValue.uppercased()
        
        let allCases: [HTTPMethod] = HTTPMethod.allCases.compactMap { $0 }
        
        guard let item = allCases.first(where: { $0.description == value }) else { return nil }
        
        self.init(rawValue: item.rawValue)
    }
    
    var value: String {
        
        switch self {
        
        case .connect: return "CONNECT"
        
        case .delete: return "DELETE"
        
        case .get: return "GET"
        
        case .head: return "HEAD"
        
        case .options: return "OPTIONS"
        
        case .patch: return "PATCH"
        
        case .post: return "POST"
        
        case .put: return "PUT"
        
        case .trace: return "TRACE"
        }
    }
}

extension HTTPMethod: CustomStringConvertible {
    
    public var description: String {
        
        return value
    }
}
