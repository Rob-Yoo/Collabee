//
//  DMListViewModel.swift
//  App
//
//  Created by Jinyoung Yoo on 11/27/24.
//

import Combine

import WorkSpace
import Chat
import DataSource
import Common

final class DMListViewModel {
    
    @Injected private var memberRepository: WorkspaceMemberRepository
    @Injected private var workspaceRepository: WorkspaceRepository
    
    @Injected(objectScope: .unique)
    private var chatUseCase: ChatUseCase
    
    private var cancellable = Set<AnyCancellable>()
    
    private lazy var workspaceID = workspaceRepository.getWorkspaceID() ?? ""
    private let dmRoomList = CurrentValueSubject<[DMRoomPresentationModel], Never>([])
    private let memberList = CurrentValueSubject<[Member], Never>([])
    
    func transform(_ input: Input) -> Output {
        let workspaceSubject = PassthroughSubject<Workspace, Never>()
        let chatRoomList = CurrentValueSubject<[ChatRoom], Never>([])
        let willlEnterRoom = PassthroughSubject<ChatRoom, Never>()

        input.viewWillAppear
            .withUnretained(self)
            .flatMap { (owner, _) ->AnyPublisher<Workspace, WorkspaceError> in
                owner.workspaceRepository.fetchWorkSpace(owner.workspaceID)
            }
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(#function, "🚨 \(error.errorDescription ?? "")")
                }
            } receiveValue: { workspace in
                workspaceSubject.send(workspace)
            }.store(in: &cancellable)
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { (owner, _) -> AnyPublisher<[Member], WorkspaceMemberError> in
                owner.memberRepository.fetchMemberList(owner.workspaceID)
                    .map { $0.filter { $0.id != UserDefaultsStorage.userID } }
                    .eraseToAnyPublisher()
            }
            .withUnretained(self)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("🚨 ", #function, error.errorDescription ?? "")
                }
            } receiveValue: { owner, members in
                owner.memberList.send(members)
            }.store(in: &cancellable)
        
        input.viewWillAppear
            .withUnretained(self)
            .flatMap { (owner, _) -> AnyPublisher<[ChatRoom], ChatError> in
                return owner.chatUseCase.getChatRoomList(owner.workspaceID)
            }
            .withUnretained(self)
            .flatMap { (owner, chatRoomList) -> AnyPublisher<[DMRoomPresentationModel], ChatError> in
                let publishers = chatRoomList.map { chatRoom in
                    owner.chatUseCase.loadUnreadChats(owner.workspaceID, chatRoom.roomID, chatType: .dm)
                        .map { chats -> DMRoomPresentationModel? in
                            guard let lastChat = chats.last else {
                                let readChats = owner.chatUseCase.loadReadChats(chatRoom.roomID, isPagination: false)
                                
                                guard let last = readChats.last else {
                                    return nil
                                }
                                
                                return DMRoomPresentationModel.create(last, numberOfUnreadMessage: 0)
                            }
                            return DMRoomPresentationModel.create(lastChat, numberOfUnreadMessage: chats.count)
                        }
                }
                
                return Publishers.MergeMany(publishers)
                    .compactMap { $0 }
                    .collect()
                    .map { $0.sorted { $0.lastDate > $1.lastDate } }
                    .eraseToAnyPublisher()
            }
            .withUnretained(self)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("🚨 ", #function, error.errorDescription ?? "")
                }
            } receiveValue: { owner, dmRooms in
                owner.dmRoomList.send(dmRooms)
            }.store(in: &cancellable)

        input.selectedMember
            .withUnretained(self)
            .flatMap { owner, index -> AnyPublisher<ChatRoom, ChatError> in
                let memberID = owner.memberList.value[index].id
                
                return owner.chatUseCase.getChatRoom(owner.workspaceID, EnterRoomBody(opponentID: memberID))
            }
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print("🚨 ", #function, error.errorDescription ?? "")
                }
            } receiveValue: { room in
                willlEnterRoom.send(room)
            }.store(in: &cancellable)
        
        input.selectedDMRoom
            .withUnretained(self)
            .sink { owner, index in
                let dmRoom = owner.dmRoomList.value[index]

                willlEnterRoom.send(ChatRoom(roomID: dmRoom.id, name: dmRoom.name))
            }.store(in: &cancellable)
        
        return Output(
            workspace: workspaceSubject.eraseToAnyPublisher(),
            memberList: memberList.eraseToAnyPublisher(),
            dmRoomList: dmRoomList.eraseToAnyPublisher(),
            willEnterRoom: willlEnterRoom.eraseToAnyPublisher()
        )
    }
}

extension DMListViewModel {
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let viewWillAppear: AnyPublisher<Void, Never>
        let selectedMember: AnyPublisher<Int, Never>
        let selectedDMRoom: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let workspace: AnyPublisher<Workspace, Never>
        let memberList: AnyPublisher<[Member], Never>
        let dmRoomList: AnyPublisher<[DMRoomPresentationModel], Never>
        let willEnterRoom: AnyPublisher<ChatRoom, Never>
    }
    
}
