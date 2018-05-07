//
//  MapVC.swift
//  TacoFinder
//
//  Created by Marta Krawiec on 3/31/17.
//  Copyright © 2017 Marta Krawiec. All rights reserved.
//
// Map View Controller
//Presents map with custom pins for taco shops
import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    
    var requestString: String!
    var currentRegion: MKCoordinateRegion!
    var customCity: String!
    var mapItems = [MKMapItem]()
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    //main
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting up location manager to checks status
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //setting up the mapview delegate
        mapView.showsUserLocation = true
        mapView.delegate = self
      
        
    }
    //displaying zoomed in user's location
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if customCity == nil {
            
            currentRegion = MKCoordinateRegionMakeWithDistance(userLocation.location!.coordinate, 5000, 5000)
            mapView.setRegion(currentRegion, animated: true)
            searchForTacos(phraseToSearch: requestString, region: currentRegion)
            
        } else {
            CLGeocoder().geocodeAddressString(customCity, completionHandler: {(placemarks, error) in
                if error != nil {
                    print("There was an error: \(error!.localizedDescription)")
                    self.alert()
                    
                    
                } else if placemarks!.count > 0 {
                    
                    var regionToSearch = MKCoordinateRegion()
                    let placemark = placemarks![0]
                    let location = placemark.location
                    let coords = location!.coordinate
                    regionToSearch = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: coords.latitude, longitude: coords.longitude), 5000, 5000)
                    self.mapView.setRegion(regionToSearch, animated: true)
                    self.searchForTacos(phraseToSearch: self.requestString, region: regionToSearch)
                    
                }
            })
            
        }

        
    }
    
    
    //checking the status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
  
    func searchForTacos(phraseToSearch: String, region: MKCoordinateRegion) {
        
        // encapsulation of a natural language request in the mklocalsearh request class
        let request = MKLocalSearchRequest()
        //initialize the request with a string
        request.naturalLanguageQuery = phraseToSearch
        //set request to search in the current region
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            
            if error != nil {
                print("An error occured: \(error!.localizedDescription)")
                self.alert()
                
            } else if response!.mapItems.count == 0 {
                print("No matches found :(")
                self.alert()
                
            } else {
                print("Matches found")
                for item in response!.mapItems {
                    print(item.name!)
                    let annotation = MKPointAnnotation()
                    annotation.title = item.name
                    annotation.coordinate = item.placemark.coordinate
                    let mapItem = MKMapItem(placemark: item.placemark)
                    mapItem.name = item.name
                    self.mapItems.append(mapItem)
                    self.mapView.addAnnotation(annotation)
                    }
            }
        })
        
    }
   
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "taco"
        if (annotation is MKUserLocation) {
            return nil
        }
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation as MKAnnotation, reuseIdentifier: identifier)
            anView!.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            let directionsBtn = UIButton(type: .roundedRect)
            directionsBtn.backgroundColor = UIColor.blue
            directionsBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 50)
            let directionImg = UIImage(named: "Car Filled-30")
            directionsBtn.setImage(directionImg, for: .normal)
            anView!.leftCalloutAccessoryView = directionsBtn
            anView!.rightCalloutAccessoryView = btn
            btn.tag = 2
            directionsBtn.tag = 1
           // anView!.detailCalloutAccessoryView = btn2
            anView!.image = UIImage(named: "TacoBigger")
            
        } else {

            anView?.annotation = annotation

        }

        return anView
        
    }
    
    //segue for annotation view 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let detailVC = segue.destination as! DetailVC
            if let annotationName = (sender as! MKAnnotationView).annotation?.title {
                detailVC.name = annotationName
            }
            if let annotationCoords = (sender as! MKAnnotationView).annotation?.coordinate {
                detailVC.coords = annotationCoords
            
            }
            
        }
    }
 //Load map
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        //set directions on a tap of the directions button
        if (control as UIView).tag == 1 {
            print("********")
            let selectedLocation = view.annotation
            let selectedPlacemark = MKPlacemark(coordinate: selectedLocation!.coordinate)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            let selectedMapItem = MKMapItem(placemark: selectedPlacemark)
            selectedMapItem.name = selectedLocation!.title!
            selectedMapItem.openInMaps(launchOptions: launchOptions)
        
        }// send the info of the selected placemark to detailVC 
        else {
            
            performSegue(withIdentifier: "showDetail", sender: view)
            
        }
            
            
        // create a second vc that will show the info about the shop
        //if the info button is tapped it will perform segue and show you the photo of the place
        //you are doing greatt!!!!!!!!!!!!
        }
    
    //Error alers
    func alert() {
    
        let alert = UIAlertController(title: "Something went wrong...", message: "Sorry, we weren't able to find your tacos :( ", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Back button clicked
    @IBAction func backClicked(_ sender: Any) {
    
        self.performSegue(withIdentifier: "unwindToMenu", sender: nil)
        
    }
    
    
}

