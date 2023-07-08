//
//  Toast.swift
//  Mark
//
//  Created by jyck on 2023/6/25.
//

import Foundation
import Loaf



struct Toast {
    
    enum State {
        case success
        case error
        case warning
        case info
        
        var type: Loaf.State {
            switch self {
            case .success: return .success
            case .error: return .error
            case .warning: return .warning
            case .info: return .info
            }
        }
    }

    
    static func show(_ text: String, state: State = .info) {
        DispatchQueue.main.async {
            Loaf(text, state: state.type,  location: .top, sender: currentViewController()!).show()
            printt(text)
        }
    }
    
}
