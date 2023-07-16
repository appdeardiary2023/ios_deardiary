//
//  JSONable.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 13/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import Foundation

enum MockModule {
    case signUp
    case signIn
    case otp
    case folders
    case notes
}

protocol JSONable {}

extension JSONable {
    
    func fetchData<T: Codable>(for module: MockModule, completion: @escaping (T) -> Void) {
        guard let fileURL = Bundle.main.url(forResource: module.fileName, withExtension: "json"),
              let data = try? Data(contentsOf: fileURL),
              let model = try? JSONDecoder().decode(T.self, from: data) else { return }
        completion(model)
    }
    
    func fetchData<T: Codable>(for module: MockModule, completion: @escaping ([T]) -> Void) {
        guard let fileURL = Bundle.main.url(forResource: module.fileName, withExtension: "json"),
              let data = try? Data(contentsOf: fileURL),
              let models = try? JSONDecoder().decode([T].self, from: data) else { return }
        completion(models)
    }
    
}

// MARK: - MockModule Helpers
private extension MockModule {
    
    var fileName: String {
        switch self {
        case .signUp:
            return String()
        case .signIn:
            return Constants.Mock.user
        case .otp:
            return Constants.Mock.otp
        case .folders:
            return Constants.Mock.folders
        case .notes:
            return Constants.Mock.notes
        }
    }
    
}
