//
//  ViewController.swift
//  PokemonGo
//
//  Created by Leon on 21/11/18.
//  Copyright © 2018 Leon. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    
    
    var ubicacion = CLLocationManager()
    var contActualizaciones = 0
    var pokemons: [Pokemon] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        ubicacion.delegate = self
        pokemons = obtenerPokemons()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            ubicacion.startUpdatingLocation()
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
                if let coord = self.ubicacion.location?.coordinate{
                    let pin = MKPointAnnotation()
                    pin.coordinate = coord
                    let randomlat = (Double(arc4random_uniform(200)) - 100.0)/5000.0
                    let randomlon = (Double(arc4random_uniform(200)) - 100.0)/5000.0
                    pin.coordinate.latitude += randomlat
                    pin.coordinate.longitude += randomlon
                    self.mapView.addAnnotation(pin)
                }
            }
        }else{
            ubicacion.requestWhenInUseAuthorization()
        }
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if contActualizaciones < 1 {
        let region = MKCoordinateRegion.init(center: ubicacion.location!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        }else{
            ubicacion.stopUpdatingLocation()
        }
    }
    
    
    @IBAction func centrarTapped(_ sender: Any) {
        if let coord = ubicacion.location?.coordinate{
            let region = MKCoordinateRegion.init(center: coord, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        }
    }
    


}

