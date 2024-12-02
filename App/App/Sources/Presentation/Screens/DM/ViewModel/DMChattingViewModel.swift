//
//  DMChattingViewModel.swift
//  App
//
//  Created by Jinyoung Yoo on 12/2/24.
//

import Combine

import WorkSpace
import Chat
import Common

final class DMChattingViewModel {
    
    @Injected(objectScope: .unique)
    private var chatUseCase: ChatUseCase
    @Injected private var workspaceRepository: WorkspaceRepository
    
    private lazy var wsID = workspaceRepository.getWorkspaceID()!
    private let roomID: String
    private let chatList = CurrentValueSubject<[ChatPresentationModel], Never>([])
    private var textContent = ""
    private var imageContents = [Data]()
    private var cancellable = Set<AnyCancellable>()
    
    init(roomID: String) {
        self.roomID = roomID
    }
    
    deinit {
        chatUseCase.disconnect()
    }
    
    func transform(_ input: Input) -> Output {
        let socketConnectTrigger = PassthroughSubject<Void, ChatError>()
        
        //MARK: - 채팅 데이터 로드
        input.viewDidLoad
            .withUnretained(self)
            .flatMap { owner, _ -> AnyPublisher<[Chat], ChatError> in
                return owner.chatUseCase.loadReadChats(owner.roomID, isPagination: false)
            }
            .withUnretained(self)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("🚨 ", #function, error.errorDescription ?? "")
                }
            } receiveValue: { owner, chats in
                owner.chatList.send(chats.map { ChatPresentationModel.create($0) })
                socketConnectTrigger.send(())
            }.store(in: &cancellable)

        
        //MARK: - 소켓 연결 및 메세지 수신
        Publishers.CombineLatest(
            socketConnectTrigger,
            chatUseCase.receiveChat(roomID, chatType: .dm)
        )
        .withUnretained(self)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .finished: break
            case .failure(let error):
                print("🚨 ", #function, error.errorDescription ?? "")
            }
        } receiveValue: { (owner, tuple) in
            let newChat = ChatPresentationModel.create(tuple.1)
            var chatList = owner.chatList.value
            
            chatList.append(newChat)
            owner.chatList.send(chatList)
        }.store(in: &cancellable)

        input.chatTextContent
            .withUnretained(self)
            .sink { owner, text in
                owner.textContent = text
            }.store(in: &cancellable)
        
        input.chatImageContent
            .withUnretained(self)
            .sink { owner, images in
                owner.imageContents = images
            }.store(in: &cancellable)
        
        
        //MARK: - 전송 로직
        input.sendButtonTapped
            .withUnretained(self)
            .filter { owner, _ in !owner.textContent.isEmpty || !owner.imageContents.isEmpty }
            .withUnretained(self)
            .flatMap { (owner, _) -> AnyPublisher<Chat, ChatError> in
                let chatBody = ChatBody(content: owner.textContent, images: owner.imageContents)

                return owner.chatUseCase.sendChat(owner.wsID, owner.roomID, chat: chatBody, chatType: .dm)
            }
            .withUnretained(self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("🚨 ", #function, error.errorDescription ?? "")
                }
            } receiveValue: { owner, chat in
                let newChat = ChatPresentationModel.create(chat)
                var chatList = owner.chatList.value
                
                chatList.append(newChat)
                owner.chatList.send(chatList)
            }.store(in: &cancellable)

        
        return Output(
            chatList: chatList.eraseToAnyPublisher()
        )
    }
}

extension DMChattingViewModel {
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let sendButtonTapped: AnyPublisher<Void, Never>
        let chatTextContent: AnyPublisher<String, Never>
        let chatImageContent: AnyPublisher<[Data], Never>
    }
    
    struct Output {
        let chatList: AnyPublisher<[ChatPresentationModel], Never>
    }
    
}
