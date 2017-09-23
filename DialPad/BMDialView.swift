//
//  BMDialView.swift
//  DialPad
//
//  Created by Saurav Satpathy on 18/09/17.
//  Copyright © 2017 Saurav Satpathy. All rights reserved.
//

import UIKit

class BMDialView: UIView {
    
    var padView: UIView?
    let GreenColor = UIColor(red: 21/255.0, green: 134/255.0, blue: 88/255.0, alpha: 1.0)
    public var textField: UITextField?
    public var requiredKeyPadHeight = (UIScreen.main.bounds.width / 5) * 6 + 50
    
    func setupDialPad(frame: CGRect)
    {
        self.frame = frame
        setupUI()
    }
    
    private func setupUI() -> Void {
        textField = UITextField()
        textField?.tintColor = GreenColor
        let gap = self.frame.size.width/5
        textField?.frame = CGRect.init(x: gap/2, y: (frame.size.height - requiredKeyPadHeight - 100)/2, width: self.frame.size.width-gap, height: 100)
        textField?.adjustsFontSizeToFitWidth = true
        textField?.textAlignment = NSTextAlignment.center
        textField?.textColor = GreenColor;
        textField?.inputView = padView
        let backspaceButton = UIButton.init(type: UIButtonType.system)
        backspaceButton.setBackgroundImage(UIImage.init(named: "Backspace"), for: UIControlState.normal)
        backspaceButton.addTarget(self, action: #selector(backspaceTapped), for: UIControlEvents.touchUpInside)
        backspaceButton.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        textField?.rightView = backspaceButton
        textField?.rightViewMode = UITextFieldViewMode.never
        textField?.font = UIFont.init(name: "HelveticaNeue-UltraLight", size: 55)
        addSubview(textField!)
        
        padView = UIView()
        padView?.frame = CGRect.init(x: 0, y: frame.size.height - requiredKeyPadHeight, width: self.frame.size.width, height: requiredKeyPadHeight)
        self.addSubview(padView!)
        
        let digitsList = defaultDigits()
        
        let width = self.frame.size.width/5
        let xGap: CGFloat = width/2
        var x: CGFloat = xGap
        var y: CGFloat = 0
        let yGap = xGap/2
        let maxX = (3 * xGap + 2 * width)
        for i in 0 ..< digitsList.count {
            let digit = digitsList[i]
            let row = Float(i / 3).rounded(.towardZero)
            y = CGFloat(row) * (width + yGap)
            let frame = CGRect.init(x: x, y: y, width: width, height: width)
            let btn = createButton(frame: frame)
            btn.tag = i + 1000
            btn.setAttributedTitle(buttonAttTitle(number: digit.number!, letter: digit.letters!), for: UIControlState.normal)
            x +=  xGap + width
            x = x > maxX ? xGap : x
        }
        
        let callBtn: UIButton = UIButton()
        callBtn.addTarget(self, action: #selector(call), for: UIControlEvents.touchUpInside)
        callBtn.titleLabel?.font = UIFont.init(name: "HelveticaNeue-UltraLight", size: 20)
        callBtn.setImage(UIImage.init(named: "Phone Filled"), for: UIControlState.normal)
        callBtn.backgroundColor = GreenColor
        callBtn.frame = CGRect.init(x: ((padView?.frame.size.width)!-width)/2, y: (padView?.frame.size.height)!-width - 30, width: width, height: width)
        callBtn.layer.cornerRadius = callBtn.frame.width/2
        callBtn.layer.masksToBounds = true
        padView?.addSubview(callBtn)
    }
    
    private func createButton(frame: CGRect) -> UIButton {
        let btn: UIButton = UIButton.init(type: UIButtonType.system)
        btn.addTarget(self, action: #selector(buttonTapped), for: UIControlEvents.touchUpInside)
        btn.frame = frame;
        btn.titleLabel?.textAlignment = NSTextAlignment.center
        btn.titleLabel?.numberOfLines = 0
        btn.layer.cornerRadius = frame.width/2
        btn.layer.borderColor = GreenColor.cgColor
        btn.layer.borderWidth = 2
        btn.layer.masksToBounds = true
        self.padView?.addSubview(btn)
        return btn
    }
    
    @objc private func buttonTapped(btn: UIButton) {
        let index = btn.tag - 1000
        let digit = defaultDigits()[index]
        textField?.text?.append(digit.number!)
        textField?.rightViewMode = (textField?.text?.isEmpty)! ? .never : .always
    }
    
    @objc private func call(btn: UIButton) {
        
    }
    
    @objc private func backspaceTapped(btn: UIButton) {
        textField?.text?.characters = (textField?.text?.characters.dropLast())!
        textField?.rightViewMode = (textField?.text?.isEmpty)! ? .never : .always
    }
    
    func buttonAttTitle(number: String, letter: String) -> NSAttributedString {
        let numberAtt = NSMutableAttributedString.init(string: number, attributes: [NSForegroundColorAttributeName : GreenColor, NSFontAttributeName : UIFont.init(name: "HelveticaNeue-UltraLight", size: 40)!])
        if(!letter.isEmpty){
            let letterAtt = NSAttributedString.init(string: "\n" + letter, attributes: [NSForegroundColorAttributeName : GreenColor, NSFontAttributeName : UIFont.init(name: "HelveticaNeue-UltraLight", size: 15)!])
            numberAtt.append(letterAtt)
        }
        return numberAtt
    }
    
    private func defaultDigits() -> [PhoneDigit] {
        var digitList: [PhoneDigit] = [PhoneDigit]()
        digitList.append(PhoneDigit.init(number: "1", letters: ""))
        digitList.append(PhoneDigit.init(number: "2", letters: "ABC"))
        digitList.append(PhoneDigit.init(number: "3", letters: "DEF"))
        digitList.append(PhoneDigit.init(number: "4", letters: "GHI"))
        digitList.append(PhoneDigit.init(number: "5", letters: "JKL"))
        digitList.append(PhoneDigit.init(number: "6", letters: "MNO"))
        digitList.append(PhoneDigit.init(number: "7", letters: "PQRS"))
        digitList.append(PhoneDigit.init(number: "8", letters: "TUV"))
        digitList.append(PhoneDigit.init(number: "9", letters: "WXYZ"))
        digitList.append(PhoneDigit.init(number: "*", letters: ""))
        digitList.append(PhoneDigit.init(number: "0", letters: "+"))
        digitList.append(PhoneDigit.init(number: "#", letters: ""))
        return digitList
    }
    
}




