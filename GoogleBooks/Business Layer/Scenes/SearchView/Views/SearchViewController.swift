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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath as IndexPath) as? BookTableViewCell
        cell?.selectionStyle = .none
        let book = books[indexPath.row]
        var isFavorite:Bool = false
        favoriteBooks.forEach { item in
            if item.id == book.id {
                isFavorite = true
            }
        }
        cell?.reload(book: book, isFavorite: isFavorite)
        cell?.btnCallback = { [weak self] in
            guard let strongSelf = self else { return }
            if isFavorite {
                UserPreferences.shared.favoriteBooks.remove(book)
            } else {
                UserPreferences.shared.favoriteBooks.insert(book)
            }
            strongSelf.reload()
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
