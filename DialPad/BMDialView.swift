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
    public static let requiredHeight = (UIScreen.main.bounds.width / 5) * 6
    
    func setupDialPad(frame: CGRect)
    {
        self.frame = frame
        setupUI()
    }
    
    
    private func setupUI() -> Void {
        padView = UIView()
        self.addSubview(padView!)
        
        let digitsList = digits()
        
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
            let btn = createButton(number: digit.number!, letter: digit.letters!, frame: frame)
            btn.tag = i + 1000
            x +=  xGap + width
            x = x > maxX ? xGap : x
        }
        
//        let callBtn: UIButton = UIButton()
//        btn.addTarget(self, action: #selector(buttonTapped), for: UIControlEvents.touchUpInside)
//        btn.titleLabel?.font = UIFont.init(name: "HelveticaNeue-UltraLight", size: 20)
//        btn.frame = frame;
        
        
    }
    
    private func createButton(number: String, letter: String, frame: CGRect) -> UIButton {
        let btn: UIButton = UIButton()
        btn.addTarget(self, action: #selector(buttonTapped), for: UIControlEvents.touchUpInside)
        btn.titleLabel?.font = UIFont.init(name: "HelveticaNeue-UltraLight", size: 20)
        btn.frame = frame;
        btn.layer.cornerRadius = frame.width/2
        btn.layer.borderColor = GreenColor.cgColor
        btn.layer.borderWidth = 2
        btn.layer.masksToBounds = true
        self.padView?.addSubview(btn)
        let numberAtt = NSMutableAttributedString.init(string: number, attributes: [NSForegroundColorAttributeName : GreenColor, NSFontAttributeName : UIFont.init(name: "HelveticaNeue-UltraLight", size: 40)!])
        
        let letterAtt = NSAttributedString.init(string: "\n" + letter, attributes: [NSForegroundColorAttributeName : GreenColor, NSFontAttributeName : UIFont.init(name: "HelveticaNeue-UltraLight", size: 15)!])
        numberAtt.append(letterAtt)
        btn.setAttributedTitle(numberAtt, for: UIControlState.normal)
        return btn
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        
    }
    
    private func digits() -> [PhoneDigit] {
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




