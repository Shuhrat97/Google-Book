//
//  BaseViewControllerProtocol.swift
//  GoogleBooks
//
//  Created by Shuhrat Nurov on 23/12/22.
//

import Foundation
import SwiftLoader
import SwiftMessages

protocol BaseViewControllerProtocol: AnyObject {
    func preloader(show: Bool)
    func showError(message: String?)
    func showAlert(viewCtrl: UIViewController?, title: String?, message: String?, okTitle: String?, cancelTitle: String?, completion: ((_ isOk: Bool) -> Void)?)
}

extension BaseViewControllerProtocol{
    func preloader(show: Bool) {
        show ? SwiftLoader.show(animated: true) : SwiftLoader.hide()
    }
    
    func showError(message: String?) {
        if let message = message {
            showInfoMessage(msg: message)
        }
    }
    
    private func showInfoMessage(msg: String, type: Theme = .error)  {
        let error = MessageView.viewFromNib(layout: .cardView)
        error.configureTheme(type)
        error.configureContent(title: "", body: msg)
        
        error.button?.isHidden = true
        var config = SwiftMessages.Config()
        config.presentationContext = .automatic
        config.dimMode = .gray(interactive: true)
        if type == .info {
            config.presentationStyle = .center
        }
        SwiftMessages.show(config: config, view: error)
    }
    
    func showAlert(viewCtrl: UIViewController?, title:String?, message: String?, okTitle: String?, cancelTitle: String?, completion: ((_ isCancel: Bool) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let okTitle = okTitle {
            alert.addAction(.init(highlited: okTitle, handler: { (action) in
                completion?(true)
            }))
        }
        
        if let cancelTitle = cancelTitle {
            alert.addAction(.init(highlited: cancelTitle, handler: { (action) in
                completion?(false)
            }))
        }
        viewCtrl?.present(alert, animated: true, completion: nil)
    }
}

func DLog(_ items: Any..., separator: String = " ", terminator: String = "\n") -> Void {
    #if DEBUG
    Swift.print(items, separator: separator, terminator: terminator)
    #else
    //not log
    #endif
}
