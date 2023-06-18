//
//  ParentViewController.swift
//  Dear Diary
//
//  Created by Abhijit Singh on 17/06/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import DearDiaryUIKit

final class ParentViewController: UITabBarController,
                                  ViewLoadable {
    
    static var name = Constants.Parent.storyboardName
    static var identifier = Constants.Parent.parentViewController
    
    private struct Style {
        static let barBackgroundColor = Color.secondaryBackground.shade
        static let barTintColor = Color.label.shade
        static let selectedTabColor = Color.primary.shade
        
        static let tabBarImageSizeRatio: CGFloat = 0.037
        // Taken from stack overflow. For some reason, the magic number 6 is able to
        // center align the tab bar items vertically
        static let tabBarImageVerticalInset: CGFloat = 6
    }
    
    var viewModel: ParentViewModelable?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

// MARK: - Private Helpers
private extension ParentViewController {
    
    func setup() {
        setupTabBar()
        setupViewControllers()
        centerAlignTabBarItems()
    }
    
    func setupTabBar() {
        tabBar.backgroundColor = Style.barBackgroundColor
        UITabBar.appearance().barTintColor = Style.barTintColor
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        selectedIndex = viewModel?.selectedItem.rawValue ?? 0
    }
    
    func setupViewControllers() {
        var childControllers = [UIViewController]()
        // TODO: Change to actual view controllers
        viewModel?.items.forEach { item in
            let viewController = UIViewController()
            let imageSize = Style.tabBarImageSizeRatio * view.bounds.height
            let image = item.image?
                .withRenderingMode(.alwaysTemplate)
                .resize(to: CGSize(width: imageSize, height: imageSize))
            let tabBarItem =  UITabBarItem(
                title: nil,
                image: image,
                selectedImage: image?.withTintColor(Style.selectedTabColor)
            )
            viewController.tabBarItem = tabBarItem
            childControllers.append(viewController)
        }
        viewControllers = childControllers
    }
    
    func centerAlignTabBarItems() {
        // All tab bar buttons have the same size
        guard let button = tabBar.subviews.first(where: { $0 is UIControl }) else { return }
        let hasSafeArea = !(UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0).isZero
        tabBar.items?.forEach { item in
            let verticalInset = hasSafeArea
                ? (button.frame.height - (item.image?.size.height ?? 0)) / 2
                : Style.tabBarImageVerticalInset
            let imageInsets = UIEdgeInsets(top: verticalInset, left: 0, bottom: -verticalInset, right: 0)
            item.imageInsets = imageInsets
        }
    }
    
}
