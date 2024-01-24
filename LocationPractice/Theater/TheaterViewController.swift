//
//  TheaterViewController.swift
//  LocationPractice
//
//  Created by 최서경 on 1/24/24.
//

import UIKit
import MapKit

enum TheaterType: String, CaseIterable {
    case 롯데시네마
    case 메가박스
    case CGV
}


class TheaterViewController: UIViewController {
    

    
    let theaterAnnotation: [Theater] = TheaterList.mapAnnotations
    var annotationList: [MKPointAnnotation] = []
    
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
        
        for annotationData in annotationList {
            mapView.addAnnotation(annotationData)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterButtonClicked))
    }
    
    func showAlert(title: String, message: String, buttonTitle: [String], completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for count in 0 ... buttonTitle.count - 1 {
            let action = UIAlertAction(title: buttonTitle[count], style: .default) { _ in
                
                completionHandler()
            }
            alert.addAction(action)
        }
        
        present(alert, animated: true)
    }
    
    func isContain(type: String, A: [Theater]) -> [MKAnnotation] {
        var annotationData: [MKAnnotation] = []
        for theater in A {
            if theater.type == type {
                let coordinate =  CLLocationCoordinate2D(latitude: theater.latitude, longitude: theater.longitude)
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = coordinate
                annotation.title = theater.location
                
                annotationData.append(annotation)
            }
        }
        return annotationData
    }
    
    @objc func filterButtonClicked() {
        var buttonTitle: [String] = []
        for type in TheaterType.allCases {
            buttonTitle.append(type.rawValue)
        }
        buttonTitle.append("전체보기")
        
        showAlert(title: "", message: "", buttonTitle: buttonTitle) {

                        self.mapView.removeAnnotations(self.mapView.annotations)

            isContain(type: action.title, A: theaterAnnotation)
            }
            
            //            self.mapView.addAnnotations(annotationData)

    
        }

//
//        let lotteCinema = UIAlertAction(title: "LotteCinema", style: .default) { _ in
//            self.mapView.removeAnnotations(self.mapView.annotations)
//            for annotation in self.annotationList {
//                if let title = annotation.title {
//                    if title.contains(TheaterType.롯데시네마.rawValue) {
//                        annotationData.append(annotation)
//                    }
//                }
//            }
//            self.mapView.addAnnotations(annotationData)
//
//        }
//        showAlert(title: "", message: "", buttonTitle: "MegaBox") {
//            self.mapView.removeAnnotations(self.mapView.annotations)
//
//          
//            for annotation in self.annotationList {
//                if let title = annotation.title {
//                    if title.contains(TheaterType.메가박스.rawValue) {
//                        annotationData.append(annotation)
//                    }
//                }
//            }
//            self.mapView.addAnnotations(annotationData)
//        }
//        
//        showAlert(title: "", message: "", buttonTitle: "cgv") {
//            self.mapView.removeAnnotations(self.mapView.annotations)
//
//          
//            for annotation in self.annotationList {
//                if let title = annotation.title {
//                    if title.contains(TheaterType.CGV.rawValue) {
//                        annotationData.append(annotation)
//                    }
//                }
//            }
//            self.mapView.addAnnotations(annotationData)
//        }



//        
//        
//        
//        let all = UIAlertAction(title: "전체보기", style: .default) { _ in
//            self.mapView.addAnnotations(self.annotationList)
//            print("전", annotationData)
//
//        }
//        
//
//        actionSheet.addAction(lotteCinema)
//        actionSheet.addAction(all)
//        
//        present(actionSheet, animated: true)
//        
    }
}


