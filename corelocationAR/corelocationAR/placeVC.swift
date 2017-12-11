//
//  placeVC.swift
//  corelocationAR
//
//  Created by Syed ShahRukh Haider on 09/11/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class placeVC: UITableViewController {

    
    let places = ["Super Market", "Petrol", "Hospital", "Mall", "Fast Food", "Bank"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        
        cell.textLabel?.text = self.places[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = (self.tableView.indexPathForSelectedRow)!
        let selectedPlace = self.places[indexPath.row]
        
        let vc = segue.destination as! ViewController
        
        vc.place = selectedPlace
    }

   
}
