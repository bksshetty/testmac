//
//  ContentViewController.swift
//  FirstShoeExperience
//
//  Created by Openly on 21/04/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var pageIndex : Int!
    var imageFile : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = UIImage(named: self.imageFile)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
