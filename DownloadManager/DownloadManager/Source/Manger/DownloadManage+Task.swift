//
//  DownloadManage+Task.swift
//  DownloadManager
//
//  Created by Omar Allaham on 1/31/19.
//  Copyright © 2019 Martian Bears. All rights reserved.
//

import Foundation

extension DownloadManage {
    
    public func retrieveTask(for request: URLRequest?) -> URLSessionTask? {
        
        let found = tasks.first { $0.originalRequest == request }
        
        return found
    }
    
    public func retrieveTask(for item: RequestItem) -> URLSessionTask? {
        
        return retrieveTask(for: item.requestItemRequest)
    }
    
    func makeDownloadTask(of item: RequestItem) -> URLSessionTask? {
        
        guard let request = item.requestItemRequest else { return nil }
        
        if let found = retrieveTask(for: item) { return found }
        
        let task = session.downloadTask(with: request)
        
        tasks.append(task)
        
        return task
    }
    
    func makeDataTask(of item: RequestItem) -> URLSessionTask? {
        
        guard let request = item.requestItemRequest else { return nil }
        
        if let found = retrieveTask(for: item) { return found }
        
        let task = session.dataTask(with: request)
        
        tasks.append(task)
        
        return task
    }
    
    public func download(_ item: RequestItem, to url: URL, priority: Float = URLSessionTask.defaultPriority) -> URLSessionTask? {
        
        var item = item
        
        item.diskURL = url
        
        guard let task = makeDownloadTask(of: item) else { return nil }
        
        task.priority = priority
        
        task.resume()
        
        return task
    }
    
    public func download(_ item: RequestItem, priority: Float = URLSessionTask.defaultPriority) -> URLSessionTask? {
        
        guard let task = makeDataTask(of: item) else { return nil }
        
        task.priority = priority
        
        task.resume()
        
        return task
    }
    
    public func cancel(_ item: RequestItem) {
        
        guard let task = retrieveTask(for: item) else { return }
        
        task.cancel()
    }
    
    public func resume(_ item: RequestItem) {
        
        guard let task = retrieveTask(for: item) else { return }
        
        task.resume()
    }
    
    public func suspend(_ item: RequestItem) {
        
        guard let task = retrieveTask(for: item) else { return }
        
        task.suspend()
    }
}
