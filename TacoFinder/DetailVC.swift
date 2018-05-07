//
//  DetailVC.swift
//  TacoFinder
//
//  Created by Marta Krawiec on 4/4/17.
//  Copyright © 2017 Marta Krawiec. All rights reserved.
//
//Shows details of selected restaurant
import UIKit
import CoreLocation
import MapKit
class DetailVC: UIViewController {
    
    
    @IBOutlet weak var streetL: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateZipLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var streetViewImage: UIImageView!
    var name: String?
    var coords: CLLocationCoordinate2D?
    let key = "AIzaSyAyBR7zOUEqB-JBe6X5gCU4XPR7VBjOABU"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = name {
            nameLabel.text = name
        
            }
        
        //Get data from location
        if let address = coords {
            
            let location = CLLocation(latitude: address.latitude, longitude: address.longitude)
            _ = CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemark, error) in
                if error != nil {
                    self.streetL.text = "We couldn't retrieve the address"
                    
                }
                else if let placemark = placemark {
                    if placemark.count > 0 {
                        let streetnumber = placemark[0].subThoroughfare
                        let streetname = placemark[0].thoroughfare
                        self.streetL.text = streetnumber! + " " + streetname!
                        self.cityLabel.text = placemark[0].locality
                        let state = placemark[0].administrativeArea
                        let zip = placemark[0].postalCode
                        self.stateZipLabel.text = state! + ", " + zip!
                    
                    } else {
                        self.streetL.text = "We couldn't retrieve the address"
                        self.cityLabel.text = ""
                        self.stateZipLabel.text = ""
                    
                    }
                    
                }
                
            
            })
            
            
            
            
        
        let width = Int(self.view.frame.size.width)
        print(width)
        let streetViewUrl = URL(string: "https://maps.googleapis.com/maps/api/streetview?size=\(width)x300&location=\(coords!.latitude),\(coords!.longitude)&fov=90&heading=235&pitch=10&key=\(key)")!
        
                let session = URLSession(configuration: .default)
        
        //Street view image download
        let downloadPicTask = session.dataTask(with: streetViewUrl) { (data, response, error) in
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                
                if let res = response as? HTTPURLResponse {
                    print("Downloaded img \(res.statusCode)")
                    if let imageData = data {
                        
                        let image = UIImage(data: imageData)

                        DispatchQueue.main.async {
                            self.streetViewImage.image = image
                        }
                        
                    } else {
                        print("Couldn't receive image!")
                    }
                } else {
                    print("Couldn't get response!")
                }
            }
        }
        
        
        downloadPicTask.resume()
        }
        
        
            }
    
    
        
    @IBAction func directionsTapped(_ sender: Any) {
        if let coordinates = coords {
        let selectedPlacemark = MKPlacemark(coordinate: coordinates)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        let selectedMapItem = MKMapItem(placemark: selectedPlacemark)
        selectedMapItem.name = name
        selectedMapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
  
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        }
    
    }

