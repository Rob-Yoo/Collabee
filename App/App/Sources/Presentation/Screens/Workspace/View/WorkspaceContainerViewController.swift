//
//  WorkspaceContainerViewController.swift
//  App
//
//  Created by Jinyoung Yoo on 11/22/24.
//

import UIKit
import Combine

import WorkSpace
import Common

final class WorkspaceContainerViewController: BaseViewController {
    
    private lazy var emptyWorkspaceVC = EmptyWorkspaceViewController()
    private lazy var workspaceVC = WorkspaceViewController()
    @Injected private var repository: WorkspaceRepository
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureChildVC()
    }
    
    private func configureChildVC() {
        if let _ = repository.getWorkspaceID() {
            self.addChild(workspaceVC)
            workspaceVC.didMove(toParent: self)
            self.view.addSubview(workspaceVC.view)
            workspaceVC.view.frame = view.bounds
        } else {
            self.addChild(emptyWorkspaceVC)
            emptyWorkspaceVC.didMove(toParent: self)
            self.view.addSubview(emptyWorkspaceVC.view)
            emptyWorkspaceVC.view.frame = view.bounds
        }
    }
    
}
