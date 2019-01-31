//
//  DownloadManage.swift
//  DownloadManager
//
//  Created by Omar Allaham on 1/24/19.
//  Copyright © 2019 Martian Bears. All rights reserved.
//

import Foundation

open class DownloadManage: NSObject {
    
    public static let shared: DownloadManage = .init()
    
    public lazy var cache: NSCache<NSURL, NSString> = {
        let item = NSCache<NSURL, NSString>.init()
        
        
       return item
    }()
    
    public var delegateQueue: DispatchQueue = .main
    
    public weak var delegate: DownloadDelegate?
    
    private var _tasks: [URLSessionTask] = []
    
    public var tasks: [URLSessionTask] {
        get {
            return accessQueue.sync {
                return _tasks
            }
        }
        set {
            accessQueue.sync {
                _tasks = newValue
            }
        }
    }
    
    private let accessQueue: DispatchQueue = DispatchQueue(label: "com.MartianBears.DownloadTask.access.queue")
    
    private lazy var operationQueue: OperationQueue = {
        
        let queue = OperationQueue()
        
        queue.name = "com.MartianBears.DownloadTask.operation.queue"
    
        return queue
    }()
    
    public private(set) lazy var config = makeSessionConfig()
    
    lazy var session = makeSession()
    
    public override init() {
        super.init()
    }
    
    public init(_ config: URLSessionConfiguration) {
        super.init()
        
        self.config = config
    }
}

//MARK: Make
extension DownloadManage {
    
    private func makeSessionConfig() -> URLSessionConfiguration {
        
        
        let config = URLSessionConfiguration.default
        
        config.httpMaximumConnectionsPerHost = 3
        
        if #available(iOS 9.0, *) {
            config.shouldUseExtendedBackgroundIdleMode = true
        }
        
        if #available(iOS 11.0, *) {
            config.waitsForConnectivity = true
        }
        
        config.sessionSendsLaunchEvents = true
        
        return .default
    }
    
    private func makeSession() -> URLSession {
        return URLSession(configuration: config, delegate: self, delegateQueue: operationQueue)
    }
}

extension DownloadManage: URLSessionDownloadDelegate {
    
    @objc public
    func urlSession(_ session: URLSession,
                    didBecomeInvalidWithError error: Error?) {
        
        delegateQueue.async { [weak self] in
            
            guard let self = self else { return }
            
            self.delegate?.downloadManage(self, didBecomeInvalidWithError: error)
            
            self.session = self.makeSession()
        }
    }
    
    @objc public
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        
        guard let item = retrieveTask(for: downloadTask.originalRequest) as? RequestItem else { return }
        
        let destinationURL = item.diskURL ?? location
        
        try? FileManager.default.moveItem(at: location, to: destinationURL)
        
        delegate?.downloadManage(self, didFinish: item, with: destinationURL)
    }
    
    
    @objc public
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        
        guard let item = retrieveTask(for: downloadTask.originalRequest) as? RequestItem else { return }
        
        let progress: Progress = .init()
        
        progress.totalUnitCount = totalBytesExpectedToWrite
        
        progress.completedUnitCount = totalBytesWritten
        
        delegate?.downloadManage(self, task: item, progress: progress)
    }
    
    
    @objc public
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didResumeAtOffset fileOffset: Int64,
                    expectedTotalBytes: Int64) {
        
        guard let item = retrieveTask(for: downloadTask.originalRequest) as? RequestItem else { return }
        
        let progress: Progress = .init()
        
        progress.totalUnitCount = expectedTotalBytes
        
        progress.completedUnitCount = fileOffset
        
        delegate?.downloadManage(self, task: item, progress: progress)
        
    }
    
}

extension DownloadManage: URLSessionDataDelegate {
    
//    @objc public
//    func urlSession(_ session: URLSession,
//                    dataTask: URLSessionDataTask,
//                    didReceive response: URLResponse,
//                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {}
    
    @objc public
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
        
        guard let task = retrieveTask(for: dataTask.originalRequest) else { return }
        
        guard let request = task.originalRequest else { return }
        
        delegate?.downloadManage(self, didStart: request)
    }
    
    
    
    @available(iOS 9.0, *)
    @objc public
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome streamTask: URLSessionStreamTask) {
        
        guard let task = retrieveTask(for: dataTask.originalRequest) else { return }
        
        guard let request = task.originalRequest else { return }
        
        delegate?.downloadManage(self, didStart: request)
    }
    
    @objc public
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        guard let task = retrieveTask(for: dataTask.originalRequest) else { return }
        
        guard let request = task.originalRequest else { return }
        
        delegate?.downloadManage(self, task: request, progress: dataTask.progress())
    }
}

extension DownloadManage: URLSessionTaskDelegate {
    
    @objc public
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

        let nsError = error as NSError?
        
        if nsError?.domain == NSURLErrorDomain, nsError?.code == NSURLErrorCancelled {
            
            guard let request = task.originalRequest else { return }
            
            delegate?.downloadManage(self, didCancel: request)
        }
    }
}



