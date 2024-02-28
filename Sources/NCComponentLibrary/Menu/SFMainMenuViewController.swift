//
//  SFMainMenuViewController.swift
//  Saifanbox
//
//  Created by who on 2024/2/27.
//

import UIKit
import FloatingPanel

public class SFMainMenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // 背景颜色
    open var brandElement: UIColor = .white {
        didSet {
            changeTheming()
        }
    }
    // 文字颜色
    open var nameLabelColor: UIColor =  UIColor(red: 0.0, green: 0.0, blue: 0.13, alpha: 1.0) {
        didSet {
            changeTheming()
        }
    }
   
    public var actions = [SFMenuAction]()
    
    lazy var collectView:UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        
        let devicename = UIDevice.currentDeviceType()
        var sizeWidth:CGFloat = 2
        if devicename == "iPad" {
            sizeWidth = 50
        }
        layout.itemSize = CGSize(width: (kScreen_width - sizeWidth) / 3 , height: 120)
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1
        let collectView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        collectView.backgroundColor = .clear
        collectView.delegate = self
        collectView.dataSource = self
        collectView.showsVerticalScrollIndicator = true
        collectView.register(SFMainMenuCollectionViewCell.self, forCellWithReuseIdentifier: "SFMainMenuCollectionViewCell")

        
        return collectView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setAddMenu()
                
        changeTheming()
    }
    
    @objc func changeTheming() {
        
        view.backgroundColor = brandElement
        collectView.reloadData()
    }
    
    func setAddMenu() {
        self.view.addSubview(self.collectView)

    }
    
    // #mark --- UICollectionViewDelegate
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.actions.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SFMainMenuCollectionViewCell", for: indexPath) as! SFMainMenuCollectionViewCell
        let action = actions[indexPath.row]
        cell.nameLabel.text = action.title
        cell.iconImage.image = action.icon
        cell.nameLabel.textColor = nameLabelColor
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menuAction = actions[indexPath.row]
        if let action = menuAction.action {
            self.dismiss(animated: true, completion: nil)
            action(menuAction)
        }
    }
    
}
extension SFMainMenuViewController: FloatingPanelControllerDelegate {

    public func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        var heightCount: Int
        heightCount = (self.actions.count % 3 == 0 ? self.actions.count / 3 : self.actions.count / 3 + 1) * 120
        return SFMenuFloatingPanelLayout(actionsHeight: CGFloat(heightCount))
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

