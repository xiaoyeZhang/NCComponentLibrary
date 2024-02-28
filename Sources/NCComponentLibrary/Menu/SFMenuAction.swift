//
//  SFMenuAction.swift
//  Saifanbox
//
//  Created by who on 2024/2/28.
//

import Foundation
import UIKit

public class SFMenuAction {
    
    public let title: String
    public var titleColor: UIColor?
    public let details: String?
    public let icon: UIImage
    public let selectable: Bool
    public var onTitle: String?
    public var onIcon: UIImage?
    public var selected: Bool = false
    public var isOn: Bool = false
    public var showLine: Bool = true
    public var rowHeight: CGFloat { self.title == SFMenuAction.seperatorIdentifier ? SFMenuAction.seperatorHeight : self.details != nil ? 80 : 50 }
    public var action: ((_ menuAction: SFMenuAction) -> Void)?

    public init(title: String, titleColor: UIColor? = nil, details: String? = nil, icon: UIImage, showLine: Bool = true, action: ((_ menuAction: SFMenuAction) -> Void)?) {
        self.title = title
        self.titleColor = titleColor
        self.details = details
        self.icon = icon
        self.showLine = showLine
        self.action = action
        self.selectable = false
    }

    public init(title: String, titleColor: UIColor? = nil, details: String? = nil, icon: UIImage, onTitle: String? = nil, onIcon: UIImage? = nil, selected: Bool, on: Bool, showLine: Bool = true, action: ((_ menuAction: SFMenuAction) -> Void)?) {
        self.title = title
        self.titleColor = titleColor
        self.details = details
        self.icon = icon
        self.onTitle = onTitle ?? title
        self.onIcon = onIcon ?? icon
        self.action = action
        self.selected = selected
        self.isOn = on
        self.showLine = showLine
        self.selectable = true
    }
}

// MARK: - Actions

public extension SFMenuAction {
    
    static let seperatorIdentifier = "NCMenuAction.SEPARATOR"
    static let seperatorHeight: CGFloat = 0.5
    
}
