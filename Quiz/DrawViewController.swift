//
//  DrawViewController.swift
//  Quiz
//
//  Created by Angel Jiang on 11/29/20.
//

import UIKit

class DrawViewController: UIViewController {
    
    var triviaQuestion: TriviaQuestion!
    var imageStore: ImageStore!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // set the current triviaQuestion
        print(triviaQuestion.question)
        print(triviaQuestion.answer)
        
        // load the current image, convert it into draw
        if imageStore.image(forKey: triviaQuestion.imageKey) != nil {
            // set image
        }
        else {
            // blanck canvas, probably don't need to do anything
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // convert the drawing into UIImage, and save the image to the triviaQuestion
        let image = self.view.asImage()
        imageStore.setImage(image, forKey: triviaQuestion.imageKey)
    }
}

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}
