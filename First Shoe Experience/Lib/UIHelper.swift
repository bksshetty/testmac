//
//  UIHelper.swift
//  First Shoe Experience
//
//  Created by Abhilash Hebbar on 11/05/15.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit

class UIHelper: NSObject {
    static func showLoader(view:UIView) -> UIView{
        var frame:CGRect = view.frame;
        var translucentView:UIView = UIView(frame: frame);
        var translucentImage: UIImageView = UIImageView(frame: frame);
        translucentImage.image = UIImage(named: "translucent.png");
        var spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: frame);
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray;
        spinner.startAnimating();
        translucentView.addSubview(translucentImage);
        translucentView.addSubview(spinner);
        view.addSubview(translucentView);
        return translucentView;
    }
}
