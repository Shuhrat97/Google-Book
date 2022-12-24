//
//  FavoriteBooksPresenter.swift
//  GoogleBooks
//
//  Created by Shuhrat Nurov on 24/12/22.
//

import Foundation

protocol FavoriteBooksPresenterDelegate: BaseViewControllerProtocol {
    func presentBooks(_ books: [Book])
}

class FavoriteBooksPresenter {
    
    weak var delegate: FavoriteBooksPresenterDelegate?
    
    public func setViewDelegate(delegate: FavoriteBooksPresenterDelegate) {
        self.delegate = delegate
    }
    
    @objc func getPhotos(){
        let books = Array(UserPreferences.shared.favoriteBooks)
        self.delegate?.presentBooks(books)
    }
    
    
}

