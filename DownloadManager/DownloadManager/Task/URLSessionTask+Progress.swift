//
//  URLSessionTask+Progress.swift
//  DownloadManager
//
//  Created by Omar Allaham on 1/31/19.
//  Copyright © 2019 Martian Bears. All rights reserved.
//

import Foundation

extension URLSessionTask {
    
    func progress() -> Progress {
        
        let progress: Progress
        
        if #available(iOS 11.0, *) {
            
            progress = self.progress
            
        } else {
            
            progress = Progress()
            
            progress.totalUnitCount = countOfBytesExpectedToReceive
            
            progress.completedUnitCount = countOfBytesReceived
        }
        
        return progress
    }
}
