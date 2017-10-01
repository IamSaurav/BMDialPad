//
//  BMDialView.swift
//  DialPad
//
//  Created by Saurav Satpathy on 18/09/17.
//  Copyright © 2017 Saurav Satpathy. All rights reserved.
//

import UIKit
import AudioToolbox

class BMDialView: UIView {
    
    var callTapped: ((String)->())?
    var ThemeColor = UIColor(red: 21/255.0, green: 134/255.0, blue: 88/255.0, alpha: 1.0)
    private var padView: UIView?
    private var textField: UITextField?
    private var deleteBtnTimer: Timer?
    private var numberTimer: Timer?
    
    func setupDialPad(frame: CGRect)
    {
        self.frame = frame
        setupUI()
    }
    
    private func setupUI() -> Void {
        let requiredKeyPadHeight = (self.frame.size.width / 5) * 6 + 50
        textField = UITextField()
        textField?.tintColor = UIColor.clear
        let gap = self.frame.size.width/5
        textField?.frame = CGRect.init(x: gap/2, y: (frame.size.height - requiredKeyPadHeight - 100)/2, width: self.frame.size.width-gap, height: 100)
        textField?.adjustsFontSizeToFitWidth = true
        textField?.textAlignment = NSTextAlignment.center
        textField?.textColor = ThemeColor;
        textField?.inputView = padView
        textField?.inputAccessoryView = padView
        let backspaceButton = UIButton.init(type: UIButtonType.system)
        let image = UIImage(named:"Backspace")?.withRenderingMode(.alwaysTemplate)
        backspaceButton.tintColor = ThemeColor
        backspaceButton.setBackgroundImage(image, for: UIControlState.normal)
        backspaceButton.addTarget(self, action: #selector(backspaceTapped), for: UIControlEvents.touchUpInside)
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressedDeleteBtn))
        longPress.minimumPressDuration = 0.3
        backspaceButton.addGestureRecognizer(longPress)
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
        let xGap: CGFloat = (self.frame.size.width - (width * 3))/4
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
            addLongPressRecogniser(btn: btn)
            x +=  xGap + width
            x = x > maxX ? xGap : x
        }
        
        let callBtn: UIButton = UIButton()
        callBtn.addTarget(self, action: #selector(call), for: UIControlEvents.touchUpInside)
        callBtn.titleLabel?.font = UIFont.init(name: "HelveticaNeue-UltraLight", size: 20)
        callBtn.setImage(UIImage.init(named: "Phone Filled"), for: UIControlState.normal)
        callBtn.backgroundColor = ThemeColor
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
        btn.layer.borderColor = ThemeColor.cgColor
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
        let soundNo = 1220 + index
        AudioServicesPlaySystemSound(SystemSoundID(soundNo))
    }
    
    @objc private func call(btn: UIButton) {
        callTapped?((textField?.text)!)
    }
    
    @objc private func longPressedDeleteBtn(gesture: UILongPressGestureRecognizer) {
        if(gesture.state == .began){
            deleteBtnTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (t) in
                self.deleteLast()
            })
        }
        else {
            deleteBtnTimer?.invalidate()
        }
    }
    
    @objc private func backspaceTapped(btn: UIButton) {
        deleteLast()
    }
    
    @objc private func longPressedButton(gesture: UILongPressGestureRecognizer) {
        if(gesture.state == .began){
            let btn = gesture.view as! UIButton
            let index = btn.tag - 1000
            let digit = defaultDigits()[index]
            textField?.rightViewMode = (textField?.text?.isEmpty)! ? .never : .always
            var subList = Array((digit.letters?.characters)!)
            var i = 0
            numberTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (t) in
                if(subList.count > i){
                    let ch = subList[i]
                    if(i > 0){
                        self.deleteLast()
                    }
                    self.textField?.text?.append(ch)
                    i += 1
                }
                else{
                    self.deleteLast()
                    i = 0
                }
            })
        }
        else if(gesture.state == .ended || gesture.state == .failed){
            numberTimer?.invalidate()
        }
    }
    
    func deleteLast()  {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            self.textField?.text?.characters = (self.textField?.text?.characters.dropLast())!
        }, completion: { (finished: Bool) in
            self.textField?.rightViewMode = (self.textField?.text?.isEmpty)! ? .never : .always
        })
    }
    
    func buttonAttTitle(number: String, letter: String) -> NSAttributedString {
        let numberAtt = NSMutableAttributedString.init(string: number, attributes: [NSForegroundColorAttributeName : ThemeColor, NSFontAttributeName : UIFont.init(name: "HelveticaNeue-UltraLight", size: 40)!])
        if(!letter.isEmpty){
            let letterAtt = NSAttributedString.init(string: "\n" + letter, attributes: [NSForegroundColorAttributeName : ThemeColor, NSFontAttributeName : UIFont.init(name: "HelveticaNeue-UltraLight", size: 15)!])
            numberAtt.append(letterAtt)
        }
        return numberAtt
    }
    
    func addLongPressRecogniser(btn: UIButton) {
        let gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        gesture.minimumPressDuration = 0.3
        gesture.addTarget(self, action: #selector(longPressedButton))
        btn.addGestureRecognizer(gesture)
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




