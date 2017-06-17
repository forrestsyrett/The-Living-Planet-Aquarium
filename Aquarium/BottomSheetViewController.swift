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


var galleryTest = ""

protocol BottomSheetViewControllerDelegate: class {
    func getDirectionsButtonTapped(_ bottomSheetViewController: BottomSheetViewController)
}

class BottomSheetViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, AnimalActionsDelegate  {
    
    
    static let shared = BottomSheetViewController()
    
    var titleLabel = "Test"
    
    // Info Variables
    weak var delegate: BottomSheetViewControllerDelegate?
    
    @IBOutlet var completeView: UIView!
    @IBOutlet weak var galleryTitleLabel: UILabel!
    @IBOutlet weak var galleryPhoto1: UIImageView!
    @IBOutlet weak var galleryInfo: UILabel!
    @IBOutlet weak var shadowView: UIImageView!
    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    var buttonAction = "Safari"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var theaterTableView: UITableView!
    
    let galleries = MapGalleryController.sharedController
    
    var galleryName = ""
    
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - 120
        
    }
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
    
    var mapGalleries = [MapGalleryController.sharedController.antarcticAdventure.name]
    var allTheaterShows = [TheaterShowsController.shared.penguins4D, TheaterShowsController.shared.sammyAndRay4D, TheaterShowsController.shared.wildCats3D]
    
    
    var animalInfo = ""
    var animalImage = ""
    var animalName = ""
    var conservationStatus = ""
    var animal: AnimalTest?
    var firebaseReference: FIRDatabaseReference!
    
    
    var closeSwitch: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.firebaseReference = FIRDatabase.database().reference()
        
        getAnimals()
        
        print("SHARED CONTROLLER \(AnimalController.shared.allAnimals.count)")
        print("JSA \(AnimalController.shared.jsaAnimals.count)")
        print("UTAH \(AnimalController.shared.discoverUtahAnimals.count)")
        print("ASIA \(AnimalController.shared.expeditionAsiaAnimals.count)")
        print("OCEANS \(AnimalController.shared.oceanExplorerAnimals.count)")
        print("AA \(AnimalController.shared.antarcticAdventureAnimals.count)")
        
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.panGesture))
        
        view.addGestureRecognizer(gesture)
        
        gesture.delegate = self
        
        roundedCorners(completeView, cornerRadius: 5.0)
        roundedCorners(galleryPhoto1, cornerRadius: 5.0)
        roundedCorners(handleView, cornerRadius: 5.0)
        roundedCorners(getDirectionsButton, cornerRadius: 5.0)
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
        
        
        
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.closeSwitch == true {
            UIView.animate(withDuration: 0.3) {
                let frame = self.view.frame
                let yComponent = UIScreen.main.bounds.height - 120
                self.view.frame = CGRect(x: 0, y: yComponent, width: frame.width, height: frame.height)
            }
        }
        
        self.closeSwitch = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /*    let frame = self.view.frame
         let yComponent = UIScreen.main.bounds.height - 120
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
            
            self.discoverUtahAnimals = []
            self.oceanExplorerAnimals = []
            self.expeditionAsiaAnimals = []
            self.jsaAnimals = []
            self.antarcticAdventureAnimals = []
            
            for item in snapshot.children {
                guard let animal = AnimalTest(snapshot: item as! FIRDataSnapshot) else { continue }
                self.allAnimals.append(animal)
            }
            if self.allAnimals != [] {
                self.allAnimalsSorted = self.allAnimals.sorted { $0.animalName ?? "" < $1.animalName ?? "" }
                self.allAnimals = self.allAnimalsSorted
                
                
                // Sort animals into gallery exhibits
                for animal in self.allAnimals {
                    guard let gallery = animal.gallery else { return }
                    switch gallery {
                    case "Discover Utah": self.discoverUtahAnimals.append(animal)
                    case "Journey to South America": self.jsaAnimals.append(animal)
                    case "Ocean Explorer": self.oceanExplorerAnimals.append(animal)
                    case "Expedition Asia": self.expeditionAsiaAnimals.append(animal)
                    case "Antarctic Adventure": self.antarcticAdventureAnimals.append(animal)
                        
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
            return  1
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return self.allAnimals.count
        } else {
            return self.allTheaterShows.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapCell") as! MapTableViewCell
            
            cell.delegate = self
            
            let mapData = self.allAnimals[indexPath.row]
            
            // Download image from Firebase Storage
            
            
            let reference = FIRStorageReference().child(mapData.animalImage ?? "")
            cell.cellImage.sd_setImage(with: reference, placeholderImage: #imageLiteral(resourceName: "fishFilled"))
            
            
            cell.cellLabel.text = mapData.animalName
            
            cell.animalInfoButton.tag = indexPath.row
            
            cell.cellImage.layer.cornerRadius = 5.0
            cell.cellImage.clipsToBounds = true
            
            
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "theaterCell") as! TheaterTimesTableViewCell
            let showtimes = self.allTheaterShows[indexPath.row]
            
            cell.moviePosterImage.image = showtimes.image
            cell.showTimesLabel.text = showtimes.showtimes
            
            cell.moviePosterImage.layer.cornerRadius = 5.0
            cell.moviePosterImage.clipsToBounds = true
            
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tableView {
            let animal = allAnimals[indexPath.row]
            self.animalName = animal.animalName ?? ""
            self.animalImage = animal.animalImage ?? ""
            self.animalInfo = animal.animalInfo ?? ""
            self.conservationStatus = animal.conservationStatus ?? ""
            
            self.performSegue(withIdentifier: "toAnimalDetail", sender: nil)
        }
        
        
    }
    
    func hideTableView() {
        self.tableView.isHidden = true
        self.galleryInfo.isHidden = false
        self.getDirectionsButton.isHidden = false
    }
    
    func showTableView() {
        self.tableView.isHidden = false
        self.galleryInfo.isHidden = true
        self.getDirectionsButton.isHidden = true
        
    }
    
    func sortGalleryData() {
        
        switch self.galleryName {
        case galleries.amenities.name:
            hideTableView()
            self.theaterTableView.isHidden = true
            
            
        case galleries.antarcticAdventure.name:
            showTableView()
            self.allAnimals = self.antarcticAdventureAnimals
            self.theaterTableView.isHidden = true
            
        case galleries.banquetHall.name:
            hideTableView()
            self.theaterTableView.isHidden = true
            
        case galleries.cafe.name:
            hideTableView()
            self.theaterTableView.isHidden = true
            
        case galleries.deepSeaLab.name:
            hideTableView()
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
            self.allAnimals = []
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
            self.getDirectionsButton.isHidden = true
            
        case galleries.tukis.name:
            hideTableView()
            self.theaterTableView.isHidden = true
            
        default: break
            
        }
        
        tableView.reloadData()
        
    }
    
    
    
    
    
    func animateTappedGallery() {
        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 8.0, options: .allowUserInteraction, animations: {
            self.view.transform = CGAffineTransform(translationX: 0.0, y: -25.0)
        }, completion: nil)
        
    }
    
    
    func discoverUtah() {
        updateLabels(gallery: galleries.discoverUtah)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.setTitle("More Info!", for: .normal)
        self.urlString = "http://www.thelivingplanet.com/essential_grid_category/discover-utah/"
        
    }
    
    func antarcticAdventure() {
        updateLabels(gallery: galleries.antarcticAdventure)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.setTitle("Penguin Cam", for: .normal)
        self.urlString = "http://www.thelivingplanet.com/essential_grid/penguin-live-cam/"
        
    }
    
    func ammenities() {
        updateLabels(gallery: galleries.amenities)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.setTitle("More Info!", for: .normal)
        self.urlString = "http://www.thelivingplanet.com/"
    }
    
    func banquetHall() {
        updateLabels(gallery: galleries.banquetHall)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.setTitle("Book an event!", for: .normal)
        self.urlString = "http://www.thelivingplanet.com/essential_grid/wedding-proposals/"
    }
    
    func asia() {
        updateLabels(gallery: galleries.expeditionAsia)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.setTitle("More Info!", for: .normal)
        self.urlString = "http://www.thelivingplanet.com/essential_grid/expedition-asia/"
    }
    
    func jsa() {
        updateLabels(gallery: galleries.jsa)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.setTitle("More Info!", for: .normal)
        self.urlString = "http://www.thelivingplanet.com/essential_grid_category/south-america/"
    }
    
    func oceans() {
        updateLabels(gallery: galleries.oceanExplorer)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.setTitle("More Info!", for: .normal)
        self.urlString = "http://www.thelivingplanet.com/essential_grid_category/invertebrates/"
    }
    
    func tukis() {
        updateLabels(gallery: galleries.tukis)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.setTitle("Book a party!", for: .normal)
        self.urlString = "http://www.thelivingplanet.com/home-4/parties/"
    }
    func jellies() {
        updateLabels(gallery: galleries.jellyFish)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.setTitle("More Info!", for: .normal)
        self.urlString = "http://www.thelivingplanet.com/essential_grid/ocean-explorer/"
    }
    func theater() {
        updateLabels(gallery: galleries.theater)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.setTitle("Check schedule", for: .normal)
        self.urlString = "http://www.thelivingplanet.com/essential_grid/4d-theatre-showtimes/"
    }
    func educationCenter() {
        updateLabels(gallery: galleries.educationCenter)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.setTitle("More Info!", for: .normal)
        self.urlString = "http://www.thelivingplanet.com/home-4/education/"
    }
    func deepSea() {
        updateLabels(gallery: galleries.deepSeaLab)
        animateTappedGallery()
        sortGalleryData()
        self.getDirectionsButton.setTitle("More Info!", for: .normal)
        self.urlString = "http://www.thelivingplanet.com/essential_grid/exhibit-updates/"
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
        
        // Reloads bottomSheet viewController when leaving the app
        NotificationCenter.default.addObserver(self, selector: #selector(BottomSheetViewController.closeSwitchAction), name: NSNotification.Name(rawValue: "enteringBackground"), object: nil)
    }
    
    
    func closeSwitchAction() {
        self.closeSwitch = true
    }
    
    func updateLabels(gallery: MapGalleries) {
        
        self.galleryName = gallery.name
        self.galleryTitleLabel.text = gallery.name
        self.galleryPhoto1.image = gallery.image1
        self.galleryInfo.text = gallery.info
        
    }
    
    
    func panGesture(recognizer: UIPanGestureRecognizer) {
        
        
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
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            })
        }
        
        if recognizer.isUp(view: self.view) == false {
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 8.0, options: .allowUserInteraction, animations: {
                self.view.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
            }, completion: nil)
            
            
        }
        
        
    }
    
    
    
    
    
    // MARK: - Delegate Functions
    
    func infoButtonAction(_ mapTableViewCell: MapTableViewCell) {
        
        guard let indexPath = tableView.indexPath(for: mapTableViewCell) else { return }
        let animal = self.allAnimals[(indexPath as NSIndexPath).row]
        self.animalImage = animal.animalImage ?? ""
        self.animalInfo = animal.animalInfo ?? ""
        self.animalName = animal.animalName ?? ""
        self.conservationStatus = animal.conservationStatus ?? ""
        
        print("Info button tapped for \(animal.animalName ?? "")")
        self.performSegue(withIdentifier: "toAnimalDetail", sender: self)
        
        self.closeSwitch = false
    }
    
    func locateButtonAction(_ mapTableViewCell: MapTableViewCell) {
        guard let indexPath = tableView.indexPath(for: mapTableViewCell) else { return }
        let animal = self.allAnimals[(indexPath as NSIndexPath).row]
        print("Locate button tapped for \(animal.animalName ?? "")")
    }
    
    func feedingButtonAction(_ mapTableViewCell: MapTableViewCell) {
        guard let indexPath = tableView.indexPath(for: mapTableViewCell) else { return }
        let animal = self.allAnimals[(indexPath as NSIndexPath).row]
        print("Feeding button tapped for \(animal.animalName ?? "")")
    }
    
    
    
    
    // "More Info" Button
    @IBAction func getDirectionsButtonTapped(_ sender: AnyObject) {
        
        
        switch self.buttonAction {
        case ButtonActions.Safari.rawValue:
            delegate?.getDirectionsButtonTapped(self)
            
            animateDown()
            
            let url = URL(string: self.urlString)!
            let safariViewController = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            safariViewController.preferredBarTintColor = UIColor(red:0.00, green:0.10, blue:0.20, alpha:1.00)
            safariViewController.preferredControlTintColor = UIColor.white
            
            self.present(safariViewController, animated: true, completion: nil)
            
            
        case ButtonActions.WebView.rawValue:
            storyboard?.instantiateViewController(withIdentifier: "webview")
        default: break
        }
        
    }
    
    func animateDown() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .allowUserInteraction, animations: {
            UIView.animate(withDuration: 0.5) {
                let frame = self.view.frame
                let yComponent = UIScreen.main.bounds.height - 145
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
                
                destinationViewController.imageReference = self.animalImage
                destinationViewController.info = self.animalInfo
                destinationViewController.name = self.animalName
                destinationViewController.status = self.conservationStatus
                
            }
        }
        
    }
    
    
    
}


// Checks to see if panGesture is moving up or down
extension UIPanGestureRecognizer {
    
    //    func isUp(view: UIView) -> Bool {
    //
    //        let direction: CGPoint = velocity(in: view)
    //        if direction.y < 0 {
    //            // Panning up
    //            return true
    //        } else {
    //            // Panning Down
    //            return false
    //        }
    //    }
}

