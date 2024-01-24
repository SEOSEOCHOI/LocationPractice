import UIKit
import MapKit
import CoreLocation // 1. 위치 import8
/*
 [Flow]
 0. InfoPlist 작성
 1. locationManager 생성
 2. 디바이스의 위치 서비스 활성화 여부 판단
 2 - 1 true. 앱의 위치 권한 활성화 여부 판단
 2 - 2. 현재 사용자의 앱 활성화 조건에 따른 액션
 - notDetermined
 - denied
 - authorizedWhenInUse
 3. 위치 프로토콜 선언
 4. 위치 프로토콜 연결
 5. 사용자의 위치 데이터를 성공적으로 가져온 경우
 5 - 1. [didUpdateLocations] 사용자의 위치 정보 업데이트
 5 - 2. coordination을 획득하여 mapView의 센터 결정
 6. 사용자의 위치 데이터를 가져오지 못한 경우
 
 */
class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var locationButton: UIButton!
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        checkDeviceLoactionAuthorization()
        configureView()
    }
    
    
}

extension ViewController {
    func locationButtonDesign() -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        
        config.title = ""
        config.image = UIImage(systemName: "location.fill")
        config.cornerStyle = .capsule

        config.baseBackgroundColor = UIColor.orange
        config.baseForegroundColor = UIColor.black
        return config
    }
    
    func configureView() {
        locationButton.configuration = self.locationButtonDesign()
    }
    
    @objc func locationButtonClicked() {
        showLocationSettingAlert()
    }
}



extension ViewController {
    // 📍 디바이스의 위치 서비스 활성화 여부 판단 -> checkCurrentLocationAuthorization 출
    func checkDeviceLoactionAuthorization() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() { // 장치에서 위치 서비스가 활성화되었는지 여부
                let authorization: CLAuthorizationStatus // 현재 사용자의 위치 권한 상태 [위치 서비스를 이용하기 위한 앱의 권한 상태]
                
                
                if #available(iOS 14.0, *) {
                    authorization = self.locationManager.authorizationStatus // 앱의 현재 인증 상태
                } else {
                    authorization = CLLocationManager().authorizationStatus
                }
                
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
                
                
                /* 📖 장치 내에서 위치 권한이 활성화되어 있을 경우[CLLocationManager.locationServicesEnabled()]에
                 현재 앱에서 사용자의 위치 권한 상태[self.locationManager.authorizationStatus]에 대해 확인을 하는 과정이다! */
                
            } else {
                print("위치 서비스에 대한 인증이 존재하지 않습니다.")
            }
        }
    }
    
    // 📍 status로 사용자의 위치 권한에 대해 판단한 후, 권한을 요청
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        // 한번만 허용 시 앱 재실행을 하면 status는 notDetermined
        switch status {
        case .notDetermined: // 앱에 대한 위치 권한에 대한 결정을 하지 않은 상태 -> 결정을 위한 권한 문구 띄우기
            print("notDetermined")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // 앱이 수신하려는 위치 데이터의 정확성.
            locationManager.requestWhenInUseAuthorization() // 앱 위치 권한 문구 띄우기
            
        case .denied:
            print("denied")
            showLocationSettingAlert()
            setDefaultRegionAnntation()
            locationButton.addTarget(self, action: #selector(locationButtonClicked), for: .touchUpInside)
            
            
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            
            locationManager.startUpdatingLocation() // authorizedWhenInUse 상태에서 startUpdatingLocation를 통해 [사용자의 현재 위치를 보고하는 업데이트를 생성] -> didUpdataLoactaioan 메서드 실행
            
        default:
            print("Error")
        }
    }
    
    // .denied 시, 앱에 대한 위치 권한을 제공하지 않는 것을 선택했기 떄문에 Alert을 통해 iOS 시스템 설정 유도
    func showLocationSettingAlert() {
        let alert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다 기기의 설정 > 개인정보 보호에서 위치서비스를 켜 주세요", preferredStyle: .alert)
        
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            // 설정 화면으로 이동할 계획인데, 설정 화면으로 이동할지 앱 상세 페이지까지 유도할지는 몰라요!
            
            if let setting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting)
            } else {
                print("설정으로 가 주세요")
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(goSetting)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        // 지도 중심 기반으로 보여질 범위 설정
        // Location에서 획득한 coordination을 통해 지도상 위치 설정
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        
        mapView.setRegion(region, animated: true)
    }
    
    func setDefaultRegionAnntation() {
        let coordinate = CLLocationCoordinate2D(latitude: 37.654203, longitude: 127.049809)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        self.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "청년취업사관학교 도봉캠퍼스"
        
        self.mapView.addAnnotation(annotation)
        
    }
}


extension ViewController: CLLocationManagerDelegate {
    // 5. 사용자의 위치 데이터를 성공적으로 가져온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            
            setRegionAndAnnotation(center: coordinate)
        }
        locationManager.stopUpdatingLocation()
    }
    
    //  6. 사용자의 위치 데이터를 가져오지 못한 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
        
        
    }
    
    // 4) 사용자 권한 상태가 바뀔 때를 알려줌
    //iOS 14이상
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        
        
        checkDeviceLoactionAuthorization() // 사용자의 권한 상태바
    }
    // 4) 사용자 권한 상태가 바뀔 때를 알려줌
    // iOS 14미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        
    }
}
