//  Created by Eric on 10/25/18.
//  Copyright © 2018 App Parents LLC. All rights reserved.
//

import UIKit

class VideoIntroViewController: VideoSplashViewController {
    override var prefersStatusBarHidden:Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Video Intro doesn't work on the IPhone X simulator, so it is skipped till tested on Iphone X
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                print("iPhone X, Xs")
                let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
                let customViewControllersArray : NSArray = [newViewController!]
                self.navigationController?.viewControllers = customViewControllersArray as! [UIViewController]
                self.navigationController?.popToRootViewController(animated: true)
            case 2688:
                print("iPhone Xs Max")
                let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
                let customViewControllersArray : NSArray = [newViewController!]
                self.navigationController?.viewControllers = customViewControllersArray as! [UIViewController]
                self.navigationController?.popToRootViewController(animated: true)
            case 1792:
                print("iPhone Xr")
                let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
                let customViewControllersArray : NSArray = [newViewController!]
                self.navigationController?.viewControllers = customViewControllersArray as! [UIViewController]
                self.navigationController?.popToRootViewController(animated: true)
            default:
                print("unknown")
            }
        }
        if let path = Bundle.main.path(forResource: "Marvel Intro HD", ofType: "mp4") {
            let url = URL(fileURLWithPath: path)
            videoFrame = view.frame
            fillMode = .resize
            alwaysRepeat = true
            sound = true
            startTime = 0
            duration = 12
            alpha = 0.7
            backgroundColor = UIColor.black
            contentURL = url
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 13) {
            let newViewController = self.storyboard?.instantiateViewController(withIdentifier: "Menu")
            let customViewControllersArray : NSArray = [newViewController!]
            self.navigationController?.viewControllers = customViewControllersArray as! [UIViewController]
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        // Sample UI
        
    }
}
