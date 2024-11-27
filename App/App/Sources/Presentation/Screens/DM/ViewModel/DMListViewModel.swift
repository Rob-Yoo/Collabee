//
//  DMListViewModel.swift
//  App
//
//  Created by Jinyoung Yoo on 11/27/24.
//

import Combine

import WorkSpace
import DataSource
import Common

final class DMListViewModel {
    
    @Injected private var memberRepository: WorkspaceMemberRepository
    @Injected private var workspaceRepository: WorkspaceRepository
    private var cancellable = Set<AnyCancellable>()
    
    private lazy var workspaceID = workspaceRepository.getWorkspaceID() ?? ""
    private let dmRoomList = CurrentValueSubject<[DMRoomPresentationModel], Never>([])
    
    func transform(_ input: Input) -> Output {
        let workspaceSubject = PassthroughSubject<Workspace, Never>()
        let memberList = CurrentValueSubject<[Member], Never>([])
        
        input.viewDidLoad
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
        
        input.viewDidLoad
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
                memberList.send(members)
            }.store(in: &cancellable)
        
        input.viewDidLoad
            .withUnretained(self)
            .sink { (owner, _) in
                let dmRoomList = [
                    DMRoomPresentationModel(name: "test1", profileImageURL: "", lastMessage: "가나다라마바사", lastDate: "PM 06:33", numberOfUnreadMessage: Int.random(in: 0...20)),
                    DMRoomPresentationModel(name: "test2", profileImageURL: "", lastMessage: "안녕하세요", lastDate: "PM 06:33", numberOfUnreadMessage: Int.random(in: 0...20)),
                    DMRoomPresentationModel(name: "test3", profileImageURL: "", lastMessage: "ㅁㄴ앝ㅊ퍚단ㅇㄹㄴ알", lastDate: "PM 06:33", numberOfUnreadMessage: Int.random(in: 0...20)),
                    DMRoomPresentationModel(name: "test4", profileImageURL: "", lastMessage: "ㅁㄴㅇ람ㄴ이ㅏㄹㄴㅁㅇㄹ", lastDate: "PM 07:33", numberOfUnreadMessage: Int.random(in: 0...20)),
                    DMRoomPresentationModel(name: "test5", profileImageURL: "", lastMessage: "옹골찬 고래밥", lastDate: "AM 06:33", numberOfUnreadMessage: Int.random(in: 0...20)),
                    DMRoomPresentationModel(name: "test6", profileImageURL: "", lastMessage: "asdfasdf", lastDate: "PM 06:33", numberOfUnreadMessage: Int.random(in: 0...20))
                ]
                owner.dmRoomList.send(dmRoomList)
            }.store(in: &cancellable)

        input.selectedDMRoom
            .withUnretained(self)
            .sink { owner, index in
                print(owner.dmRoomList.value[index])
            }.store(in: &cancellable)
        
        return Output(
            workspace: workspaceSubject.eraseToAnyPublisher(),
            memberList: memberList.eraseToAnyPublisher(),
            dmRoomList: dmRoomList.eraseToAnyPublisher()
        )
    }
}

extension DMListViewModel {
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let viewWillAppear: AnyPublisher<Void, Never>
        let selectedDMRoom: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let workspace: AnyPublisher<Workspace, Never>
        let memberList: AnyPublisher<[Member], Never>
        let dmRoomList: AnyPublisher<[DMRoomPresentationModel], Never>
    }
    
}
