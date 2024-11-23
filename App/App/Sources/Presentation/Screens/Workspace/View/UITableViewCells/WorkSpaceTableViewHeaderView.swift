//
//  WorkSpaceTableViewHeaderView.swift
//  App
//
//  Created by Jinyoung Yoo on 11/22/24.
//

import UIKit

import SnapKit
import Then

final class WorkSpaceTableViewHeaderView: UITableViewHeaderFooterView {
    
    private let line = UIView().then {
        $0.backgroundColor = .separtor
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .textPrimary
        $0.font = .bold17
    }
    
    private let toggleImageView = UIImageView().then {
        $0.tintColor = .black
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        configureHierarchy()
        configureLayout()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        contentView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var onTap: (() -> Void)?
    
    private func configureHierarchy() {
        contentView.addSubview(line)
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggleImageView)
    }
    
    private func configureLayout() {
        line.snp.makeConstraints { make in
            make.width.equalTo(Constant.Dimension.screenWidth)
            make.height.equalTo(0.85)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        toggleImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc
    private func headerTapped() {
        onTap?()
    }
    
    func configureView(isOpened: Bool, title: String) {
        let arrowIcon: UIImage? = isOpened ? .downArrowIcon : .rightArrowIcon
        
        toggleImageView.image = arrowIcon
        titleLabel.text = title
    }
}
