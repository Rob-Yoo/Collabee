//
//  DMListViewController.swift
//  App
//
//  Created by Jinyoung Yoo on 11/26/24.
//

import UIKit
import Combine

import WorkSpace

import SnapKit
import Then

enum DMSection {
    case member
    case dm
}

enum DMItem: Hashable {
    case memberList(Member)
    case dmRoomList(DMRoomPresentationModel)
}

fileprivate final class DataSource: UICollectionViewDiffableDataSource<DMSection, DMItem> {
    init(_ collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .memberList(let member):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberCollectionViewCell.identifier, for: indexPath) as? MemberCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                cell.configureCell(member.profileImage, member.nickname)
                return cell
                
            case .dmRoomList(let dmRoom):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DMRoomCollectionViewCell.identifier, for: indexPath) as? DMRoomCollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                cell.configureCell(dmRoom)
                return cell
            }
        }
    }
}

fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<DMSection, DMItem>

final class DMListViewController: BaseViewController {
    
    private let vm = DMListViewModel()
    private let didSelectItemAtSubject = PassthroughSubject<IndexPath, Never>()
    private lazy var dataSource = DataSource(collectionView)
    
    private let coverImageView = RoundedImageView().then {
        let size = CGSize(width: 35, height: 35)
        
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFill
        $0.frame = CGRect(origin: .zero, size: size)
    }
    
    private var profileImageView = RoundedImageView().then {
        let size = CGSize(width: 35, height: 35)
        
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.frame = CGRect(origin: .zero, size: size)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.register(DMRoomCollectionViewCell.self, forCellWithReuseIdentifier: DMRoomCollectionViewCell.identifier)
        $0.register(MemberCollectionViewCell.self, forCellWithReuseIdentifier: MemberCollectionViewCell.identifier)
        $0.delegate = self
        $0.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Constant.Literal.DMList.navTitle
        configureNavigationBarButtonItems()
    }
    
    override func bindViewModel() {
        let selectedMember = didSelectItemAtSubject.filter { $0.section == 0 }.map { $0.row }
        let selectedDMRoom = didSelectItemAtSubject.filter { $0.section == 1 }.map { $0.row }
        let profileImageTapGR = UITapGestureRecognizer().then {
            profileImageView.addGestureRecognizer($0)
        }
        let input = DMListViewModel.Input(
            viewDidLoad: viewDidLoadPublisher.eraseToAnyPublisher(),
            viewWillAppear: viewWillAppearPublisher.eraseToAnyPublisher(),
            selectedMember: selectedMember.eraseToAnyPublisher(),
            selectedDMRoom: selectedDMRoom.eraseToAnyPublisher()
        )
        let output = vm.transform(input)
        
        profileImageTapGR.tapPublisher
            .withUnretained(self)
            .sink { owner, _ in
                let nextVC = ProfileViewController(navTitle: "프로필")
                
                nextVC.onDismiss = { [unowned self] profileImage in
                    profileImageView.image = profileImage
                }
                owner.presentBottomSheet(nextVC)
            }.store(in: &cancellable)
        
        output.profileImage
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, imageURL in
                owner.profileImageView.setImage(imageURL: imageURL, placeHolder: .profilePlaceholder, size: CGSize(width: 35, height: 35))
                
            }.store(in: &cancellable)
        
        output.workspace
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, workspace in
                owner.coverImageView.setImage(imageURL: workspace.image, placeHolder: .sesacBot, size: CGSize(width: 35, height: 35))
                
            }.store(in: &cancellable)
        
        Publishers.CombineLatest(output.memberList, output.dmRoomList)
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { (owner, listTuple) in
                let (memberList, dmRoomList) = listTuple
                owner.applySnapShot(memberList, dmRoomList)
            }.store(in: &cancellable)
        
        output.willEnterRoom
            .receive(on: DispatchQueue.main)
            .withUnretained(self)
            .sink { owner, room in
                let nextVC = DMChattingViewController(vm: DMChattingViewModel(room: room))
                
                nextVC.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(nextVC, animated: true)
            }.store(in: &cancellable)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIdx, _) -> NSCollectionLayoutSection? in
            
            guard let self else { return nil }
            
            switch sectionIdx {
            case 0:
                return memberListSection()
            case 1:
                return dmListSection()
            default:
                return nil
            }
        }
        
        return layout
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func memberListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(65), heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    private func dmListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 15, bottom: 20, trailing: 15)
        section.interGroupSpacing = 20
        return section
    }
    
    private func configureNavigationBarButtonItems() {
        let leftBarButton = UIBarButtonItem(customView: coverImageView)
        let rightBarButton = UIBarButtonItem(customView: profileImageView)
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func applySnapShot(_ memberList: [Member], _ dmRoomList: [DMRoomPresentationModel]) {
        var snapShot = Snapshot()
        snapShot.appendSections([.member, .dm])
        snapShot.appendItems(memberList.map { DMItem.memberList($0) }, toSection: .member)
        snapShot.appendItems(dmRoomList.map { DMItem.dmRoomList($0) }, toSection: .dm)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}

//MARK: - CollectionView Delegate
extension DMListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItemAtSubject.send(indexPath)
    }
}
