//
//  TheaterViewController.swift
//  LocationPractice
//
//  Created by 최서경 on 1/24/24.
//

import UIKit
import MapKit

enum TheaterType: Int, CaseIterable {
    case 롯데시네마
    case 메가박스
    case CGV
    case total
    
    var title: String {
        switch self {
        case .롯데시네마:
            return "롯데시네마"
        case .메가박스:
            return "메가박스"
        case .CGV:
            return "CGV"
        case .total:
            return "전체보기"
        }
    }
}


class TheaterViewController: UIViewController {
    let theaterAnnotation: [Theater] = TheaterList.mapAnnotations
    var annotationList: [MKPointAnnotation] = []
    let theaterNameList = TheaterType.allCases
    
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = CLLocationCoordinate2D.init(latitude: theaterAnnotation[0].latitude, longitude: theaterAnnotation[0].longitude)
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 20000, longitudinalMeters: 20000)
        
        mapView.setRegion(region, animated: true)
        
        for theater in TheaterList.mapAnnotations {
            let coordinate =  CLLocationCoordinate2D(latitude: theater.latitude, longitude: theater.longitude)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = coordinate
            annotation.title = theater.location
            
            annotationList.append(annotation)
        }
        mapView.addAnnotations(annotationList)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterButtonClicked))
    }
    
    func showAlert(completionHandler: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        for type in theaterNameList {
            let action = UIAlertAction(title: type.title, style: .default) { _ in
                
                completionHandler(type.title)
            }
            alert.addAction(action)
        }
        present(alert, animated: true)
    }
    
    @objc func filterButtonClicked() {
        showAlert() { action in
            print(action)
            var annotationData: [MKAnnotation] = []
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            if action == TheaterType.total.title {
                annotationData = self.annotationList
                self.mapView.addAnnotations(annotationData)
            } else {
                for annotation in self.annotationList {
                    guard let theater = annotation.title else { return }
                    if theater.contains(action) {
                        annotationData.append(annotation)
                    }
                    self.mapView.addAnnotations(annotationData)
                    
                }
            }
        }
        
    }
}
