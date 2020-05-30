//
//  MemeDetailViewController.swift
//  Meme Me
//
//  Created by Rudy James Jr on 5/24/20.
//  Copyright © 2020 James Consutling LLC. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
       // self.meme
        self.imageView.image = meme.memedImage
    }
}
