//
//  ViewController.swift
//  GoogleBooks
//
//  Created by Shuhrat Nurov on 20/12/22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "Test"
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }


}

