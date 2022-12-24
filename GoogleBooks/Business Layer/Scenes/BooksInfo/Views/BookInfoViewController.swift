//
//  FavoriteBooksViewController.swift
//  GoogleBooks
//
//  Created by Shuhrat Nurov on 24/12/22.
//

import UIKit

class BookInfoViewController: UIViewController {
    
    private let presenter = BookInfoPresenter()
    
    private let imageView:UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 10
        imgView.layer.borderColor = UIColor.black.cgColor
        imgView.layer.borderWidth = 0.3
        return imgView
    }()
    
    private let titleLabel:UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .black
        
        return lbl
    }()
    
    private let dateLabel:UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .black
        
        return lbl
    }()
    
    private let languageLabel:UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .black
        
        return lbl
    }()
    
    private let descriptionLabel:UITextView = {
        let lbl = UITextView()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .black
        lbl.isEditable = false
        return lbl
    }()
    
    private let book: Book

    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isFavourite()->Bool{
        let isFavourite = UserPreferences.shared.favoriteBooks.contains { item in
            item.id == book.id
        }
        return isFavourite
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        presenter.setViewDelegate(delegate: self)
        
        setupRightBtn()
        
        setupViews()

        let url = URL(string: book.volumeInfo.imageLinks?.thumbnail ?? "")
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        
        titleLabel.text = "Title: " + book.volumeInfo.title
        dateLabel.text = "Publisheed date: " + book.volumeInfo.publishedDate
        languageLabel.text = "Language: " + book.volumeInfo.language
        
        if let description = book.volumeInfo.description {
            descriptionLabel.text = "Description: " + description
        } else {
            descriptionLabel.text = ""
        }
        
        
    }
    
    private func setupRightBtn(){
        let image = isFavourite() ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        let rightBtn = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(favouriteBtnTapped))
        
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    private func setupViews(){
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(languageLabel)
        view.addSubview(descriptionLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        languageLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(languageLabel.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func favouriteBtnTapped(){
        let title = isFavourite() ? "Do you want remove from favorites?" : "Do you want add to favourite?"
        showAlert(viewCtrl: self, title: "Message", message: title, okTitle: "Yes", cancelTitle: "No") { isOk in
            if self.isFavourite() {
                if isOk{
                    UserPreferences.shared.favoriteBooks.remove(self.book)
                    self.setupRightBtn()
                }
            } else {
                if isOk{
                    UserPreferences.shared.favoriteBooks.insert(self.book)
                    self.setupRightBtn()
                }
            }
        }
    }
    
}

extension BookInfoViewController: BookInfoPresenterDelegate{
    
}
