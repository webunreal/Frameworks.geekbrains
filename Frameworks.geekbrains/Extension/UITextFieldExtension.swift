//
//  UITextFieldExtension.swift
//  Frameworks.geekbrains
//
//  Created by Nikolai Ivanov on 07.04.2021.
//

import UIKit

extension UITextField {
    func leadingTextPadding(_ width: CGFloat) {
        let paddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        )
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func trailingTextPadding(_ width: CGFloat) {
        let paddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        )
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
