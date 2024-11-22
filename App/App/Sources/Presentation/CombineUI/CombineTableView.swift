//
//  CombineTableView.swift
//  App
//
//  Created by Jinyoung Yoo on 11/22/24.
//

import Combine
import UIKit

final class CombineTableView: UITableView, UITableViewDelegate {
    
    private let didSelectRowSubject = PassthroughSubject<IndexPath, Never>()
    var didSelectRow: AnyPublisher<IndexPath, Never> {
        return didSelectRowSubject.eraseToAnyPublisher()
    }
    
    init() {
        super.init(frame: .zero, style: .plain)
        self.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowSubject.send(indexPath)
    }

}
