//
//  SearchViewPresenter.swift
//  GoogleBooks
//
//  Created by Shuhrat Nurov on 24/12/22.
//

import UIKit

protocol SearchViewPresenterDelegate: BaseViewControllerProtocol {
    func presentBooks(_ books: [Book], totalItems:Int)
}

class SearchViewPresenter {
    
    weak var delegate: SearchViewPresenterDelegate?
    
    public func setViewDelegate(delegate: SearchViewPresenterDelegate) {
        self.delegate = delegate
    }
    
    func getFilteredBooks(text:String,startIndex:Int){
        if startIndex == 0{
            delegate?.preloader(show: true)
        }
        let text = text.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(text)&startIndex=\(startIndex)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(FilterResponse.self, from: data)
                self.delegate?.presentBooks(model.items, totalItems: model.totalItems)
            } catch {
                self.delegate?.showError(message: error.localizedDescription)
            }
        }
        task.resume()
    }
    
}

