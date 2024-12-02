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
    func update<T: Object>(_ dataArray: [T]) -> AnyPublisher<Void, DataBaseError>
    func delete<T: Object>(_ dataArray: [T]) -> AnyPublisher<Void, DataBaseError>
}

//MARK: - DIContainer에서 단일 인스턴스로 유지될 객체
public final class DefaultDataBaseProvider: DataBaseProvider {
    private let realmQueue = DispatchQueue(label: "realmQueue", autoreleaseFrequency: .workItem)

    public init() {
        let configuration = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = configuration
    }
    
    public func add<T: Object>(_ dataArray: [T]) -> AnyPublisher<Void, DataBaseError> {
        
        return Future<Void, DataBaseError> { [unowned self] promise in
            
            realmQueue.async {
                
                guard let realm = try? Realm() else { return }
                
                do {
                    try realm.write {
                        realm.add(dataArray)
                    }
                    realm.refresh()
                    promise(.success(()))
                } catch {
                    promise(.failure(.createError))
                }
                
            }
            
        }.eraseToAnyPublisher()
    }

    public func read<T: Object>(objectType: T.Type) -> Results<T> {
        let realm = try! Realm()
        return realm.objects(objectType.self)
    }
    
    public func readWithPrimaryKey<T: Object, P>(objectType: T.Type, primaryKey: P) -> T? {
        let realm = try! Realm()
        
        return realm.object(ofType: objectType.self, forPrimaryKey: primaryKey)
    }
    
    public func update<T: Object>(_ dataArray: [T]) -> AnyPublisher<Void, DataBaseError> {
        
        return Future<Void, DataBaseError> { [unowned self] promise in
            
            realmQueue.async {
                
                guard let realm = try? Realm() else { return }
                
                do {
                    try realm.write {
                        realm.add(dataArray, update: .modified)
                    }
                    realm.refresh()
                    promise(.success(()))
                } catch {
                    promise(.failure(.updateError))
                }
            }
            
        }.eraseToAnyPublisher()
    
    }
    
    public func delete<T: Object>(_ dataArray: [T]) -> AnyPublisher<Void, DataBaseError> {
        
        return Future<Void, DataBaseError> { [unowned self] promise in
            
            realmQueue.async {
                
                guard let realm = try? Realm() else { return }
                
                do {
                    try realm.write {
                        realm.delete(dataArray)
                    }
                    realm.refresh()
                    promise(.success(()))
                } catch {
                    promise(.failure(.deleteError))
                }
            }
            
        }.eraseToAnyPublisher()
        
    }
}
