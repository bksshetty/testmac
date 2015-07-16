//
//  checkImageViewController.swift
//  FirstShoeExperience
//
//  Created by Openly on 13/04/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit

class checkImageViewController: UIViewController {

    @IBOutlet weak var makeChange: UIButton!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    //var firstShoes = FirstShoes.sharedInstance
    
    
    
    @IBAction func didClickProceed(sender: AnyObject) {
        var destVC : ParentsFormViewController = self.storyboard?.instantiateViewControllerWithIdentifier("parents_screen")! as! ParentsFormViewController;
        //destVC.firstShoes = FirstShoes.sharedInstance
        self.presentViewController(destVC, animated: true, completion: { () -> Void in
        })

        
    }
    @IBAction func makeChangeButtonClicked(sender: AnyObject){
    }
    override func viewDidLoad() {
        checkImageView.image = FirstShoes.sharedInstance.loadImage()
        //checkImageView.image = firstShoes.imageTaken
        //view.backgroundColor = UIColor .whiteColor().colorWithAlphaComponent(0.5)
        //view.opaque = false;
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
