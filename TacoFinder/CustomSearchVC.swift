//
//  CustomSearchVC.swift
//  TacoFinder
//
//  Created by Marta Krawiec on 3/31/17.
//  Copyright © 2017 Marta Krawiec. All rights reserved.
//
// Custom Search View controler
import UIKit
import CoreLocation
class CustomSearchVC: UIViewController {

    @IBOutlet weak var restaurantNameField: UITextField!
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var cityNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


//Dismiss search bar
    @IBAction func dismissSearch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapVC = segue.destination as! MapVC
        mapVC.requestString = restaurantNameField.text
        //mapVC.currentRegion = cityNameField.text
        let addresString = cityNameField.text
        
        mapVC.customCity = addresString
        

        
        
    }
    //Action on search
    
    @IBAction func searchTapped(_ sender: Any) {
       
        if restaurantNameField.text == "" && cityNameField.text == "" {
            warningLabel.text = "Please enter restaurant and city name!"
            
        } else if restaurantNameField.text == "" {
            warningLabel.text = "Please enter restaurant name!"
        
        } else if cityNameField.text == "" {
            warningLabel.text = "Please enter city name!"

        }
        
        else {
            
        performSegue(withIdentifier: "customSearchSegue", sender: self)
        
        }
        
        
    }
    
    
    
}
