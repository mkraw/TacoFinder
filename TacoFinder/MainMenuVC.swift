//
//  MainMenuVC.swift
//  TacoFinder
//
//  Created by Marta Krawiec on 3/31/17.
//  Copyright © 2017 Marta Krawiec. All rights reserved.
//


import UIKit


class MainMenuVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
    
    
    }

    //Prepare for segue to pass nearby results 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nearbySegue" {
            
        let mapVC = segue.destination as! MapVC
        mapVC.requestString = "Tacos"
        }
    }
    //Find nearby restaurants
    @IBAction func nearbyTapped(_ sender: Any) {
        performSegue(withIdentifier: "nearbySegue", sender: self)
        
    }
    
    
    
    
}

