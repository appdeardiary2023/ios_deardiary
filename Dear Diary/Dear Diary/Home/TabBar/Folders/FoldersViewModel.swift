//
//  FoldersViewModel.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 30/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryStrings
import DearDiaryImages

protocol FoldersViewModelable {
    var profileButtonImage: UIImage? { get }
    var titleLabelText: String { get }
    var searchBarImage: UIImage? { get }
    var searchBarPlaceholder: String { get }
    func profileButtonTapped()
}

final class FoldersViewModel: FoldersViewModelable {
        
}

// MARK: - Exposed Helpers
extension FoldersViewModel {
    
    var profileButtonImage: UIImage? {
        return Image.profile.asset
    }
    
    var searchBarImage: UIImage? {
        return Image.search.asset
    }
    
    var titleLabelText: String {
        return Strings.Folders.title
    }
    
    var searchBarPlaceholder: String {
        return Strings.Folders.search
    }

    func profileButtonTapped() {
        // TODO
    }
   
}
