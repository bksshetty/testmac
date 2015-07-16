//
//  ShareDetails.swift
//  First Shoe Experience
//
//  Created by Openly on 11/05/2015.
//  Copyright (c) 2015 Openly. All rights reserved.
//

import UIKit

class ShareDetails {
    
    static let shareInstance = ShareDetails()
    
    func shareImageDetails()-> UIActivityViewController{
        
        var firstShoes = FirstShoes.sharedInstance
        var shareString = ""
        var sharedImage: UIImage = squareCropImageToSideLength(FirstShoes.sharedInstance.getImage(), sideLength: 425)
        var border = UIImage(named: "border-image.jpg");
        var newSize = CGSizeMake(border!.size.width, border!.size.height)
        
        UIGraphicsBeginImageContext( newSize )
        border!.drawInRect(CGRectMake(0,0,newSize.width,newSize.height))
        sharedImage.drawInRect(CGRectMake(100,104,425,435), blendMode:kCGBlendModeNormal, alpha:1.0)
        
        var newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        var imageData = UIImagePNGRepresentation(newImage)
        
        textToImage(firstShoes.getChildName(),fontStyle: "ClarksSansCProCyGr", inImage: border!, atPoint: CGPointMake(20, 300))
        FirstShoes.sharedInstance.imageWithBorder = newImage
        
        UIGraphicsEndImageContext()
        
        if(FirstShoes.sharedInstance.childGender == "Boy"){
            shareString = "\(FirstShoes.sharedInstance.childName) got his first shoes #clarks #firstshoes #firstshoesexperience"
        }else {
            shareString = "\(FirstShoes.sharedInstance.childName) got her first shoes #clarks #firstshoes #firstshoesexperience"
        }
        
        let activityViewController = UIActivityViewController(activityItems: [imageData,shareString], applicationActivities: nil);
        activityViewController.excludedActivityTypes =  [
            UIActivityTypePostToWeibo,
            UIActivityTypeAirDrop,
            UIActivityTypePrint,
            UIActivityTypeCopyToPasteboard,
            UIActivityTypeAssignToContact,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo
        ]
        return activityViewController
    }
    
    func textToImage(drawText: NSString, fontStyle: NSString, inImage: UIImage, atPoint:CGPoint)->UIImage{
        
        // Setup the font specific variables
        var textColor: UIColor = UIColor.whiteColor()
        var textFont: UIFont = UIFont(name: "Helvetica Bold", size: 12)!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
        ]
        
        //Put the image into a rectangle as large as the original image.
        inImage.drawInRect(CGRectMake(0, 400, inImage.size.width, inImage.size.height))
        
        // Creating a point within the space that is as bit as the image.
        var rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        
        //Now Draw the text into an image.
        drawText.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
        
    }
    
    private func squareCropImageToSideLength(let sourceImage: UIImage, let sideLength : CGFloat) -> UIImage{
        
        // input size comes from image
        let inputSize: CGSize = sourceImage.size
        
        // round up side length to avoid fractional output size
        let sideLength: CGFloat = sideLength ;
        
        // output size has sideLength for both dimensions
        let outputSize: CGSize = CGSizeMake(sideLength, sideLength)
        
        // calculate scale so that smaller dimension fits sideLength
        let scale: CGFloat = max(sideLength / inputSize.width,
            sideLength / inputSize.height)
        
        // scaling the image with this scale results in this output size
        let scaledInputSize: CGSize = CGSizeMake(inputSize.width * scale,
            inputSize.height * scale)
        
        // determine point in center of "canvas"
        let center: CGPoint = CGPointMake(outputSize.width/2.0,
            outputSize.height/2.0)
        
        // calculate drawing rect relative to output Size
        let outputRect: CGRect = CGRectMake(center.x - scaledInputSize.width/2.0,
            center.y - scaledInputSize.height/2.0,
            scaledInputSize.width,
            scaledInputSize.height)
        
        // begin a new bitmap context, scale 0 takes display scale
        UIGraphicsBeginImageContextWithOptions(outputSize, true, 0)
        
        // optional: set the interpolation quality.
        // For this you need to grab the underlying CGContext
        let ctx: CGContextRef = UIGraphicsGetCurrentContext()
        CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh)
        
        // draw the source image into the calculated rect
        sourceImage.drawInRect(outputRect)
        
        // create new image from bitmap context
        let outImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // clean up
        UIGraphicsEndImageContext()
        
        // pass back new image
        return outImage
    }

    
}