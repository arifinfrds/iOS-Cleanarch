//
//  PostDetailViewController.swift
//  Cleanarch
//
//  Created by Arifin Firdaus on 12/27/19.
//  Copyright © 2019 arifinfrds. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    static let storybordId = "PostDetailViewController"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var post: Post?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = post?.title
        bodyLabel.text = post?.body
    }
    
}
