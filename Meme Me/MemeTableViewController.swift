//
//  MemeTableViewController.swift
//  Meme Me
//
//  Created by Rudy James Jr on 5/24/20.
//  Copyright © 2020 James Consutling LLC. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: MemeController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var memeTable: UITableView!;
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async{
            //Now reload the tableView
            self.memeTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return super.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = super.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText + "..." + meme.bottomText
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.viewDetails(indexPath)
    }
}
