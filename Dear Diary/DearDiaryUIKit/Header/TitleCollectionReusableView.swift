//
//  TitleCollectionReusableView.swift
//  DearDiaryUIKit
//
//  Created by Abhijit Singh on 15/07/23.
//  Copyright © 2023 Dear Diary. All rights reserved.
//

import UIKit
import SnapKit

public final class TitleCollectionReusableView: UICollectionReusableView {
    
    public static let reuseId = String(describing: TitleCollectionReusableView.self)
    
    private struct Style {
        static let titleLabelTextColor = Color.label.shade
        static let titleLabelFont = Font.largeTitle(.bold)
        static let titleLabelHorizontalInset: CGFloat = 30
        static let titleLabelBottomInset: CGFloat = 20
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Style.titleLabelTextColor
        label.font = Style.titleLabelFont
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Exposed Helpers
public extension TitleCollectionReusableView {
    
    func configure(with title: String?) {
        titleLabel.text = title
    }
    
    static func calculateHeight(with title: String?) -> CGFloat {
        let titleLabelHeight = title?.calculate(
            .height(constrainedWidth: .greatestFiniteMagnitude),
            with: Style.titleLabelFont
        ) ?? .zero
        return titleLabelHeight + Style.titleLabelBottomInset
    }
    
}

// MARK: - Private Helpers
private extension TitleCollectionReusableView {
    
    func setup() {
        setupTitleLabel()
    }
    
    func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Style.titleLabelHorizontalInset)
            $0.bottom.equalToSuperview().inset(Style.titleLabelBottomInset)
        }
    }
    
}
