//
//  WorkspaceViewModel.swift
//  App
//
//  Created by Jinyoung Yoo on 11/22/24.
//

import Combine
import UIKit.NSDiffableDataSourceSectionSnapshot

import WorkSpace
import Chat
import User
import Common

fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<WorkspaceSection, WorkspaceItem>

final class WorkspaceViewModel {
    
    @Injected private var workspaceRepository: WorkspaceRepository
    @Injected private var channelRepository: ChannelRepository
    @Injected private var chatRepository: ChatDataRepository
    @Injected private var userRepository: UserRepository

    private var cancellable = Set<AnyCancellable>()
    private lazy var workspaceID = workspaceRepository.getWorkspaceID()!
    
    private let toggleSubject = CurrentValueSubject<Void, Never>(())
    private let channelListSubject = CurrentValueSubject<[Channel], Never>([])
    private let dmListSubject = CurrentValueSubject<[ChatRoom], Never>([])
    private var sections = [
        WorkspaceSection(sectionType: .channel, title: "채널", isOpened: true),
        WorkspaceSection(sectionType: .dm, title: "다이렉트 메세지", isOpened: true)
    ]
    
    func transform(input: Input) -> Output {
        
        let workspaceSubject = PassthroughSubject<Workspace, Never>()
        let workspaceIDSubject = PassthroughSubject<String, Never>()
        let selectedChannelSubject = PassthroughSubject<Channel, Never>()
        let snapShotPublisher = Publishers.CombineLatest3(toggleSubject, channelListSubject, dmListSubject).withUnretained(self).map { (owner, subjects) in
            owner.createSnapshot(subjects.1, subjects.2)
        }.eraseToAnyPublisher()
        let profileImage = PassthroughSubject<String, Never>()

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
            .flatMap { (owner, _) -> AnyPublisher<[Channel], ChannelError> in
                owner.channelRepository.fetchMyChannels(owner.workspaceID)
            }
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(#function, "🚨 \(error.errorDescription ?? "")")
                }
            } receiveValue: { [weak self] channelList in
                self?.channelListSubject.send(channelList)
            }.store(in: &cancellable)
        
        input.viewDidLoad
            .withUnretained(self)
            .flatMap { owner, _ -> AnyPublisher<User, UserError> in
                return owner.userRepository.fetchMyProfile()
            }
            .withUnretained(self)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(#function, "🚨 \(error.errorDescription ?? "")")
                }
            } receiveValue: { owner, user in
                profileImage.send(user.profileImage)
            }.store(in: &cancellable)

        input.viewDidLoad
            .withUnretained(self)
            .flatMap { owner, _ -> AnyPublisher<[ChatRoom], ChatError> in
                return owner.chatRepository.fetchChatRoomList(owner.workspaceID)
            }
            .withUnretained(self)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(#function, "🚨 \(error.errorDescription ?? "")")
                }
            } receiveValue: { owner, chatRooms in
                owner.dmListSubject.send(chatRooms)
            }.store(in: &cancellable)

        
        input.inviteButtonTapped
            .withUnretained(self)
            .sink { owner, _ in
                workspaceIDSubject.send(owner.workspaceID)
            }.store(in: &cancellable)
        
        input.headerTapped
            .withUnretained(self)
            .sink { owner, section in
                owner.sections[section].isOpened.toggle()
                owner.toggleSubject.send(())
            }.store(in: &cancellable)
        
        input.channelTapped
            .withUnretained(self)
            .sink { (owner, index) in
                let channel = owner.channelListSubject.value[index]
                selectedChannelSubject.send(channel)
            }.store(in: &cancellable)
        
        
        return Output(
            workspace: workspaceSubject.eraseToAnyPublisher(),
            inviteButtonTapped: workspaceIDSubject.eraseToAnyPublisher(),
            selectedChannel: selectedChannelSubject.eraseToAnyPublisher(),
            snapShotPublisher: snapShotPublisher.eraseToAnyPublisher(),
            profileImage: profileImage.eraseToAnyPublisher()
        )
    }

    private func createSnapshot(_ channels: [Channel], _ dms: [ChatRoom]) -> Snapshot {
        var snapShot = Snapshot()

        snapShot.appendSections(sections)
        
        for section in sections {
            if section.isOpened {
                switch section.sectionType {
                case .channel:
                    let channels = channels.map { WorkspaceItem.channel($0) }
                    snapShot.appendItems(channels, toSection: section)
                case .dm:
                    let dms = dms.map { WorkspaceItem.dm($0) }
                    snapShot.appendItems(dms, toSection: section)
                }
            }
        }
        
        return snapShot
    }
}

extension WorkspaceViewModel {
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let inviteButtonTapped: AnyPublisher<Void, Never>
        let channelTapped: AnyPublisher<Int, Never>
        let dmTapped: AnyPublisher<Int, Never>
        let headerTapped: AnyPublisher<Int, Never>
    }
    
    struct Output {
        let workspace: AnyPublisher<Workspace, Never>
        let inviteButtonTapped: AnyPublisher<String, Never>
        let selectedChannel: AnyPublisher<Channel, Never>
        let snapShotPublisher: AnyPublisher<NSDiffableDataSourceSnapshot<WorkspaceSection, WorkspaceItem>, Never>
        let profileImage: AnyPublisher<String, Never>
    }
}
