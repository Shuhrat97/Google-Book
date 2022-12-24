//
//  SearchViewController.swift
//  GoogleBooks
//
//  Created by Shuhrat Nurov on 24/12/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let tableView:UITableView = {
        let table = UITableView()
        table.register(BookTableViewCell.self, forCellReuseIdentifier: "BookTableViewCell")
        table.separatorStyle = .none
        
        return table
    }()
    
    private let presenter = SearchViewPresenter()
    
    private var books:[Book] = []
    private var favoriteBooks = Array(UserPreferences.shared.favoriteBooks)
    private var searchedText = ""
    private var page = 0
    private var totalItems = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Поиск"
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        configSearchBar()
        
        presenter.setViewDelegate(delegate: self)
    }
    
    private func configSearchBar(){
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        search.searchBar.delegate = self
        self.navigationItem.searchController = search
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func reload(){
        favoriteBooks = Array(UserPreferences.shared.favoriteBooks)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    private func insertBook(book:Book){
        showAlert(viewCtrl: self, title: "Message", message: "Do you want add to favourite?", okTitle: "Yes", cancelTitle: "No") { isOk in
            if isOk {
                UserPreferences.shared.favoriteBooks.insert(book)
                self.reload()
            }
        }
    }
    
    private func removeBook(book:Book){
        showAlert(viewCtrl: self, title: "Message", message: "Do you want remove from favorites?", okTitle: "Yes", cancelTitle: "No") { isOk in
            if isOk {
                UserPreferences.shared.favoriteBooks.remove(book)
                self.reload()
            }
        }
    }

}

extension SearchViewController: SearchViewPresenterDelegate{
    func presentBooks(_ books: [Book], totalItems:Int) {
        DispatchQueue.main.async{
            self.preloader(show: false)
            self.books.append(contentsOf: books)
            self.totalItems = totalItems
            self.reload()
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        let ctrl = BookInfoViewController(book: book)
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath as IndexPath) as? BookTableViewCell
        cell?.selectionStyle = .none
        let book = books[indexPath.row]
        let isFavorite:Bool = UserPreferences.shared.favoriteBooks.contains { item in
            item.id == book.id
        }
        
        cell?.reload(book: book, isFavorite: isFavorite)
        cell?.btnCallback = { [weak self] in
            guard let strongSelf = self else { return }
            if isFavorite {
                strongSelf.removeBook(book: book)
            } else {
                strongSelf.insertBook(book: book)
            }
        }
        
        cell?.previewCallback = { [weak self] in
            if let url = URL(string: book.volumeInfo.previewLink) {
                UIApplication.shared.open(url)
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == books.count - 1) && totalItems > books.count {
            page += 1
            let startIndex = page + books.count
            presenter.getFilteredBooks(text: searchedText, startIndex: startIndex)
        }
    }
    
    
}

extension SearchViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    // MARK: - SearchBarCancel
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        books = []
        searchedText = ""
        page = 0
        totalItems = 0
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text ?? ""
        let str = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !str.isEmpty else {
            self.searchedText = ""
            self.tableView.reloadData()
            return
        }
        self.books = []
        self.page = 0
        self.totalItems = 0
        view.endEditing(true)
        searchedText = text
        presenter.getFilteredBooks(text: text, startIndex: 0)
    }
}
