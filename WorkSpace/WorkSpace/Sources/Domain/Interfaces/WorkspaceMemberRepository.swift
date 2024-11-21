//
//  WorkspaceMemberRepository.swift
//  WorkSpace
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import Combine

public protocol WorkspaceMemberRepository {
    func invite(_ workspaceID: String, _ body: InviteBody) -> AnyPublisher<Member, WorkspaceMemberError>
    func fetchMemberList(_ workspaceID: String) -> AnyPublisher<[Member], WorkspaceMemberError>
    func fetchMemberDetail(_ workspaceID: String, _ userID: String) -> AnyPublisher<Member, WorkspaceMemberError>
}
