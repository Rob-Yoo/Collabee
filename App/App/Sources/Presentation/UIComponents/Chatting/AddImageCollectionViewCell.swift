//
//  AddImageCollectionViewCell.swift
//  App
//
//  Created by Jinyoung Yoo on 11/27/24.
//

import UIKit

import SnapKit

final class AddImageCollectionViewCellCell: BaseCollectionViewCell {
    private let addImageView = UIImageView()
    private let removeButton = UIButton()
    
    override func configureView() {
        addImageView.layer.cornerRadius = 8
        addImageView.clipsToBounds = true
        removeButton.setImage(.xCircleIcon, for: .normal)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(addImageView)
        contentView.addSubview(removeButton)
    }
    
    override func configureLayout() {
        addImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(7)
        }
        
        removeButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerX.equalTo(addImageView.snp.trailing)
            make.centerY.equalTo(addImageView.snp.top).offset(1)
        }
    }

    func configureUI(image: UIImage) {
        addImageView.image = image
    }
}
