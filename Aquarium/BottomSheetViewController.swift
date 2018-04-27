//
//  BottomSheetViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 11/5/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//

import UIKit
import SafariServices
import FirebaseStorageUI
import Firebase
import Hero


var galleryTest = ""

protocol BottomSheetViewControllerDelegate: class {
    func getDirectionsButtonTapped(_ bottomSheetViewController: BottomSheetViewController)
}

class BottomSheetViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    
    static let shared = BottomSheetViewController()
    
    var titleLabel = "Test"
    
    // Info Variables
    weak var delegate: BottomSheetViewControllerDelegate?
    
    @IBOutlet var completeView: UIView!
    @IBOutlet weak var galleryTitleLabel: UILabel!
    @IBOutlet weak var galleryPhoto1: UIImageView!
    @IBOutlet weak var galleryInfo: UILabel!
    @IBOutlet weak var shadowView: UIImageView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    var buttonAction = "Safari"
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var theaterTableView: UITableView!
    
    @IBOutlet weak var pullArrow: UIImageView!
    
    let galleries = MapGalleryController.sharedController
    
    var galleryName = ""
    
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        
        if DeviceCheck.shared.device == "iPhone X" {
        return UIScreen.main.bounds.height - 150
        }  else {
                return UIScreen.main.bounds.height - 120
            }
    }
    var viewIsUp: Bool = false
    var urlString = "http://www.thelivingplanet.com/"
    
    
    enum ButtonActions: String {
        case Safari = "Safari"
        case WebView = "WebView"
    }
    
    //   var mapTableViewData = AnimalController.shared.allAnimals
    var allAnimals: [AnimalTest] = []
    var allAnimalsSorted: [AnimalTest] = []
    
    var discoverUtahAnimals: [AnimalTest] = []
    var oceanExplorerAnimals: [AnimalTest] = []
    var expeditionAsiaAnimals: [AnimalTest] = []
    var jsaAnimals: [AnimalTest] = []
    var antarcticAdventureAnimals: [AnimalTest] = []
    var deepSeaAnimals: [AnimalTest] = []
    var jellyfishTypes: [AnimalTest] = []
    
    var mapGalleries = [MapGalleryController.sharedController.antarcticAdventure.name]
    var allTheaterShows = [TheaterShowsController.shared.penguins4D, TheaterShowsController.shared.sammyAndRay4D, TheaterShowsController.shared.wildCats3D]
    let cellSpacingHeight: CGFloat = 5
    
    var animalInfo = ""
    var animalImage = ""
    var animalName = ""
    var conservationStatus = ""
    var animal: AnimalTest?
    var firebaseReference: FIRDatabaseReference!
    var segueString = ""
    
    var closeSwitch: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomSheetGradient(self.view)
        
        glow(view: completeView)
        
        self.getDirectionsButton.isHidden = true
        
        self.firebaseReference = FIRDatabase.database().reference()
        
        getAnimals()

        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.panGesture))
        
        view.addGestureRecognizer(gesture)
        
        gesture.delegate = self
        
        roundedCorners(galleryPhoto1, cornerRadius: 5.0)
        roundedCorners(getDirectionsButton, cornerRadius: 5.0)
        getDirectionsButton.layer.borderColor = UIColor.white.cgColor
        getDirectionsButton.layer.borderWidth = 1.0
        
        roundedCorners(self.view, cornerRadius: 5.0)
        
        postObservers()
        
        self.shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.50
        shadowView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        shadowView.layer.shadowRadius = 7.0
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let allGalleries = [galleries.amenities.name, galleries.antarcticAdventure.name, galleries.banquetHall.name, galleries.deepSeaLab.name, galleries.discoverUtah.name, galleries.educationCenter.name, galleries.expeditionAsia.name, galleries.jellyFish.name, galleries.jsa.name, galleries.oceanExplorer.name, galleries.theater.name, galleries.tukis.name]
        
        mapGalleries = allGalleries
        
        hideTableView()
        self.theaterTableView.isHidden = true
        
        self.getDirectionsButton.isHidden = true
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.closeSwitch == true {
            UIView.animate(withDuration: 0.3) {
                let frame = self.view.frame
                let yComponent = self.partialView
                self.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height)
            }
        }
        
        self.closeSwitch = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /*    let frame = self.view.frame
         let yComponent = self.partialView
         self.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height)
         
         UIView.animate(withDuration: 0.3) {
         self.view.transform = .identity
         
         }*/
    }
    
    
    
    func getAnimals() {
        
        
        let query =  self.firebaseReference.child("Animals")
        
        query.observe(.value, with: { (snapshot) in
            self.allAnimals = []
            AnimalController.shared.allAnimals = []
    
    //Clear sorted arrays here to update tableViews live
            self.discoverUtahAnimals = []
            self.oceanExplorerAnimals = []
            self.expeditionAsiaAnimals = []
            self.jsaAnimals = []
            self.antarcticAdventureAnimals = []
            self.deepSeaAnimals = []
            self.jellyfishTypes = []
            
            for item in snapshot.children {
                guard let animal = AnimalTest(snapshot: item as! FIRDataSnapshot) else { continue }
                self.allAnimals.append(animal)
            }
            if self.allAnimals != [] {
                self.allAnimalsSorted = self.allAnimals.sorted { $0.animalName ?? "" < $1.animalName ?? "" }
                self.allAnimals = self.allAnimalsSorted
                
// MARK: Add Additional Exhibits Here
                // Sort animals into gallery exhibits
                for animal in self.allAnimals {
                    guard let gallery = animal.gallery else { return }
                    switch gallery {
                    case "Discover Utah": self.discoverUtahAnimals.append(animal)
                    case "Journey to South America": self.jsaAnimals.append(animal)
                    case "Ocean Explorer": self.oceanExplorerAnimals.append(animal)
                    case "Expedition Asia": self.expeditionAsiaAnimals.append(animal)
                    case "Antarctic Adventure": self.antarcticAdventureAnimals.append(animal)
                    case "Deep Sea": self.deepSeaAnimals.append(animal)
                    case "Jellies": self.jellyfishTypes.append(animal)
                        
                    default: break
                        
                    }
                }
                self.sortGalleryData()
            }
        })
    }
    
    
    
    
    // MARK: - TableView Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView {
            return  self.allAnimals.count
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return 1
        } else {
            return self.allTheaterShows.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell") as! MapTableViewCell

            let mapData = self.allAnimals[indexPath.section]
            
            // Download image from Firebase Storage
            
            
            let reference = FIRStorageReference().child(mapData.animalImage ?? "")
            cell.cellImage.sd_setShowActivityIndicatorView(true)
            cell.cellImage.sd_setImage(with: reference)
            
            
            cell.cellLabel.text = mapData.animalName
            cell.cellImage.layer.cornerRadius = 5.0
            cell.cellImage.clipsToBounds = true
            cell.layer.cornerRadius = 5.0
            cell.clipsToBounds = true
            cell.cellImage.hero.id = "tableViewImage \(indexPath.section)"
            cell.cellLabel.hero.id = "animalName: \(indexPath.section)"
            
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "theaterCell") as! TheaterTimesTableViewCell
            let showtimes = self.allTheaterShows[indexPath.row]
            
            cell.moviePosterImage.image = showtimes.image
            cell.showTimesLabel.text = showtimes.showtimes
            
            cell.moviePosterImage.layer.cornerRadius = 5.0
            cell.moviePosterImage.clipsToBounds = true
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 5.0
            
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView {
            let animal = allAnimals[indexPath.section]
            let cell = self.tableView.cellForRow(at: indexPath) as! MapTableViewCell
            
            cell.cellImage.hero.id = "tableViewImage \(indexPath.section)"
            cell.cellLabel.hero.id = "animalName: \(indexPath.section)"
            self.animalName = animal.animalName ?? ""
            self.animalImage = animal.animalImage ?? ""
            self.animalInfo = animal.animalInfo ?? ""
            self.conservationStatus = animal.conservationStatus ?? ""
            
        }
        
        
    }
    
    func hideTableView() {
        self.tableView.isHidden = true
        self.galleryInfo.isHidden = false
        self.getDirectionsButton.isHidden = false
        self.scrollView.isHidden = false
        self.scrollView.setContentOffset(CGPoint.zero, animated: false)
        self.shadowView.isHidden = false
    }
    
    func showTableView() {
        self.tableView.isHidden = false
        self.galleryInfo.isHidden = true
        self.getDirectionsButton.isHidden = true
        self.scrollView.isHidden = true
        self.shadowView.isHidden = false
        self.tableView.setContentOffset(CGPoint.zero, animated: false)
        
    }
    
    func sortGalleryData() {
        
        switch self.galleryName {
            
        case galleries.amenities.name:
            hideTableView()
            self.theaterTableView.isHidden = true
            self.getDirectionsButton.isHidden = true
        
        case galleries.antarcticAdventure.name:
            showTableView()
            self.allAnimals = self.antarcticAdventureAnimals
            self.theaterTableView.isHidden = true
            
        case galleries.banquetHall.name:
            hideTableView()
            self.theaterTableView.isHidden = true
            
        case galleries.cafe.name:
            hideTableView()
            self.segueString = "toMenus"
            self.getDirectionsButton.isHidden = false
            
        case galleries.deepSeaLab.name:
            showTableView()
            self.allAnimals = self.deepSeaAnimals
            self.theaterTableView.isHidden = true
            
        case galleries.discoverUtah.name:
            showTableView()
            self.allAnimals = self.discoverUtahAnimals
            self.theaterTableView.isHidden = true
            
        case galleries.educationCenter.name:
            hideTableView()
            self.theaterTableView.isHidden = true
            
        case galleries.expeditionAsia.name:
            showTableView()
            self.allAnimals = self.expeditionAsiaAnimals
            self.theaterTableView.isHidden = true
            
        case galleries.jellyFish.name:
            showTableView()
            self.allAnimals = self.jellyfishTypes
            self.theaterTableView.isHidden = true
            
        case galleries.jsa.name:
            showTableView()
            self.allAnimals = self.jsaAnimals
            self.theaterTableView.isHidden = true
            
        case galleries.oceanExplorer.name:
            showTableView()
            self.allAnimals = self.oceanExplorerAnimals
            self.theaterTableView.isHidden = true
            
        case galleries.theater.name:
            hideTableView()
            self.theaterTableView.isHidden = false
            self.galleryInfo.isHidden = true
            self.scrollView.isHidden = true
            self.getDirectionsButton.isHidden = true
            
        case galleries.tukis.name:
            hideTableView()
            self.theaterTableView.isHidden = true
            
        default: break
            
        }
    
        tableView.reloadData()
        
    }
    
    
    
    
    
    func animateTappedGallery() {
        if self.viewIsUp {
            self.view.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 8.0, options: .allowUserInteraction, animations: {

            self.view.transform = CGAffineTransform(translationX: 0.0, y: -25.0)
            
        }, completion: nil)
            self.viewIsUp = true
        })
    }
    
    
    @objc func discoverUtah() {
        updateLabels(gallery: galleries.discoverUtah)
        animateTappedGallery()
        sortGalleryData()
    }
    
    @objc func antarcticAdventure() {
        updateLabels(gallery: galleries.antarcticAdventure)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.setTitle("Penguin Cam", for: .normal)
        self.urlString = "http://www.thelivingplanet.com/essential_grid/penguin-live-cam/"
        
    }
    
    @objc func ammenities() {
        updateLabels(gallery: galleries.amenities)
        animateTappedGallery()
        sortGalleryData()
        
    }
    
    @objc func banquetHall() {
        updateLabels(gallery: galleries.banquetHall)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.setTitle("Book an event!", for: .normal)
        self.segueString = "banquet"
    }
    
    @objc func asia() {
        updateLabels(gallery: galleries.expeditionAsia)
        animateTappedGallery()
        sortGalleryData()
        
    }
    
    @objc func jsa() {
        updateLabels(gallery: galleries.jsa)
        animateTappedGallery()
        sortGalleryData()

    }
    
    @objc func oceans() {
        updateLabels(gallery: galleries.oceanExplorer)
        animateTappedGallery()
        sortGalleryData()
        
    }
    
    @objc func tukis() {
        updateLabels(gallery: galleries.tukis)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.setTitle("Book a party!", for: .normal)
        self.segueString = "tukis"

    }
    @objc func jellies() {
        updateLabels(gallery: galleries.jellyFish)
        animateTappedGallery()
        sortGalleryData()

    }
    @objc func theater() {
        updateLabels(gallery: galleries.theater)
        animateTappedGallery()
        sortGalleryData()

    }
    @objc func educationCenter() {
        updateLabels(gallery: galleries.educationCenter)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.setTitle("More Info!", for: .normal)
        self.segueString = "educationCenter"

    }
    @objc func deepSea() {
        updateLabels(gallery: galleries.deepSeaLab)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.isHidden = true

    }
    @objc func cafe() {
        updateLabels(gallery: galleries.cafe)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.setTitle("View the Menu!", for: .normal)
        self.segueString = "toMenus"
        self.getDirectionsButton.isHidden = false
    
    }
    
    func postObservers() {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(BottomSheetViewController.discoverUtah), name: Notification.Name(rawValue: galleries.discoverUtah.name), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BottomSheetViewController.antarcticAdventure), name: Notification.Name(rawValue: galleries.antarcticAdventure.name), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BottomSheetViewController.ammenities), name: Notification.Name(rawValue: galleries.amenities.name), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BottomSheetViewController.asia), name: Notification.Name(rawValue: galleries.expeditionAsia.name), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BottomSheetViewController.jsa), name: Notification.Name(rawValue: galleries.jsa.name), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BottomSheetViewController.oceans), name: Notification.Name(rawValue: galleries.oceanExplorer.name), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BottomSheetViewController.tukis), name: Notification.Name(rawValue: galleries.tukis.name), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BottomSheetViewController.banquetHall), name: Notification.Name(rawValue: galleries.banquetHall.name), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BottomSheetViewController.jellies), name: Notification.Name(rawValue: galleries.jellyFish.name), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BottomSheetViewController.theater), name: Notification.Name(rawValue: galleries.theater.name), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BottomSheetViewController.educationCenter), name: Notification.Name(rawValue: galleries.educationCenter.name), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BottomSheetViewController.deepSea), name: Notification.Name(rawValue: galleries.deepSeaLab.name), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(BottomSheetViewController.cafe), name: Notification.Name(rawValue: galleries.cafe.name), object: nil)
        
        // Reloads bottomSheet viewController when leaving the app
        NotificationCenter.default.addObserver(self, selector: #selector(BottomSheetViewController.closeSwitchAction), name: NSNotification.Name(rawValue: "enteringBackground"), object: nil)
    }
    
    
    @objc func closeSwitchAction() {
        self.closeSwitch = true
    }
    
    func updateLabels(gallery: MapGalleries) {
        
        self.galleryName = gallery.name
        self.galleryTitleLabel.text = gallery.name
        self.galleryPhoto1.image = gallery.image1
        self.galleryInfo.text = gallery.info
        
    }
    
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        
        
        let translation = recognizer.translation(in: self.view)
        
        let velocity = recognizer.velocity(in: self.view)
        
        
        
        
        let y = self.view.frame.minY
        self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.0 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: .allowUserInteraction, animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                    UIView.animate(withDuration: 0.6, animations: {
                        self.pullArrow.image = #imageLiteral(resourceName: "upArrow")
                    })
                    
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                    UIView.animate(withDuration: 0.6, animations: {
                        self.pullArrow.image = #imageLiteral(resourceName: "expandArrow")
                    })
                }
                
            })
        }
        
        if recognizer.isUp(view: self.view) == false {
            self.viewIsUp = false
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 8.0, options: .allowUserInteraction, animations: {
                self.view.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
            }, completion: nil)
        }
    }

    
    // "More Info" Button
    @IBAction func getDirectionsButtonTapped(_ sender: AnyObject) {
        
        self.performSegue(withIdentifier: self.segueString, sender: nil)
        
    }
    
    func animateDown() {
        self.viewIsUp = false
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .allowUserInteraction, animations: {
            UIView.animate(withDuration: 0.5) {
                let frame = self.view.frame
                let yComponent = self.partialView
                self.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height)
            }
            
        }, completion: { (true) in
            UIView.animate(withDuration: 0.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 8.0, options: .allowUserInteraction, animations: {
                self.view.transform = .identity
            }, completion: nil)
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "toAnimalDetail" {
            
            if let destinationViewController = segue.destination as? AnimalDetailViewController {
                let indexPath = self.tableView.indexPath(for: (sender as! UITableViewCell))
                guard let newIndexPath = indexPath else { return }
                let animal = self.allAnimals[newIndexPath.section]

                
                destinationViewController.imageReference = animal.animalImage ?? ""
                destinationViewController.info = animal.animalInfo ?? ""
                destinationViewController.name = animal.animalName ?? ""
                destinationViewController.status = animal.conservationStatus ?? ""
                destinationViewController.factSheetString = animal.factSheet ?? ""
                destinationViewController.animalUpdates = animal.animalUpdates ?? ""
                destinationViewController.updateImage = animal.updateImage ?? ""
                destinationViewController.imageHeroID = "tableViewImage \(newIndexPath.section)"
                destinationViewController.titleLabelHeroID = "animalName: \(newIndexPath.section)"
                destinationViewController.dismissButtonHeroID = "tableViewInfoButton \(newIndexPath.section)"
                
                
            }
        }
        
        if let webviewDestination = segue.destination as? MapWebViewController {
            
        
        if segue.identifier == "banquet" {
            
            webviewDestination.buttonHidden = false
            webviewDestination.requestString = "http://thelivingplanet.com/corporateevents/"
            webviewDestination.titleLabelString = "Events At LLPA"
            }
            
            if segue.identifier == "tukis" {
                webviewDestination.buttonHidden = false
                webviewDestination.requestString = "http://www.thelivingplanet.com/home-4/parties/"
                webviewDestination.titleLabelString = "Parties"
                
            }
            
            if segue.identifier == "educationCenter" {
                webviewDestination.buttonHidden = false
                webviewDestination.requestString = "http://www.thelivingplanet.com/home-4/education/"
                webviewDestination.titleLabelString = "Education"
                
            }
        }
        
        
        
        
    }
    
    
    
}




