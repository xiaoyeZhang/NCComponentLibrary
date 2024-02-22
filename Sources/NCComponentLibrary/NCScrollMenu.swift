//
//  NCScrollMenu.swift
//  CyphyCloud
//
//  Created by who on 2021/12/2.
//  Copyright © 2021 Marino Faggiana. All rights reserved.
//

import UIKit
import SnapKit

let kScreen_width: CGFloat = UIScreen.main.bounds.size.width
let kScreen_height:CGFloat = UIScreen.main.bounds.size.height

public class meunList: NSObject {
    
    open var titleStr = ""
    open var butTag: Int = 0
    open var icon = ""
}

/// 菜单模式枚举
public enum NCMeunMode: Int {
    case onlyText // 只有文字
    case iconAndText // 图标加文字
}

public class NCScrollMenu: UIView {

    open var meunList: [meunList] = [] {
        didSet {
            setMenuView()
        }
    }
    open var meunStyle: NCMeunMode = .onlyText { ///< 选择样式 默认 onlyText
        didSet {
            if meunStyle != .onlyText  {
                for view in arr {
                    view.removeFromSuperview()
                }
                arr.removeAll()
                setMenuView()
            }
        }
    }
    // 背景view的颜色
    open var baseViewColor: UIColor = .white
    // 底部线的颜色
    open var lineBgColor: UIColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.0)
    // 文字的颜色
    open var textDefaultView: UIColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.0)
    // 未选中文字的颜色
    open var textHeadDisView: UIColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.0)
    // 自定义选中颜色
    open var brandElement: UIColor = UIColor(red: 0.03, green: 0.46, blue: 0.98, alpha: 1.0)

    var isAddBtn:Bool = false
    open var isClearColor:Bool = false {// 背景是否透明
        didSet {
            if isClearColor {
                baseViewColor = .clear
                self.backgroundColor = .clear
                self.menuScrollview.backgroundColor = .clear
            }
        }
    }
    open var titleFont: CGFloat = 15 {// 文字的字体大小
        didSet{
            changeTextFont()
        }
    }
    open var maxNumView: Int = 4 // 一屏最多显示几个视图 默认4个 为0时不起作用 此属性只有在 isBisect为true时 有效 //
    open var isBisect:Bool = false // 是否平分
    open var isChangeBtnItemColor:Bool = false // 是否改变按钮文字颜色
    open var isChangeBtnItemFont:Bool = false // 是否改变按钮文字大小
    open var isChangeBtnBoldFont:Bool = false // 是否改变按钮文字粗细
    open var showBtnLine:Bool = true // 是否显示按钮下方的线
    open var showBottonLine:Bool = true // 是否显示下方的线

    let lineBg = UILabel()
    
    var arr: Array<UIView> = []
    var beforeLeft: Array<Any> = [] // 按钮的初始位置
    var menuScrollview = UIScrollView()
    
    public weak var delegate : NCScrollMenuDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        addMenuScrollview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addMenuScrollview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addMenuScrollview() {
        
        self.addSubview(menuScrollview)
        menuScrollview.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
    }
    
    public func setMenuView() {
        
        if meunStyle == .iconAndText {
            isAddBtn = false
            addIconAndTextView()
        } else {
            addTextBtnView()
        }
    }
    
    func addTextBtnView() {
        
        self.backgroundColor = baseViewColor
        
        if isAddBtn {

            for linkArr in arr {

                let btnItem:UILabel = linkArr as! UILabel
                btnItem.textColor = textDefaultView
                
            }
            menuScrollview.backgroundColor = baseViewColor

            lineBg.backgroundColor = lineBgColor
            
            return
        }
        
        lineBg.backgroundColor = lineBgColor
        
        if showBottonLine {
            self.addSubview(lineBg)
            lineBg.snp.makeConstraints { (make) in
                // 宽高设置为1
                make.width.equalTo(self)
                make.height.equalTo(1)
                make.bottom.equalTo(0)
                // 在父视图居中显示
            }
        }
        
        var beforeStrWidth:Int = 0
        for meunItem in meunList {
            
            isAddBtn = true
            let btnItem = UILabel()
            
            btnItem.tag = meunItem.butTag
            btnItem.text = meunItem.titleStr
            btnItem.isUserInteractionEnabled = true
            btnItem.textAlignment = .center
            btnItem.font = UIFont.systemFont(ofSize: titleFont)
            btnItem.backgroundColor = UIColor.clear
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapViewBtn))
            tap.numberOfTapsRequired = 1
            btnItem.addGestureRecognizer(tap)
            
            menuScrollview.addSubview(btnItem)
            
            let labelStrWidth:Int = Int(getLabWidth(labelStr: meunItem.titleStr, font: btnItem.font, height: 50))
            var strWidth:Int = labelStrWidth
            if isBisect {
                let meunListCount = maxNumView == 0 ? meunList.count : maxNumView
                strWidth = Int(currentDeviceType() == "iPad" ? kScreen_width * 0.45 : kScreen_width) / meunListCount
                beforeStrWidth += strWidth
                beforeLeft.append(["left": beforeStrWidth - strWidth, "width": strWidth])
            } else {
                beforeStrWidth += (strWidth + 25)
                beforeLeft.append(["left":beforeStrWidth - (strWidth + 25),"width": strWidth + 25])
            }
            
            btnItem.snp.makeConstraints { (make) in
                // 宽高设置为100
                if isBisect {
                    make.width.equalTo(strWidth)
                    make.left.equalTo(beforeStrWidth - strWidth)
                } else {
                    make.width.equalTo(strWidth + 25)
                    make.left.equalTo(beforeStrWidth - (strWidth + 25))
                }
                make.height.equalTo(self)
                // 在父视图居中显示
                make.centerY.equalToSuperview()
            }
            
            if showBtnLine {
                let lineItem = UILabel()
                if meunItem.butTag != 1 {
                    lineItem.isHidden = true
                }else{
                    lineItem.isHidden = false
                    if isChangeBtnItemFont {
                        btnItem.font = UIFont.systemFont(ofSize: titleFont + 1)
                    }
                    if isChangeBtnBoldFont {
                        btnItem.font = UIFont.boldSystemFont(ofSize: btnItem.font.pointSize)
                    }
                }
                lineItem.tag = meunItem.butTag + 999
                
                lineItem.backgroundColor = textDefaultView
                lineItem.layer.cornerRadius = 1.5
                lineItem.layer.masksToBounds = true
                btnItem.addSubview(lineItem)
                
                lineItem.snp.makeConstraints { (make) in
                    // 宽高设置为100
                    make.width.equalTo(Int(Double(labelStrWidth) * 0.4))
                    make.height.equalTo(3)
                    make.bottom.equalTo(0)
                    // 在父视图居中显示
                    make.centerX.equalToSuperview()
                }
            }
            arr.append(btnItem)
        }
        
        menuScrollview.contentSize = CGSize(width: CGFloat(beforeStrWidth), height: self.frame.size.height)

        menuScrollview.showsHorizontalScrollIndicator = false
    }
    
    func addIconAndTextView() {
        
        self.backgroundColor = baseViewColor
        
        if isAddBtn {
            menuScrollview.backgroundColor = baseViewColor
            lineBg.backgroundColor = lineBgColor
            return
        }
        
        lineBg.backgroundColor = lineBgColor
        
        if showBottonLine {
            self.addSubview(lineBg)
            lineBg.snp.makeConstraints { (make) in
                // 宽高设置为1
                make.width.equalTo(self)
                make.height.equalTo(1)
                make.bottom.equalTo(0)
                // 在父视图居中显示
            }
        }

        var beforeStrWidth:Int = 0
        for meunItem in meunList {
            
            isAddBtn = true
            let meunViewItem = UIView()
            
            meunViewItem.tag = meunItem.butTag
            meunViewItem.isUserInteractionEnabled = true
            meunViewItem.backgroundColor = UIColor.clear
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapViewBtn))
            tap.numberOfTapsRequired = 1
            meunViewItem.addGestureRecognizer(tap)
            menuScrollview.addSubview(meunViewItem)
            
            let meunItemIcon = UIImageView()
            meunItemIcon.image = UIImage(named: meunItem.icon)
            meunViewItem.addSubview(meunItemIcon)
            meunItemIcon.snp.makeConstraints { make in
                make.centerX.equalTo(meunViewItem)
                make.centerY.equalTo(meunViewItem).offset(-10)
                make.size.equalTo(30)
            }
            
            let meunItemText = UILabel()
            
            meunItemText.text = meunItem.titleStr
            meunItemText.textColor = textDefaultView
            meunItemText.textAlignment = .center
            meunItemText.font = UIFont.systemFont(ofSize: titleFont)
            meunViewItem.addSubview(meunItemText)
            meunItemText.snp.makeConstraints { make in
                make.top.equalTo(meunItemIcon.snp.bottom).offset(8)
                make.left.right.equalTo(meunViewItem)
            }
            let labelStrWidth:Int = Int(getLabWidth(labelStr: meunItem.titleStr, font: meunItemText.font, height: 50))
            var strWidth:Int = labelStrWidth
            if isBisect {
                let meunListCount = maxNumView == 0 ? meunList.count : maxNumView
                strWidth = Int(currentDeviceType() == "iPad" ? kScreen_width * 0.45 : kScreen_width) / meunListCount
                beforeStrWidth += strWidth
                beforeLeft.append(["left": beforeStrWidth - strWidth, "width": strWidth])
            } else {
                beforeStrWidth += (strWidth + 25)
                beforeLeft.append(["left":beforeStrWidth - (strWidth + 25),"width": strWidth + 25])
            }
            
            meunViewItem.snp.makeConstraints { (make) in
                // 宽高设置为100
                if isBisect {
                    make.width.equalTo(strWidth)
                    make.left.equalTo(beforeStrWidth - strWidth)
                } else {
                    make.width.equalTo(strWidth + 25)
                    make.left.equalTo(beforeStrWidth - (strWidth + 25))
                }
                make.height.equalTo(self)
                // 在父视图居中显示
                make.centerY.equalToSuperview()
            }
            arr.append(meunViewItem)
        }
        
        menuScrollview.contentSize = CGSize(width: CGFloat(beforeStrWidth), height: self.frame.size.height)

        menuScrollview.showsHorizontalScrollIndicator = false
    }
    
    func changeTextFont() {
        if meunStyle == .onlyText {
            for tagitemView in arr {
                let btnItem:UILabel = tagitemView as! UILabel
                btnItem.font = UIFont.systemFont(ofSize: titleFont)
            }
        }
    }
    
    public func isLineShow(tag: Int) {
        if meunStyle == .onlyText {
            for tagitemView in arr {
                
                for subview in tagitemView.subviews {
                    if subview.tag == 999 + tag {//此处以tag对某个view标识
                        subview.isHidden = false
                    }else{
                        subview.isHidden = true
                    }
                    subview.backgroundColor = textDefaultView
                    if isChangeBtnItemColor {
                        subview.backgroundColor = brandElement
                    }
                }
                tagitemView.backgroundColor = UIColor.clear
                
                let btnItem:UILabel = tagitemView as! UILabel
                btnItem.textColor = textDefaultView
                if btnItem.tag == tag {
                    if isChangeBtnItemColor {
                        btnItem.textColor = brandElement
                    }
                    if isChangeBtnItemFont {
                        btnItem.font = UIFont.systemFont(ofSize: titleFont + 1)
                    }
                    if isChangeBtnBoldFont {
                        btnItem.font = UIFont.boldSystemFont(ofSize: btnItem.font.pointSize)
                    }
                } else {
                    btnItem.font = UIFont.systemFont(ofSize: titleFont)
                    btnItem.textColor = textHeadDisView
                }
                if !isClearColor {
                    self.backgroundColor = baseViewColor
                } else {
                    self.backgroundColor = .clear
                }
            }
            if !isClearColor {
                menuScrollview.backgroundColor = baseViewColor
            } else {
                menuScrollview.backgroundColor = .clear
            }
            lineBg.backgroundColor = lineBgColor
        } else {
            
        }
    }
    
    @objc func tapViewBtn(gesture: UITapGestureRecognizer) {
        
        let tagView:UIView = gesture.view!
        
        let item: [String: Int] = beforeLeft.last as! [String : Int]

        if (Int(item["left"]!) + Int(item["width"]!)) > Int(self.frame.size.width) {
            managerScrollFromSubView(view: tagView)
        }
        
        if self.delegate != nil && ((self.delegate?.responds(to: Selector.init(("commonHeadBtnViewClick:")))) != nil) {
            self.delegate?.CommonSpaceBtnViewClick(self, sender: tagView)
        }
        
    }
    
    func managerScrollFromSubView(view: UIView) {
        // 距离屏幕中心点距离
        var offsetX: CGFloat = view.center.x - (self.frame.size.width / 2)
        
        if offsetX < 0 {
            offsetX = 0
        }
        
        // 超出屏幕部分的宽度
        let maxRight: CGFloat = self.menuScrollview.contentSize.width - self.frame.size.width;
        
        if offsetX > maxRight {
            // 当前屏幕左侧有超屏内容 只滚动右边剩余量
            offsetX = maxRight
        }
        menuScrollview.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    // 新需求 字符串长度
    func getLabWidth(labelStr:String,font:UIFont,height:CGFloat) -> CGFloat {
        
        let statusLabelText: NSString = labelStr as NSString
        let size = CGSize(width: 900, height: height)
        
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: (dic as! [NSAttributedString.Key : Any]) , context: nil).size
        
        return strSize.width
    }
    
    func currentDeviceType() -> String {
        return UIDevice.current.model
    }
    
}

public protocol NCScrollMenuDelegate : NSObjectProtocol {
    func CommonSpaceBtnViewClick(_ scrollMenuView: NCScrollMenu, sender menuView: UIView)
}
