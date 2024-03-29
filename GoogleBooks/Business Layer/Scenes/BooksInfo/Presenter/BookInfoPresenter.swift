//
//  FavoriteBooksViewController.swift
//  GoogleBooks
//
//  Created by Shuhrat Nurov on 24/12/22.
//

import Foundation

protocol BookInfoPresenterDelegate: BaseViewControllerProtocol {
    
}

class BookInfoPresenter {
    
    weak var delegate: BookInfoPresenterDelegate?
    
    public func setViewDelegate(delegate: BookInfoPresenterDelegate) {
        self.delegate = delegate
    }
    
}
