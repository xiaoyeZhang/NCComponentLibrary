//
//  SFMainMenuTableViewController.swift
//  Saifanbox
//
//  Created by who on 2024/2/28.
//

import UIKit
import FloatingPanel

extension Array where Element == SFMenuAction {
    var listHeight: CGFloat { reduce(0, { $0 + $1.rowHeight }) }
}

public class SFMainMenuTableViewController: UITableViewController {

    // 背景颜色
    open var brandElement: UIColor = .white {
        didSet {
            changeTheming()
        }
    }
    
    // 分割线颜色
    open var lineLabelColor: UIColor =  UIColor(red: 0.0, green: 0.0, blue: 0.96, alpha: 1.0) {
        didSet {
            changeTheming()
        }
    }
    // 文字颜色
    open var actionNameLabelColor: UIColor =  UIColor(red: 0.0, green: 0.0, blue: 0.13, alpha: 1.0) {
        didSet {
            changeTheming()
        }
    }

    public var actions = [SFMenuAction]()

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = brandElement
        tableView.register(SFMenuActionCell.self, forCellReuseIdentifier: "SFMenuActionCell")
        tableView.separatorStyle = .none
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeTheming()
    }
    
    @objc func changeTheming() {
        view.backgroundColor = brandElement
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    public override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return actions.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SFMenuActionCell") as? SFMenuActionCell
        if cell == nil {
            cell = SFMenuActionCell.init(style: .default, reuseIdentifier: "SFMenuActionCell")
        }
        
        let action = actions[indexPath.row]
        cell!.actionIconImage.layer.cornerRadius = 6
        cell!.actionIconImage.layer.masksToBounds = true
        cell!.actionIconImage.contentMode = .scaleAspectFill
        if action.action == nil {
            cell!.selectionStyle = .none
        }

        if (action.isOn) {
            cell!.actionIconImage.image = action.onIcon
            cell!.actionNameLabel.text = action.onTitle
        } else {
            cell!.actionIconImage.image = action.icon
            cell!.actionNameLabel.text = action.title
        }

        if actions.count == indexPath.row + 1  {
            cell!.lineLabel.isHidden = true
        }else{
            cell!.lineLabel.isHidden = false
        }
        
        if !action.showLine {
            cell!.lineLabel.isHidden = true
        }
        
        cell!.backgroundColor = brandElement
        cell!.lineLabel.backgroundColor = lineLabelColor
        cell!.actionNameLabel.textColor = actionNameLabelColor
        if action.titleColor != nil {
            cell!.actionNameLabel.textColor = action.titleColor
        }
        cell!.accessoryType = action.selectable && action.selected ? .checkmark : .none

        return cell!
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuAction = actions[indexPath.row]
        if let action = menuAction.action {
            self.dismiss(animated: true, completion: nil)
            action(menuAction)
        }
    }

    // MARK: - Accessibility
    
    open override func accessibilityPerformEscape() -> Bool {
        dismiss(animated: true)
        return true
    }
    
}

extension SFMainMenuTableViewController: FloatingPanelControllerDelegate {

    public func floatingPanel(_ fpc: FloatingPanelController, layoutFor size: CGSize) -> FloatingPanelLayout {
        return SFMenuFloatingPanelLayout(actionsHeight: self.actions.listHeight)
    }

    public func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return SFMenuFloatingPanelLayout(actionsHeight: self.actions.listHeight)
    }

    public func floatingPanel(_ fpc: FloatingPanelController, animatorForDismissingWith velocity: CGVector) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut)
    }

    public func floatingPanel(_ fpc: FloatingPanelController, animatorForPresentingTo state: FloatingPanelState) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
    }

    public func floatingPanelWillEndDragging(_ fpc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        guard velocity.y > 750 else { return }
        fpc.dismiss(animated: true, completion: nil)
    }
}
