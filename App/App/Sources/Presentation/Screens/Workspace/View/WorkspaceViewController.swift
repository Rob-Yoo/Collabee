//
//  WorkspaceViewController.swift
//  App
//
//  Created by Jinyoung Yoo on 11/22/24.
//

import UIKit
import Combine

import SnapKit
import Then

struct Section {
    let title: String
    let channel: [String]
    var isOpened = true
}

final class WorkspaceViewController: BaseViewController {
    
    var sections = [
        Section(title: "채널", channel: ["일반", "일반", "일반"]),
        Section(title: "다이렉트 메시지", channel: ["유", "진", "영"])
    ]
    
    private lazy var tableView = CombineTableView().then {
        $0.register(WorkSpaceSectionTableViewCell.self, forCellReuseIdentifier: WorkSpaceSectionTableViewCell.identifier)
        $0.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.identifier)
        $0.dataSource = self
        $0.rowHeight = 45
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }
    
    override func configureHierarchy() {
        self.view.addSubview(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bindViewModel() {
        tableView.didSelectRow
            .sink { [weak self] indexPath in
                
                guard let self else { return }
                
                if indexPath.row == 0 {
                    sections[indexPath.section].isOpened.toggle()
                    tableView.reloadSections([indexPath.section], with: .automatic)
                }
                
            }.store(in: &cancellable)
    }
}

extension WorkspaceViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        if section.isOpened {
            return section.channel.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]

        if indexPath.row == 0 {
            guard let sectionCell = tableView.dequeueReusableCell(withIdentifier: WorkSpaceSectionTableViewCell.identifier, for: indexPath) as? WorkSpaceSectionTableViewCell else {
                return UITableViewCell()
            }
            
            sectionCell.configureCell(isOpened: section.isOpened, title: section.title)
            sectionCell.selectionStyle = .none
            return sectionCell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier, for: indexPath) as? ChannelTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configureCell(section.channel[indexPath.row - 1])
            return cell
        }

    }

}


#if DEBUG
import SwiftUI

struct WorkspaceViewControllerPreview: PreviewProvider {
    static var previews: some View {
        WorkspaceViewController().toPreview()
    }
}
#endif
