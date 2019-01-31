//
//  DownloadDelegate.swift
//  DownloadManager
//
//  Created by Omar Allaham on 1/24/19.
//  Copyright © 2019 Martian Bears. All rights reserved.
//

import Foundation

//TODO: Documentation needed

public protocol DownloadDelegate: AnyObject {
    
    func downloadManage(_ manager: DownloadManage, didStart task: RequestItem)
    
    func downloadManage(_ manager: DownloadManage, didPause task: RequestItem)
    
    func downloadManage(_ manager: DownloadManage, didResume task: RequestItem)
    
    func downloadManage(_ manager: DownloadManage, didRetry task: RequestItem)
    
    func downloadManage(_ manager: DownloadManage, didCancel task: RequestItem)
    
    func downloadManage(_ manager: DownloadManage, didFinish task: RequestItem, with url: URL)
    
    func downloadManage(_ manager: DownloadManage, didFinish task: RequestItem, with data: Data)
    
    func downloadManage(_ manager: DownloadManage, didFail task: RequestItem, with error: Error)
    
    func downloadManage(_ manager: DownloadManage, task: RequestItem, progress: Progress)
    
    func downloadManage(_ manager: DownloadManage, didBecomeInvalidWithError error: Error?)
}

//MARK: Default implementation

public extension DownloadDelegate {
    
    func downloadManage(_ manager: DownloadManage, didStart task: RequestItem) {}
    
    func downloadManage(_ manager: DownloadManage, didPause task: RequestItem) {}
    
    func downloadManage(_ manager: DownloadManage, didResume task: RequestItem) {}
    
    func downloadManage(_ manager: DownloadManage, didRetry task: RequestItem) {}
    
    func downloadManage(_ manager: DownloadManage, didCancel task: RequestItem) {}
    
    func downloadManage(_ manager: DownloadManage, didFinish task: RequestItem, with url: URL) {}
    
    func downloadManage(_ manager: DownloadManage, didFinish task: RequestItem, with data: Data) {}
    
    func downloadManage(_ manager: DownloadManage, didFail task: RequestItem, with error: Error) {}
    
    func downloadManage(_ manager: DownloadManage, task: RequestItem, progress: Progress) {}
    
    func downloadManage(_ manager: DownloadManage, didBecomeInvalidWithError error: Error?) {}
}
