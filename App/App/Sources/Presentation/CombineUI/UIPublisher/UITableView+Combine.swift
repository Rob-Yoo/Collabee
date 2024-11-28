//
//  UITableView.swift
//  App
//
//  Created by Jinyoung Yoo on 11/27/24.
//

import Combine
import UIKit

extension UITableView {
    
    var didSelectRowAt: AnyPublisher<IndexPath, Never> {
        NotificationCenter.default.publisher(for: UITableView.selectionDidChangeNotification, object: self)
            .compactMap { $0.object as? UITableView }
            .compactMap { $0.indexPathForSelectedRow }
            .eraseToAnyPublisher()
    }
    
}
