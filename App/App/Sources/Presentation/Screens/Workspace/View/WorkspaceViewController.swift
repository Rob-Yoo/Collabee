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

fileprivate final class DataSource: UITableViewDiffableDataSource<WorkspaceSection, WorkspaceItem> {
    init(tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, item in
            switch item {
            case .channel(let channel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier, for: indexPath) as? ChannelTableViewCell else {
                    return UITableViewCell()
                }

                cell.configureCell(channel.name)
                return cell
            case .dm(let dm):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier, for: indexPath) as? ChannelTableViewCell else {
                    return UITableViewCell()
                }
                cell.configureCell(dm)
                return cell
            }
        }
    }
}

final class WorkspaceViewController: BaseViewController {

    private let vm = WorkspaceViewModel()
    private let didSelectRowAtSubject = PassthroughSubject<IndexPath, Never>()
    private let headerTappedSubject = PassthroughSubject<Int, Never>()
    
    private lazy var dataSource = DataSource(tableView: tableView).then {
        $0.defaultRowAnimation = .none
    }
    
    private var coverImageView = RoundedImageView().then {
        let size = CGSize(width: 35, height: 35)
        
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFill
        $0.frame = CGRect(origin: .zero, size: size)
    }
    
    private var profileImageView = RoundedImageView().then {
        let placeHolder = UIImage.profilePlaceholder
        let size = CGSize(width: 35, height: 35)
        
        $0.isUserInteractionEnabled = true
        $0.image = placeHolder.resize(size)
        $0.frame = CGRect(origin: .zero, size: size)
    }
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(WorkSpaceTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: WorkSpaceTableViewHeaderView.identifier)
        $0.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.identifier)
        $0.delegate = self
        $0.rowHeight = 45
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.sectionFooterHeight = 0
        $0.backgroundColor = .white
    }
    
    private let inviteButton = UIButton().then {
        let conf = UIImage.SymbolConfiguration(font: .bold22)
        
        $0.backgroundColor = .brandMainTheme
        $0.setImage(.inviteIcon?.withConfiguration(conf), for: .normal)
        $0.layer.cornerRadius = 27
        $0.tintColor = .white
        $0.layer.shadowOffset = CGSize(width: 2, height: 2)
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowRadius = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarButtonItems()
    }
    
    override func configureHierarchy() {
        self.view.addSubview(tableView)
        self.view.addSubview(inviteButton)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        inviteButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.size.equalTo(54)
        }
    }
    
    override func bindViewModel() {
        let channelTapped = didSelectRowAtSubject.filter { $0.section == 0 }.map { $0.row }.eraseToAnyPublisher()
        let dmTapped = didSelectRowAtSubject.filter { $0.section == 1 }.map { $0.row }.eraseToAnyPublisher()
        
        let input = WorkspaceViewModel.Input(
            viewWillAppear: viewWillAppearPublisher,
            inviteButtonTapped: inviteButton.tap,
            channelTapped: channelTapped,
            dmTapped: dmTapped,
            headerTapped: headerTappedSubject.eraseToAnyPublisher()
        )
        let output = vm.transform(input: input)
        
        output.inviteButtonTapped
            .withUnretained(self)
            .sink { (owner, workspaceID) in
                let inviteVC = InviteMemberViewController(
                    workspaceID: workspaceID,
                    navTitle: Constant.Literal.InviteMember.navTitle
                )
                
                owner.presentBottomSheet(inviteVC)
            }.store(in: &cancellable)
        
        output.workspace
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, workspace in
                
                owner.navigationItem.title = workspace.name
                owner.coverImageView.setImage(imageURL: workspace.image, placeHolder: .sesacBot, size: CGSize(width: 35, height: 35))
                
            }.store(in: &cancellable)
        
        output.snapShotPublisher
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, snapShot in
                owner.dataSource.apply(snapShot, animatingDifferences: true)
            }.store(in: &cancellable)
    }
    
    private func configureNavigationBarButtonItems() {
        let leftBarButton = UIBarButtonItem(customView: coverImageView)
        let rightBarButton = UIBarButtonItem(customView: profileImageView)
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
}

//MARK: - UITableViewDelegate
extension WorkspaceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAtSubject.send(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: WorkSpaceTableViewHeaderView.identifier) as? WorkSpaceTableViewHeaderView else {
            return UIView()
        }
        
        headerView.onTap = { [weak self] in
            self?.headerTappedSubject.send(section)
        }

        let sectionIdentifiers = dataSource.snapshot().sectionIdentifiers

        if sectionIdentifiers.count > section {
            let sectionModel = sectionIdentifiers[section]
            
            headerView.configureView(isOpened: sectionModel.isOpened, title: sectionModel.title)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
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
