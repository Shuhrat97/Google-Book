//
//  BookTableViewCell.swift
//  GoogleBooks
//
//  Created by Shuhrat Nurov on 24/12/22.
//

import UIKit
import SDWebImage

class BookTableViewCell: UITableViewCell {
    
    private let imgView:UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 10
        imgView.layer.borderColor = UIColor.black.cgColor
        imgView.layer.borderWidth = 0.3
        return imgView
    }()
    
    private let titleLbl:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private let authorLbl:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.textColor = .gray
        lbl.font = lbl.font.withSize(14)
        return lbl
    }()
    
    private let favoriteBtn:UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "star"), for: .normal)
        return btn
    }()
    
    private let openBtn:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Нажмите для просмотра...", for: .normal)
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    var btnCallback:()->() = {}
    var previewCallback:()->() = {}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        makeConstraints()
        
        favoriteBtn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        
        openBtn.addTarget(self, action: #selector(previewTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews(){
        contentView.addSubview(imgView)
        contentView.addSubview(titleLbl)
        contentView.addSubview(authorLbl)
        contentView.addSubview(favoriteBtn)
        contentView.addSubview(openBtn)
    }
    
    private func makeConstraints(){
        imgView.snp.makeConstraints { make in
            make.top.left.equalTo(20)
            make.width.equalTo(100)
            make.height.equalTo(150)
            make.bottom.equalTo(-20)
        }
        
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.left.equalTo(imgView.snp.right).offset(20)
            make.right.equalTo(favoriteBtn.snp.left).offset(-20)
        }
        
        authorLbl.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(10)
            make.left.equalTo(imgView.snp.right).offset(20)
            make.right.equalTo(favoriteBtn.snp.left).offset(-20)
        }
        
        openBtn.snp.makeConstraints { make in
            make.top.equalTo(authorLbl.snp.bottom).offset(10)
            make.left.equalTo(imgView.snp.right).offset(20)
            make.right.equalTo(favoriteBtn.snp.left).offset(-20)
        }
        
        favoriteBtn.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.right.equalTo(-20)
            make.width.height.equalTo(30)
        }
        
        
        
    }
    
    @objc func btnTapped(){
        btnCallback()
    }
    
    @objc func previewTapped(){
        previewCallback()
    }

    
    func reload(book:Book, isFavorite:Bool){
        let url = URL(string: book.volumeInfo.imageLinks?.thumbnail ?? "")
        imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        titleLbl.text = book.volumeInfo.title
        if let author = book.volumeInfo.authors?[0] {
            authorLbl.text = author
        } else {
            authorLbl.text = ""
        }
        
        let img = isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        favoriteBtn.setImage(img, for: .normal)
        
    }
    
}
