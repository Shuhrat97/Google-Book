//
//  UIAlertAction+Extension.swift
//  GoogleBooks
//
//  Created by Shuhrat Nurov on 24/12/22.
//

import UIKit

extension UIAlertAction {
    
    @objc convenience init(highlited title: String?, handler: ((UIAlertAction) -> Void)?) {
        self.init(title: title, style: .default, handler: handler)
        makeHighlitedAction()
    }
    
    func makeHighlitedAction() {
        setValue(UIColor.systemBlue, forKey: "titleTextColor")
    }
    
}
