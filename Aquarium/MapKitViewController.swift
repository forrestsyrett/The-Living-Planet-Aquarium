//
//  MapKitViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 11/5/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit
import MapKit
import OneSignal
import CoreLocation


class MapKitViewController: UIViewController, MKMapViewDelegate, BottomSheetViewControllerDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    
    static let shared = MapKitViewController()
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var selectedFloor: UISegmentedControl!
    
    @IBOutlet weak var restroomButton: UIButton!
    @IBOutlet weak var cafeButton: UIButton!
    @IBOutlet weak var giftShopBUtton: UIButton!
    @IBOutlet weak var compassButton: UIButton!
    @IBOutlet weak var trayView: UIVisualEffectView!
    @IBOutlet weak var compassTrayView: UIVisualEffectView!
    
    let galleries = MapGalleryController.sharedController
    let bottomSheetViewController = BottomSheetViewController()
        
    var aquarium = AquariumMap(filename: "Aquarium")
    var aquariumSecondFloor = AquariumMap(filename: "AquariumSecondFloor")
    var background = Background(filename: "BackgroundOverlay")
    var floorImage = UIImage(named: "mainFloor")
    var delta = 0.0
    var selectedPin: MKPlacemark? = nil
    var titleLabel: String = "Tap on a gallery to learn more!"
    var label = UILabel(frame: CGRect(x: 16, y: 20, width: 343, height: 21))
    var currentLocationAnnotation = Annotation(coordinate: CurrentLocationController.shared.coordinate, title: "Current Location", subtitle: "", type: AnnotationTypes.CurrentLocation)
    var manuallyChangingMapRect: Bool = true
    
    var route: MKPolyline? = nil
    var firstFloor: MKOverlay? = nil
    var secondFloor: MKOverlay? = nil
    
    var regionName = ""
    
    var trackingSwitch = 2
    var trackingType = "user"
    
    enum TrackingTypes: String {
        
        case user = "user"
        case map = "map"
        case off = "off"
    }
    
    
    var galleryZoomed = false
    

    var locationManager = CLLocationManager()
    
    var time = 0
    var timer: Timer?
    var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.00, green:0.41, blue:0.57, alpha:1.00)
        
        mapView.delegate = self
        locationManager.delegate = self
        
        
        tabBarTint(view: self)
        
        bottomSheetViewController.delegate = self
        
        currentLocationAnnotation.coordinate = CurrentLocationController.shared.coordinate
        
        mapView.mapType = .standard
        
        trayView.layer.cornerRadius = 5.0
        trayView.clipsToBounds = true
        compassTrayView.layer.cornerRadius = 5.0
        compassTrayView.clipsToBounds = true

        
        
        let latDelta = aquarium.topLeftMapCoordinate.latitude + 0.0004 - aquarium.bottomRightMapCoordinate.latitude + 0.0004
        let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        self.delta = latDelta
        
        let region = MKCoordinateRegionMake(aquarium.midCoordinate, span)
        
        
    
        
        
        mapView.showsUserLocation = false
        mapView.showsBuildings = false
        mapView.showsCompass = true
        mapView.isRotateEnabled = false
        
        label.text = titleLabel
        
        
        addMainFloorAnnotations()
        addCurrentLocationAnnotation()
        addBottomSheetView()
        addOverlays()
        mapView.setRegion(region, animated: true)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapKitViewController.updateLocation), name: Notification.Name(rawValue: "jsa"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapKitViewController.updateLocation), name: Notification.Name(rawValue: "sharks"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapKitViewController.updateLocation), name: Notification.Name(rawValue: "theater"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapKitViewController.updateLocation), name: Notification.Name(rawValue: "utah"), object: nil)
 
        transparentNavigationBar(self)
        
       
        
     //    tapGesture = UITapGestureRecognizer(target: self, action: #selector(MapKitViewController.startTimer))
      //  mapView.addGestureRecognizer(tapGesture)
        
       
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.startUpdatingHeading()
        IndexController.shared.index = (self.tabBarController?.selectedIndex)!
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingHeading()
    }
    
    
 /*   func startTimer() {

        print("Tap!")
       
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(MapKitViewController.tapBubbles), userInfo: nil, repeats: true)
        timer?.fire()
        
    }
    
    func stopBubbles() {
        
        timer?.invalidate()
        
    }
    
    
    
    func tapBubbles() {
        
        let touch = tapGesture
        let touchPoint = touch.location(in: mapView)
        
        time += 1
        print("Time \(time)")
         if time > 8 {
            timer?.invalidate()
        }
        
        let size = randomNumber(low: 8, high: 15)
        print("SIZE: \(size)")
        let xLocation = randomNumber(low: Int(touchPoint.x), high: Int(touchPoint.x + 10))
        print("X LOCATION: \(xLocation)")
        
        let bubbleImageView = UIImageView(image: UIImage(named: "Bubble"))
        bubbleImageView.frame = CGRect(x: xLocation, y: touchPoint.y, width: size, height: size)
        view.addSubview(bubbleImageView)
        view.bringSubview(toFront: bubbleImageView)
        
        let zigzagPath = UIBezierPath()
        let originX: CGFloat = touchPoint.x
        let originY: CGFloat = touchPoint.y + 100
        let eX: CGFloat = originX
        let eY: CGFloat = originY - randomNumber(low: 50, high: 30)
        let t: CGFloat = randomNumber(low: 20, high: 100)
        var startPoint = CGPoint(x: originX - t, y: ((originY + eY) / 2))
        var endPoint = CGPoint(x: originX + t, y: startPoint.y)
        
        let r: Int = Int(arc4random() % 2)
        if r == 1 {
            let temp: CGPoint = startPoint
            startPoint = endPoint
            endPoint = temp
        }
        // the moveToPoint method sets the starting point of the line
        zigzagPath.move(to: CGPoint(x: originX, y: originY))
        // add the end point and the control points
        zigzagPath.addCurve(to: CGPoint(x: eX, y: eY), controlPoint1: startPoint, controlPoint2: endPoint)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({() -> Void in
            
            UIView.transition(with: bubbleImageView, duration: 0.1, options: .transitionCrossDissolve, animations: {() -> Void in
                bubbleImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: {(_ finished: Bool) -> Void in
                bubbleImageView.removeFromSuperview()
            })
        })
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.duration = 1.5
        pathAnimation.path = zigzagPath.cgPath
        // remains visible in it's final state when animation is finished
        // in conjunction with removedOnCompletion
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.isRemovedOnCompletion = false
        bubbleImageView.layer.add(pathAnimation, forKey: "movingAnimation")
        
        CATransaction.commit()
        
    }
  */
    
    func addOverlays() {
        
        
        // MARK: -  Background Overlay
         let background = BackGroundOverlay(background: self.background)
           mapView.add(background, level: .aboveLabels)
        
        let firstFloorOverlay = AquariumMapOverlay(aquarium: aquarium)
        self.firstFloor = firstFloorOverlay
        
        let secondFloorOverlay = SecondFloorOverlay(aquarium: aquariumSecondFloor)
        self.secondFloor = secondFloorOverlay
        
        mapView.add(firstFloorOverlay)
        mapView.showsPointsOfInterest = false
        
    }
    
    
    func addMainFloorAnnotations() {
        let filePath = Bundle.main.path(forResource: "firstFloorExhibits", ofType: "plist")
        let exhibits = NSArray(contentsOfFile: filePath!)
        for exhibit in (exhibits as? [[String: AnyObject]])! {
            let point = CGPointFromString(exhibit["location"] as! String)
            let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(point.x), CLLocationDegrees(point.y))
            let title = exhibit["name"] as! String
            let typeRawValue = Int((exhibit["type"] as! String))!
            let type = AnnotationTypes(rawValue: typeRawValue)!
            let subtitle = exhibit["subtitle"] as! String
            let firstFloorAnnotation = Annotation(coordinate: coordinate, title: title, subtitle: subtitle, type: type)
            
            mapView.addAnnotation(firstFloorAnnotation)
            mapView.addAnnotation(self.currentLocationAnnotation)
            
        }
    }
    
    func addSecondFloorAnnotations() {
        let filePath = Bundle.main.path(forResource: "SecondFloorExhibits", ofType: "plist")
        let exhibits = NSArray(contentsOfFile: filePath!)
        
        for exhibit in (exhibits as? [[String: AnyObject]])! {
            let point = CGPointFromString(exhibit["location"] as! String)
            let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(point.x), CLLocationDegrees(point.y))
            let title = exhibit["name"] as! String
            let typeRawValue = Int((exhibit["type"] as! String))!
            let type = AnnotationTypes(rawValue: typeRawValue)!
            let subtitle = exhibit["subtitle"] as! String
            let secondFloorAnnotation = Annotation(coordinate: coordinate, title: title, subtitle: subtitle, type: type)
            
            mapView.addAnnotation(secondFloorAnnotation)
            mapView.addAnnotation(self.currentLocationAnnotation)
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        
        ///// Sets Overlay and Overlay Image
        if overlay is AquariumMapOverlay {
            let overlayView = AquariumMapOverlayView(overlay: overlay, overlayImage: #imageLiteral(resourceName: "main"))
            return overlayView
        }
        if overlay is SecondFloorOverlay {
            let overlayView = SecondFloorOverlayView(overlay: overlay, overlayImage: #imageLiteral(resourceName: "secondFloorFinalRSZ"))
            return overlayView
        }
        if overlay is BackGroundOverlay {
            let overlayView = BackgroundOverlayView(overlay: overlay, overlayImage: #imageLiteral(resourceName: "background"))
            return overlayView
        }
            
        else if overlay is MKPolyline {
            let lineView = MKPolylineRenderer(overlay: overlay)
            lineView.strokeColor = UIColor.blue
            lineView.lineDashPattern = [1,5]
            lineView.lineDashPhase = 8.0
            lineView.lineWidth = 2.5
            
            return lineView
            
        }
            
        else if overlay is MKTileOverlay {
            let renderer = MKTileOverlayRenderer(overlay: overlay)
            renderer.alpha = 5.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    
    
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // Get value for zoom level
        let zoomWidth = mapView.visibleMapRect.size.width
        let zoomFactor = Double(zoomWidth)
   //     print("ZOOM FACTOR: \(zoomFactor)")
        
        if zoomFactor < 620 {
     //       print("Map zoomed in. Show details!")
        }
        if zoomFactor > 800 {
      //      print("Map zoomed out, Hide details.")
        }
        
        
        let latDelta = aquarium.topLeftMapCoordinate.latitude + 0.0004 - aquarium.bottomRightMapCoordinate.latitude + 0.0004
        
        // 0.0003 sets correct zoom level when zoomed out bounce back
        
        let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        
        let mapContainsOverlay: Bool = MKMapRectContainsRect(mapView.visibleMapRect, aquarium.overlayBoundingMapRect)
        
        if mapContainsOverlay {
            
            let aquariumRegion: MKCoordinateRegion = MKCoordinateRegionMake(aquarium.midCoordinate, span)
            
            let widthRatio = aquarium.overlayBoundingMapRect.size.width / mapView.visibleMapRect.size.width
            let heightRatio = aquarium.overlayBoundingMapRect.size.height / mapView.visibleMapRect.size.height
            if (widthRatio < 5.0) || (heightRatio < 5.0) {
                manuallyChangingMapRect = true
                mapView.setRegion(aquariumRegion, animated: true)
                manuallyChangingMapRect = false
            }
        } else if !MKMapRectIntersectsRect(aquarium.overlayBoundingMapRect, mapView.visibleMapRect) {
            mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
            let aquariumRegion: MKCoordinateRegion = MKCoordinateRegionMake(aquarium.midCoordinate, span)
            mapView.setRegion(aquariumRegion, animated: true)
        }
    }
    
    
    func addCurrentLocationAnnotation() {
        mapView.addAnnotation(self.currentLocationAnnotation)
    }
    
    @objc func updateLocation() {
        
        print("Updating Location For \(CurrentLocationController.shared.exhibitName)")
        UIView.animate(withDuration: 1.5) {
            
            switch CurrentLocationController.shared.exhibitName {
            case "jsa":
                self.currentLocationAnnotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(40.5322), longitude: CLLocationDegrees(-111.8936))
            case "sharks":
                self.currentLocationAnnotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(40.53255), longitude: CLLocationDegrees(-111.89425))
            case "theater":
                self.currentLocationAnnotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(40.53248), longitude: CLLocationDegrees(-111.89396))
            case "utah":
                self.currentLocationAnnotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(40.53248), longitude: CLLocationDegrees(-111.89358))
                
            default: break
            }
        }
    }

    
    
    func centerMapOnSelected() {
        
        if mapView.selectedAnnotations.count > 0 {
            let annotation = mapView.selectedAnnotations[0]
            
            UIView.animate(withDuration: 0.3, animations: {
                self.mapView.setCenter(annotation.coordinate, animated: true)
                
            })
        }
    }
    
    func centerMapOnCurrentLocation() {
        mapView.centerCoordinate = CurrentLocationController.shared.coordinate
        
        UIView.animate(withDuration: 0.3) {
            self.mapView(self.mapView, regionDidChangeAnimated: true)
        }
    }
    
    func resetMapCenter() {
        
        self.mapView.centerCoordinate = self.aquarium.midCoordinate
        
        let latDelta = aquarium.topLeftMapCoordinate.latitude + 0.0004 - aquarium.bottomRightMapCoordinate.latitude + 0.0004
        let span = MKCoordinateSpanMake(fabs(latDelta), 0.0)
        let aquariumRegion: MKCoordinateRegion = MKCoordinateRegionMake(aquarium.midCoordinate, span)
        mapView.setRegion(aquariumRegion, animated: true)
        
    }
    
    
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if annotation.isEqual(mapView.userLocation) {
            let userLocationAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation3")
            userLocationAnnotation.image = UIImage(named: "userLocation3")
            return userLocationAnnotation
        }
        else {
            
            
            
            let annotationView = AnnotationViews(annotation: annotation, reuseIdentifier: "Exhibit")
            
            
            annotationView.canShowCallout = true
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.leftCalloutAccessoryView {
            
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        view.image = #imageLiteral(resourceName: "transparent")

    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    
        
        UIView.animate(withDuration: 0.5) {
            
           
        }
        
        if let annotation = view.annotation {
            
            
            
            //             Zoom To Selected Annotation
            let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 5, 5)
            let adjustedRegion = self.mapView.regionThatFits(region)
            mapView.setRegion(adjustedRegion, animated: true)
            
            //            UIView.animate(withDuration: 0.3, animations: {
            //                self.centerMapOnSelected()
            //            })
            
            if let title = annotation.title {
                if let newTitle = title {
                    self.titleLabel = newTitle
                }
            }
        }
        
        
        
        switch self.titleLabel {
        case "Discover Utah":
            postNotificationWithGalleryName(gallery: galleries.discoverUtah)
            
        case "Journey to South America":
            postNotificationWithGalleryName(gallery: galleries.jsa)
            
        case "Gift Shop":
            postNotificationWithGalleryName(gallery: galleries.amenities)
            
        case "Banquet Hall":
            postNotificationWithGalleryName(gallery: galleries.banquetHall)
            
        case "Ocean Explorer":
            postNotificationWithGalleryName(gallery: galleries.oceanExplorer)
            
        case "Antarctic Adventure":
            postNotificationWithGalleryName(gallery: galleries.antarcticAdventure)
            
        case "Restrooms":
            postNotificationWithGalleryName(gallery: galleries.amenities)
            
        case "Jellyfish":
            postNotificationWithGalleryName(gallery: galleries.jellyFish)
            
        case "Elevator":
            postNotificationWithGalleryName(gallery: galleries.amenities)
            
        case "Deep Sea Lab":
            postNotificationWithGalleryName(gallery: galleries.deepSeaLab)
            
        case "40' Shark Tunnel":
            postNotificationWithGalleryName(gallery: galleries.oceanExplorer)
            
        case "4D Theater":
            postNotificationWithGalleryName(gallery: galleries.theater)
            
        case "Expedition Asia":
            postNotificationWithGalleryName(gallery: galleries.expeditionAsia)
            
        case "Tuki's Island":
            postNotificationWithGalleryName(gallery: galleries.tukis)
            
        case "Education Center":
            postNotificationWithGalleryName(gallery: galleries.educationCenter)
            
        case "Journey to South America - Aviary":
            postNotificationWithGalleryName(gallery: galleries.jsa)
            
        case "Cafe":
            postNotificationWithGalleryName(gallery: galleries.cafe)
            
        case "Mother's Room":
            postNotificationWithGalleryName(gallery: galleries.amenities)
        default:
            break
        }
    }
    
    
    func postNotificationWithGalleryName(gallery: MapGalleries) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: gallery.name), object: self)
        
    }
    
    
    // MARK: - Segmented Control
    
    @IBAction func mapTypeChanged(Sender: AnyObject) {
        
        switchFloors()
        
    }
    
    
    func switchFloors() {
        
        // changes floor image
        if self.selectedFloor.selectedSegmentIndex == 0 {
            
            mapView.remove(self.secondFloor!)
            mapView.add(self.firstFloor!)
            
            mapView.removeAnnotations(mapView.annotations)
            addMainFloorAnnotations()
            
        } else if self.selectedFloor.selectedSegmentIndex == 1 {
            
            mapView.remove(self.firstFloor!)
            mapView.add(self.secondFloor!)
            
            mapView.removeAnnotations(mapView.annotations)
            addSecondFloorAnnotations()
            
        }
    }
    
    
    @IBAction func tapDismiss(_ sender: AnyObject) {
        
        
    }
    
    
    func addBottomSheetView() {
        
        // Sets child view as storyboard file to enable storyboard editing
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "BottomSheetViewController") as! BottomSheetViewController
        
        // adds storyboard file as child view
        self.addChildViewController(controller)
        self.view.addSubview(controller.view)
        controller.delegate = self
        
        let height = view.frame.height
        let width = view.frame.width
        
        controller.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
        
        
    }
    
    func selectRestroomAnnotation() {
        var ann = mapView.annotations[0]
        
        for annotation in mapView.annotations {
            
            if let title = annotation.title {
                if title == "Restrooms" {
                    ann = annotation
                }
            }
        }
        
        mapView.selectAnnotation(ann, animated: true)
        
    }
    
    func selectCafeAnnotation() {
        if self.selectedFloor.selectedSegmentIndex == 0 {
            var ann = mapView.annotations[0]
            
            for annotation in mapView.annotations {
                
                if let title = annotation.title {
                    if title == "Cafe" {
                        ann = annotation
                    }
                }
            }
            
            mapView.selectAnnotation(ann, animated: true)
            
        } else {
            self.selectedFloor.selectedSegmentIndex = 0
            switchFloors()
            var ann = mapView.annotations[0]
            
            for annotation in mapView.annotations {
                
                if let title = annotation.title {
                    if title == "Cafe" {
                        ann = annotation
                    }
                }
            }
            
            mapView.selectAnnotation(ann, animated: true)
            
            
        }
    }
    
    func selectGiftShopAnnotation() {
        if self.selectedFloor.selectedSegmentIndex == 0 {
            var ann = mapView.annotations[0]
            
            for annotation in mapView.annotations {
                
                if let title = annotation.title {
                    if title == "Gift Shop" {
                        ann = annotation
                    }
                }
            }
            
            
            mapView.selectAnnotation(ann, animated: true)
            
        } else {
            self.selectedFloor.selectedSegmentIndex = 0
            switchFloors()
            
            var ann = mapView.annotations[0]
            
            for annotation in mapView.annotations {
                
                if let title = annotation.title {
                    if title == "Gift Shop" {
                        ann = annotation
                    }
                }
            }
            mapView.selectAnnotation(ann, animated: true)
        }
    }
    
    // MARK: Quick Icons
    
    @IBAction func restroomButtonTapped(_ sender: Any) {
        selectRestroomAnnotation()
    }
    
    @IBAction func cafeButtonTapped(_ sender: Any) {
        selectCafeAnnotation()
    }
    
    @IBAction func giftshopButtonTapped(_ sender: Any) {
        selectGiftShopAnnotation()
    }
    
    
    // MARK: Compass Button
    @IBAction func compassModeButtonTapped(_ sender: Any) {
        
        
        
        
        
        switch self.trackingType {
            
        // User Location Rotates
        case TrackingTypes.map.rawValue:
            self.trackingSwitch = 2
            self.trackingType = TrackingTypes.user.rawValue
            self.mapView.isScrollEnabled = true
            self.mapView.isZoomEnabled = true
            self.mapView.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.3, animations: {
                self.resetMapCenter()
                self.mapView.transform = CGAffineTransform.identity
                self.compassButton.setImage(#imageLiteral(resourceName: "compass"), for: .normal)
                self.restroomButton.isUserInteractionEnabled = true
                self.cafeButton.isUserInteractionEnabled = true
                self.giftShopBUtton.isUserInteractionEnabled = true
            })
            
        // Map Rotates
        case TrackingTypes.user.rawValue:
            self.trackingSwitch = 1
            self.trackingType = TrackingTypes.map.rawValue
            self.compassButton.setImage(#imageLiteral(resourceName: "compassFilled"), for: .normal)
            self.mapView.isScrollEnabled = false
            self.mapView.isZoomEnabled = false
            self.restroomButton.isUserInteractionEnabled = false
            self.cafeButton.isUserInteractionEnabled = false
            self.giftShopBUtton.isUserInteractionEnabled = false
            self.mapView.isUserInteractionEnabled = false
            for annotation in self.mapView.annotations {
                mapView.deselectAnnotation(annotation, animated: true)
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                self.resetMapCenter()
                
            })
            
        default: break
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let userRotation = newHeading.magneticHeading * .pi / 180
        let mapRotation = newHeading.magneticHeading * .pi / 180
        
        if self.trackingType == TrackingTypes.user.rawValue {
            for anotation in self.mapView.annotations {
                if let title = anotation.title {
                    if title == "Current Location" {
                        let view = mapView.view(for: anotation)
                        UIView.animate(withDuration: 0.3, delay: 0.0, options: .allowUserInteraction, animations: {
                            view?.transform = CGAffineTransform(rotationAngle: (CGFloat)(userRotation))
                            
                        }, completion: nil)
                    }
                }
            }
        }
        
        if self.trackingType == TrackingTypes.map.rawValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.mapView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(mapRotation))
                for anotation in self.mapView.annotations {
                    if let title = anotation.title {
                        if title == "Current Location" {
                            let view = self.mapView.view(for: anotation)
                            UIView.animate(withDuration: 0.3, delay: 0.0, options: .allowUserInteraction, animations: {
                                view?.transform = CGAffineTransform(rotationAngle: (CGFloat)(userRotation))
                                
                            }, completion: nil)
                        }
                    }
                }
                
                
            })
        }
    }
    
    
    
    func getDirectionsButtonTapped(_ bottomSheetViewController: BottomSheetViewController) {
        
        bottomSheetViewController.delegate = self
        
        
        // Sets MKPolyLine Based off of Plist Coordinate Map
        
        //        let thePath = Bundle.main.path(forResource: "EntranceToSharksRoute", ofType: "plist")
        //        let pointsArray = NSArray(contentsOfFile: thePath!)
        //
        //        let pointsCount = pointsArray!.count
        //
        //        var pointsToUse: [CLLocationCoordinate2D] = []
        //        
        //        for point in 0...pointsCount - 1 {
        //            let p = CGPointFromString(pointsArray![point] as! String)
        //            pointsToUse += [CLLocationCoordinate2DMake(CLLocationDegrees(p.x), CLLocationDegrees(p.y))]
        //        }
        //        
        //        let routeLine = MKPolyline(coordinates: &pointsToUse, count: pointsCount)
        //        
        //        self.route = routeLine
        //        clearDirectionsButton.isHidden = false
        //        
        //        UIView.animate(withDuration: 5.0, animations: {
        //            self.mapView.add(self.route!)
        //        })
    }
    
    
}
