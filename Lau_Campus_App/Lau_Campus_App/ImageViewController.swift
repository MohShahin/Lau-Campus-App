//
//  ImageViewController.swift
//  Lau_Campus_App
//
//  Created by Guest User on 5/10/23.
//

import UIKit
import ImageIO

class ImageViewController: UIViewController {
    

        // Outlet for ImageView
    @IBOutlet weak var myImageView: UIImageView!
    
        override func viewDidLoad() {
            super.viewDidLoad()

            myImageView.image = UIImage(named:"3dbeirut-medium")

        }
    var switched = false
    @IBAction func `switch`(_ sender: Any) {
        if (switched){
            myImageView.image = UIImage(named:"3dbeirut-medium")
            
        }else{
            myImageView.image = UIImage(named:"3dbyblos")
        }
        switched = !switched
        
    }
}
