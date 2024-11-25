//
//  ImageCacheManager.swift
//  DataSource
//
//  Created by Jinyoung Yoo on 11/24/24.
//

import Foundation
import UIKit.UIImage
import Combine

import Common

public final class ImageCacheManager {
    
    public static let shared = ImageCacheManager()
    @Injected private var networkProvider: NetworkProvider
    private var cancellable = Set<AnyCancellable>()
    private let diskCache = DiskCache.shared
    private init() {}
    
    public func getImageData(_ imagePath: String) -> AnyPublisher<Data?, Never> {
        return diskCache.load(imagePath: imagePath)
            .withUnretained(self)
            .flatMap { (owner, cachedData) -> AnyPublisher<Data?, Never> in
                
                if let cachedData, let etag = UserDefaults.standard.string(forKey: imagePath) {
                    return owner.synchronizeWithServer(imagePath: imagePath, etag: etag)
                        .map { Optional($0) }
                        .catch { error -> Just<Data?> in
                            print(error.errorDescription ?? "")
                            return Just(cachedData)
                        }.eraseToAnyPublisher()
                    
                } else {
                    
                    return owner.synchronizeWithServer(imagePath: imagePath)
                        .map { Optional($0) }
                        .catch { error -> Just<Data?> in
                            return Just(nil)
                        }.eraseToAnyPublisher()
                    
                }
                
            }.eraseToAnyPublisher()
    }
}

extension ImageCacheManager {
    private func synchronizeWithServer(imagePath: String, etag: String = "") -> AnyPublisher<Data, NetworkError> {

        return Future<Data, NetworkError> { [unowned self] promise in
            
            networkProvider.requestImage(.load(imagePath, etag))
                .withUnretained(self)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        promise(.failure(error))
                    }
                } receiveValue: { owner, imageData in
                    owner.diskCache.save(imagePath: imagePath, data: imageData)
                    promise(.success(imageData))
                }.store(in: &cancellable)
            
        }.eraseToAnyPublisher()
    }
}
