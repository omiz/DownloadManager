//
//  DownloadItem.swift
//  DownloadManager
//
//  Created by Omar Allaham on 1/24/19.
//  Copyright © 2019 Martian Bears. All rights reserved.
//

import Foundation

public typealias HTTPHeader = [String: String]

public protocol RequestItem {
    
    var requestItemURL: URL? { get }
    
    var requestItemRequest: URLRequest? { get }
    
    var requestItemTitle: String? { get }
    
    var HttpHeaders: HTTPHeader? { get }
    
    var HttpMethod: HTTPMethod { get }
    
    var allowsCellularAccess: Bool { get }
    
    var cachePolicy: URLRequest.CachePolicy { get }

    var networkServiceType: URLRequest.NetworkServiceType { get }
}

fileprivate var diskURLKey: UInt8 = 0

extension RequestItem {
    
    internal var diskURL: URL? {
        get { return objc_getAssociatedObject(self, &diskURLKey) as? URL }
        set { objc_setAssociatedObject(self, &diskURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    public var requestItemTitle: String? {
        
        return requestItemURL?.lastPathComponent
    }
    
    public var requestItemRequest: URLRequest? {
        
        guard let url = requestItemURL else { return nil }
        
        var request = URLRequest(url: url)
        
        update(&request)
        
        return request
    }

    public var HttpHeaders: HTTPHeader? {
        
        return nil
    }
    
    public var HttpMethod: HTTPMethod {
        
        return .get
    }
    
    public var allowsCellularAccess: Bool {
        
        return true
    }
    
    public var cachePolicy: URLRequest.CachePolicy {
        
        return .reloadIgnoringLocalCacheData
    }
    
    public var networkServiceType: URLRequest.NetworkServiceType {
        
        return URLRequest.NetworkServiceType.default
    }
    
    internal func update(_ request: inout URLRequest) {
        
        request.httpMethod = HttpMethod.value
        
        request.allHTTPHeaderFields = HttpHeaders
        
        request.allowsCellularAccess = allowsCellularAccess
        
        request.cachePolicy = cachePolicy
        
        request.networkServiceType = networkServiceType
    }
}

extension String: RequestItem {
    
    public var requestItemURL: URL? {
        return URL(string: self)
    }
}

extension URL: RequestItem {
    
    public var requestItemURL: URL? {
        return self
    }
}

extension URLRequest: RequestItem {
    
    public var requestItemURL: URL? {
        return self.url
    }
    
    public var requestItemRequest: URLRequest? {
        return self
    }
    
    public var HttpHeaders: HTTPHeader? {
        
        return allHTTPHeaderFields
    }
    
    public var HttpMethod: HTTPMethod {
        
        return HTTPMethod(httpMethod ?? "") ?? .get
    }
}
