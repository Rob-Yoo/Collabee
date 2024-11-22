//
//  BaseViewController.swift
//  App
//
//  Created by Jinyoung Yoo on 11/21/24.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    
    var cancellable = Set<AnyCancellable>()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHierarchy()
        configureLayout()
        bindViewModel()
    }
    
    //MARK: - Overriding Methods
    func configureHierarchy() {}
    func configureLayout() {}
    func bindViewModel() {}
}

extension BaseViewController {
    func addKeyboardDismissAction() {
        let tapGesture = UITapGestureRecognizer()
        
        view.addGestureRecognizer(tapGesture)
        tapGesture.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                
                view.endEditing(true)
            }
            .store(in: &cancellable)
    }
}
