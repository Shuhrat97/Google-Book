//
//  FavoriteBooksViewController.swift
//  GoogleBooks
//
//  Created by Shuhrat Nurov on 24/12/22.
//

import UIKit

class FavoriteBooksViewController: UIViewController {
    
    private let tableView:UITableView = {
        let table = UITableView()
        table.register(BookTableViewCell.self, forCellReuseIdentifier: "BookTableViewCell")
        table.separatorStyle = .none
        return table
    }()
    
    private let presenter = FavoriteBooksPresenter()
    
    private var books:[Book] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Избранное"

    
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        presenter.setViewDelegate(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getPhotos()
    }
    
}

extension FavoriteBooksViewController:UITableViewDelegate, UITableViewDataSource{
    
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
        cell?.reload(book: book, isFavorite: true)
        cell?.btnCallback = { [weak self] in
            guard let strongSelf = self else { return }
            UserPreferences.shared.favoriteBooks.remove(book)
            strongSelf.books.remove(at: indexPath.row)
            strongSelf.tableView.reloadData()
        }
        
        cell?.previewCallback = { [weak self] in
            if let url = URL(string: book.volumeInfo.previewLink) {
                UIApplication.shared.open(url)
            }
            
        }
        
        return cell!
    }
    
    
}

extension FavoriteBooksViewController: FavoriteBooksPresenterDelegate{
    func presentBooks(_ books: [Book]) {
        self.books = books
        tableView.reloadData()
    }
}
