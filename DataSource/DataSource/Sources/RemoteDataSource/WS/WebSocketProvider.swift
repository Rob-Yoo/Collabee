//
//  WebSocketProvider.swift
//  DataSource
//
//  Created by Jinyoung Yoo on 11/28/24.
//

import Combine

import SocketIO

public protocol WebSocketProvider {
    func establishConnection(router: WSRouter)
    func closeConnection()
    func receive<R: Decodable>(_ router: WSRouter, responseType: R.Type) -> AnyPublisher<R, WebSocketError>
}


// MARK: - DIContainer에 의해서 싱글턴으로 공유될 객체
public final class DefaultWebSocketProvider: WebSocketProvider {
    private let manager = SocketManager(socketURL: URL(string: Literal.Secret.SocketURL)!, config: [.compress, .log(true)])
    private var ws: SocketIOClient
    
    public init() {
        ws = manager.defaultSocket
        ws.on(clientEvent: .connect) { data, ack in
            print("웹소켓 연결 성공", data, ack)
        }
        
        ws.on(clientEvent: .disconnect) { data, ack in
            print("웹소켓 연결 끊김", data, ack)
        }
    }
    
    public func establishConnection(router: WSRouter) {
        ws = self.manager.socket(forNamespace: router.nameSpace)
        ws.connect()
    }
    
    public func closeConnection() {
        ws.disconnect()
    }
    
    public func receive<R: Decodable>(_ router: WSRouter, responseType: R.Type) -> AnyPublisher<R, WebSocketError> {
        
        return Future<R, WebSocketError> { [unowned self] promise in
            
            ws.on(router.event) { stream, ack in
                
                guard let data = stream.first,
                      let jsonData = try? JSONSerialization.data(withJSONObject: data),
                      let decodedData = try? JSONDecoder().decode(R.self, from: jsonData) else {
                    promise(.failure(.decodeFailure))
                    return
                }
                
                promise(.success(decodedData))
            }
            
        }.eraseToAnyPublisher()
        
    }
}
