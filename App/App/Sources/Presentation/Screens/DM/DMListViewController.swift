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
    
    private let didSelectItemAtSubject = PassthroughSubject<IndexPath, Never>()
    private lazy var dataSource = DataSource(collectionView)
    
    private let coverImageView = RoundedImageView().then {
        let size = CGSize(width: 35, height: 35)
        
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleAspectFill
        $0.frame = CGRect(origin: .zero, size: size)
    }
    
    private let profileImageView = RoundedImageView().then {
        let placeHolder = UIImage.profilePlaceholder
        let size = CGSize(width: 35, height: 35)
        
        $0.isUserInteractionEnabled = true
        $0.image = placeHolder.resize(size)
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
        applySnapShot()
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
    
    private func applySnapShot() {
        var snapShot = Snapshot()
        let memberList = [
            Member(id: "asdfasdf", email: "asdfasdf", nickname: "test1", profileImage: nil),
            Member(id: "asdfasdf", email: "asdfasdf", nickname: "test2", profileImage: nil),
            Member(id: "asdfasdf", email: "asdfasdf", nickname: "test3", profileImage: nil),
            Member(id: "asdfasdf", email: "asdfasdf", nickname: "test4", profileImage: nil),
            Member(id: "asdfasdf", email: "asdfasdf", nickname: "test5", profileImage: nil),
            Member(id: "asdfasdf", email: "asdfasdf", nickname: "test6", profileImage: nil),
            Member(id: "asdfasdf", email: "asdfasdf", nickname: "test7", profileImage: nil),
            Member(id: "asdfasdf", email: "asdfasdf", nickname: "test8", profileImage: nil),
            Member(id: "asdfasdf", email: "asdfasdf", nickname: "test9", profileImage: nil),
            Member(id: "asdfasdf", email: "asdfasdf", nickname: "test10", profileImage: nil)
        ]
        let dmRoomList = [
            DMRoomPresentationModel(name: "test1", profileImageURL: "", lastMessage: "가나다라마바사", lastDate: "PM 06:33", numberOfUnreadMessage: Int.random(in: 0...20)),
            DMRoomPresentationModel(name: "test2", profileImageURL: "", lastMessage: "안녕하세요", lastDate: "PM 06:33", numberOfUnreadMessage: Int.random(in: 0...20)),
            DMRoomPresentationModel(name: "test3", profileImageURL: "", lastMessage: "ㅁㄴ앝ㅊ퍚단ㅇㄹㄴ알", lastDate: "PM 06:33", numberOfUnreadMessage: Int.random(in: 0...20)),
            DMRoomPresentationModel(name: "test4", profileImageURL: "", lastMessage: "ㅁㄴㅇ람ㄴ이ㅏㄹㄴㅁㅇㄹ", lastDate: "PM 07:33", numberOfUnreadMessage: Int.random(in: 0...20)),
            DMRoomPresentationModel(name: "test5", profileImageURL: "", lastMessage: "옹골찬 고래밥", lastDate: "AM 06:33", numberOfUnreadMessage: Int.random(in: 0...20)),
            DMRoomPresentationModel(name: "test6", profileImageURL: "", lastMessage: "asdfasdf", lastDate: "PM 06:33", numberOfUnreadMessage: Int.random(in: 0...20))
        ]
        
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
