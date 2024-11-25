//
//  DiskCache.swift
//  DataSource
//
//  Created by Jinyoung Yoo on 11/24/24.
//

import Foundation
import Combine

final class DiskCache {
    
//    private let expirationInterval: TimeInterval = 7 * (24 * 60 * 60) // 7일
    static let shared = DiskCache()
    private let expirationInterval: TimeInterval = 60 * 2 // 2분
    private let fileQueue = DispatchQueue(label: "diskCache.fileQueue", attributes: .concurrent)
    private let cacheDirectory: URL = {
        let directory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("DiskCache")
        if !FileManager.default.fileExists(atPath: directory.path) {
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        }
        return directory
    }()
    
    private var cleanupTimer: Timer?
    
    private init() {
        cleanupExpiredFiles()
        
        cleanupTimer = Timer.scheduledTimer(withTimeInterval: 60 * 60 * 2, repeats: true) { [weak self] _ in
            self?.cleanupExpiredFiles()
        }
    }
    
    func save(imagePath: String, data: Data) {
        let fileName = imagePath.replacingOccurrences(of: "/", with: "")
        let fileURL: URL
        
        if #available(iOS 16.0, *) {
            fileURL = cacheDirectory.appending(path: fileName, directoryHint: .notDirectory)
        } else {
            fileURL = cacheDirectory.appendingPathComponent(fileName)
        }
        
        fileQueue.async(flags: .barrier) {
            do {
                try data.write(to: fileURL, options: .atomic)
                try FileManager.default.setAttributes([.modificationDate: Date()], ofItemAtPath: fileURL.path)
                print("DiskCache 저장 성공 - \(fileName)")
            } catch {
                print("DiskCache: 이미지 저장 실패 - \(error)")
            }
        }
    }
    
    func load(imagePath: String) -> AnyPublisher<Data?, Never> {
        let fileName = imagePath.replacingOccurrences(of: "/", with: "")
        let fileURL: URL
        
        if #available(iOS 16.0, *) {
            fileURL = cacheDirectory.appending(path: fileName, directoryHint: .notDirectory)
        } else {
            fileURL = cacheDirectory.appendingPathComponent(fileName)
        }
        
        return Future<Data?, Never> { [unowned self] promise in
            
            fileQueue.async {
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    let data = try? Data(contentsOf: fileURL)
                    print("디스크 캐시 히트")
                    promise(.success(data))
                }
                promise(.success(nil))
            }
            
        }.eraseToAnyPublisher()
    }
    
    private func cleanupExpiredFiles() {
        fileQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: self.cacheDirectory, includingPropertiesForKeys: [.contentModificationDateKey], options: [])
                let now = Date()
                
                for fileURL in fileURLs {
                    let attributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
                    if let modificationDate = attributes[.modificationDate] as? Date {
                        if now.timeIntervalSince(modificationDate) > self.expirationInterval {
                            try FileManager.default.removeItem(at: fileURL)
                            print("DiskCache: 만료된 파일 삭제 - \(fileURL.lastPathComponent)")
                        }
                    }
                }
                print(#function)
            } catch {
                print("DiskCache: 파일 정리 실패 - \(error)")
            }
        }
    }
}
