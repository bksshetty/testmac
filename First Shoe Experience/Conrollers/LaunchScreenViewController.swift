//
//  LaunchScreenViewController.swift
//  FirstShoeExperience
//
//  Created by Openly on 09/04/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        var imageView = UIImageView(); // set as you want
        var image = UIImage(named: "loadingScreen.png");
        imageView.image = image;
        self.view.addSubview(imageView);
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
