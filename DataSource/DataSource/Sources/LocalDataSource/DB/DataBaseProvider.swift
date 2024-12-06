//
//  DataBaseProvider.swift
//  DataSource
//
//  Created by Jinyoung Yoo on 11/28/24.
//

import Combine

import RealmSwift

public protocol DataBaseProvider {
    func add<T: Object>(_ dataArray: [T]) -> AnyPublisher<Void, DataBaseError>
    func read<T: Object>(objectType: T.Type) -> Results<T>
    func readWithPrimaryKey<T: Object, P>(objectType: T.Type, primaryKey: P) -> T?
    func delete<T: Object>(_ dataArray: [T]) -> AnyPublisher<Void, DataBaseError>
}

//MARK: - DIContainer에서 단일 인스턴스로 유지될 객체
public final class DefaultDataBaseProvider: DataBaseProvider {

    private let realm = try! Realm()
    
    public init() {
        let configuration = Realm.Configuration(schemaVersion: 2)
        Realm.Configuration.defaultConfiguration = configuration
        print("🚧🚧🚧🚧🚧🚧🚧 \(Realm.Configuration.defaultConfiguration.fileURL)")
    }
    
    public func add<T: Object>(_ dataArray: [T]) -> AnyPublisher<Void, DataBaseError> {
        
        return Future<Void, DataBaseError> { [unowned self] promise in
            
            realm.writeAsync {
                self.realm.add(dataArray, update: .modified)
            } onComplete: { error in
                guard error == nil else {
                    promise(.failure(.createError))
                    return
                }
                
                promise(.success(()))
            }
            
        }.eraseToAnyPublisher()
    }

    public func read<T: Object>(objectType: T.Type) -> Results<T> {
        return realm.objects(objectType.self)
    }
    
    public func readWithPrimaryKey<T: Object, P>(objectType: T.Type, primaryKey: P) -> T? {
        return realm.object(ofType: objectType.self, forPrimaryKey: primaryKey)
    }
    
    public func delete<T: Object>(_ dataArray: [T]) -> AnyPublisher<Void, DataBaseError> {
        
        return Future<Void, DataBaseError> { [unowned self] promise in
            
//            guard let realm else { return }
            
            realm.writeAsync {
                self.realm.delete(dataArray)
            } onComplete: { error in
                guard error == nil else {
                    promise(.failure(.deleteError))
                    return
                }
                
                promise(.success(()))
            }
            
        }.eraseToAnyPublisher()
        
    }
}
