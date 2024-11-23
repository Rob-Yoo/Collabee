//
//  WorkspaceSection.swift
//  App
//
//  Created by Jinyoung Yoo on 11/23/24.
//

struct WorkspaceSection: Hashable {
    let sectionType: WorkspaceSectionType
    let title: String
    var isOpened: Bool
}

enum WorkspaceSectionType: Hashable {
    case channel
    case dm
}
