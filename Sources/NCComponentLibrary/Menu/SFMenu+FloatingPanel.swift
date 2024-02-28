//
//  SFMenu+FloatingPanel.swift
//  Saifanbox
//
//  Created by who on 2024/2/28.
//

import Foundation
import FloatingPanel
import UIKit

class SFMenuFloatingPanelLayout: FloatingPanelLayout {
    var position: FloatingPanelPosition = .bottom

    var initialState: FloatingPanelState = .full

    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        [
            .full: FloatingPanelLayoutAnchor(absoluteInset: topInset, edge: .top, referenceGuide: .superview)
        ]
    }

    let topInset: CGFloat

    init(actionsHeight: CGFloat) {
        // sometimes UIScreen.main.bounds.size.height is not updated correctly
        // this ensures we use the correct height value
        // can't use `layoutFor size` since menu is dieplayed on top of the whole screen not just the VC
        let screenHeight = UIDevice.current.orientation.isLandscapeHardCheck
        ? min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        : max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        var bottomInset: CGFloat = 0.0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.first { $0.isKeyWindow }
            bottomInset = window?.rootViewController?.view.safeAreaInsets.bottom ?? 0
        } else {
            bottomInset = UIDevice.vg_safeDistanceBottom()
        }
        let panelHeight = CGFloat(actionsHeight) + bottomInset

        topInset = max(48, screenHeight - panelHeight)
    }

    func prepareLayout(surfaceView: UIView, in view: UIView) -> [NSLayoutConstraint] {
        return [
            surfaceView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            surfaceView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
        ]
    }

    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.2
    }
}

public class SFMenuPanelController: FloatingPanelController {

    public var parentPresenter: UIViewController?

    // MARK: - View Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            self.surfaceView.backgroundColor = .systemBackground
        }
        self.surfaceView.backgroundColor = .white
        self.isRemovalInteractionEnabled = true
        self.isRemovalInteractionEnabled = true
        self.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        self.surfaceView.grabberHandleSize = CGSize(width: 0.0, height: 0.0)

        // Create a new appearance.
        let appearance = SurfaceAppearance()
        // Define corner radius and background color
        appearance.cornerRadius = 20.0

        // Set the new appearance
        self.surfaceView.appearance = appearance
        
//        surfaceView.grabberHandle.accessibilityLabel = NSLocalizedString("_cart_controller_", comment: "")
//        let collapseName = NSLocalizedString("_dismiss_menu_", comment: "")
//        let collapseAction = UIAccessibilityCustomAction(name: collapseName, target: self, selector: #selector(accessibilityActionCollapsePanel))
//        surfaceView.grabberHandle.accessibilityCustomActions = [collapseAction]
//        surfaceView.grabberHandle.isAccessibilityElement = true
    }

    @objc private func accessibilityActionCollapsePanel() {
        self.dismiss(animated: true)
     }
}
