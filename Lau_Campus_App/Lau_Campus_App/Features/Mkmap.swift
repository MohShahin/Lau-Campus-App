import UIKit
import MapKit
import CoreLocation

class Mkmap: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var Mapview: MKMapView!{
    didSet {
            Mapview.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    let locationManager = CLLocationManager()
    var initialLocation = CLLocation(latitude: 33.8930, longitude: 35.4778)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let Mapview = self.Mapview {
            Mapview.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                Mapview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                Mapview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                Mapview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                Mapview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
            ])
            print("hello")
            
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            Mapview.addGestureRecognizer(gestureRecognizer)
            
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            if locationManager.authorizationStatus == .authorizedWhenInUse ||
                locationManager.authorizationStatus == .authorizedAlways {
                locationManager.startUpdatingLocation()
            }
            centerToLocation(initialLocation)
            
            centerToLocation(initialLocation)
            
            let oahuCenter = CLLocation(latitude: 33.8930, longitude: 35.4778)
            let region = MKCoordinateRegion(
                center: oahuCenter.coordinate,
                latitudinalMeters: 50000,
                longitudinalMeters: 60000)
            Mapview.setCameraBoundary(
                MKMapView.CameraBoundary(coordinateRegion: region),
                animated: true)
            let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
            Mapview.setCameraZoomRange(zoomRange, animated: true)
        }
    }

    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: Mapview)
        let coordinate = Mapview.convert(location, toCoordinateFrom: Mapview)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        DispatchQueue.main.async {
            self.Mapview.addAnnotation(annotation)
        }
    }

    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        Mapview.setRegion(coordinateRegion, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // Once you get the user's location, stop updating the location
        locationManager.stopUpdatingLocation()

        // Set the map's center and zoom level to the user's location
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters:1000, longitudinalMeters: 1000)
        Mapview.setRegion(coordinateRegion, animated: true)
    }
}
