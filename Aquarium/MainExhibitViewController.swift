//
//  MainExhibitViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 11/17/16.
//  Copyright © 2016 Forrest Syrett. All rights reserved.
//
import UIKit
import FlowingMenu
import Firebase
import FirebaseStorage
import FirebaseStorageUI
import NVActivityIndicatorView
import Hero

class MainExhibitViewController: UIViewController, FlowingMenuDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MainExhibitTableViewControllerDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let flowingMenuTransitionManager = FlowingMenuTransitionManager()
    var menu: UIViewController?
    var allAnimals: [AnimalTest] = []
    var allAnimalsSorted: [AnimalTest] = []
    
    var discoverUtahAnimals: [AnimalTest] = []
    var oceanExplorerAnimals: [AnimalTest] = []
    var expeditionAsiaAnimals: [AnimalTest] = []
    var jsaAnimals: [AnimalTest] = []
    var antarcticAdventureAnimals: [AnimalTest] = []
    
    var dataSourceForSearchResult:[AnimalTest]?
    var searchBarIsActive: Bool = false
    var searchBarBoundsY: CGFloat?
    var firebaseReference: FIRDatabaseReference!
    var heroIDString = ""
    var initialLoading = true
    var keyboardIsUp = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = false
        
        self.firebaseReference = FIRDatabase.database().reference()
        
        getAnimals()
        setSearchBarView()
        tabBarTint(view: self)
        transparentNavigationBar(self)
        gradient(self.view)
        
        
        // Add the pan screen edge gesture to the current view //
        flowingMenuTransitionManager.setInteractivePresentationView(view)
        
        
        // Add the delegate to respond to interactive transition events
        flowingMenuTransitionManager.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainExhibitViewController.updateToAllAnimals), name: Notification.Name(rawValue: "allAnimals"), object: nil)
        
        registerForKeyboardNotifications()
        
        
        let downGesture = UIPanGestureRecognizer.init(target: self,action: #selector(MainExhibitViewController.panGesture))
        searchBar.addGestureRecognizer(downGesture)
        
        downGesture.delegate = self
        
        
    }
    
    func panGesture(recognizer: UIPanGestureRecognizer) {
        
        if !recognizer.isUp(view: self.searchBar) {
            self.searchBar.resignFirstResponder()
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        IndexController.shared.index = (self.tabBarController?.selectedIndex)!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar.isHidden = false
    }
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    
    func getAnimals() {
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
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
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                AnimalController.shared.allAnimals = self.allAnimals
                
                self.collectionView.layoutIfNeeded()
                self.collectionView.reloadData()
                
                
                self.allAnimalsSorted = self.allAnimals.sorted { $0.animalName ?? "" < $1.animalName ?? "" }
              
                self.allAnimals = self.allAnimalsSorted
                self.dataSourceForSearchResult = [AnimalTest]()
                
                
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
                
                self.initialLoading = false
          
            }
        })
        
    }
    
    
    
    
    
    // MARK: - Search Bar Functions
    
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarIsActive = true
        allAnimals = allAnimalsSorted
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarIsActive = false
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.characters.count > 0 {
            self.searchBarIsActive = true
            filterSearchResults(searchText: searchText)
            
        } else {
            self.searchBarIsActive = false
            self.collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.searchBarIsActive = false
        self.searchBar.text = ""
        self.collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarIsActive = false
        self.searchBar.resignFirstResponder()
        
    }
    
    
    
    ////////////////////////////////////////////////////////
    //          MARK: - Keyboard Functions                //
    ////////////////////////////////////////////////////////
    
    
    
    func resignKeyboard() {
        searchBar.resignFirstResponder()
        setSearchBarView()
        
    }
    func setSearchBarView() {
        searchBar.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 100, width: view.frame.width, height: 50)
        self.searchBar.isHidden = false
    }
    
    // Mark: - SearchBar Movement Response to Keyboard
    
    func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainExhibitViewController.resignKeyboard), name: Notification.Name(rawValue: "enteringBackground"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainExhibitViewController.setSearchBarView), name: Notification.Name(rawValue: "active"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainExhibitViewController.resignKeyboard), name: Notification.Name(rawValue: "exhibitsAppeared"), object: nil)
    }
    
    func removeObservers() {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "enteringBackground" ), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "active" ), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "allAnimals" ), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "exhibitsAppeared"), object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        print("rise keyboard")
        
        if self.keyboardIsUp == false {
            self.keyboardIsUp = true
        
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight: CGFloat = (keyboardSize?.height)!
        
        UIView.animate(withDuration: 0.40, delay: 0.027, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            self.searchBar.frame = CGRect(x: 0, y: (self.searchBar.frame.origin.y - keyboardHeight + 50), width: self.view.bounds.width, height: 50)
        }, completion: nil)
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.searchBar {
            if (!aRect.contains(activeField.frame.origin)){
            }
        }
        }
        
}
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return text.canBeConverted(to: String.Encoding.ascii)
        }
    
    
    
    func keyboardWillBeHidden(notification: NSNotification) {
        _ = notification.userInfo!
        //     let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        //     let keyboardHeight: CGFloat = (keyboardSize?.height)!
        
        if self.keyboardIsUp == true {
            self.keyboardIsUp = false
        
        UIView.animate(withDuration: 0.20, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {

            self.setSearchBarView()
        }, completion: nil)
        
        self.view.endEditing(true)
        }
    }
    ///////////////////////////////////////////////////
    
    // Generate cells for animals
    // MARK: - CollectionView Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.searchBarIsActive && (self.searchBar.text?.characters.count)! > 0 {
            return self.dataSourceForSearchResult!.count
        } else {
            return allAnimals.count
        }}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AnimalCollectionViewCell
        let index = indexPath.row
        
        cell.newsRibbon.heroModifiers = [.fade]
        cell.heroID = "animal: \(indexPath.row)"
        cell.animalImage.heroID = "animalImage: \(indexPath.row)"
        cell.newsRibbonHeight.constant = 0.0
        cell.layoutIfNeeded()
        var animal = allAnimals[indexPath.row]
        
        //Get odd numbers (right hand column)
        if indexPath.row % 2 == 1 {
            cell.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0.0)
        } else {
            //Left hand column
            cell.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0.0)
        }
        
        // Animal data when search is being performed
        if self.searchBarIsActive && (self.searchBar.text?.characters.count)! > 0 {
            
            animal = (self.dataSourceForSearchResult?[indexPath.row])!
            cell.animalNameLabel.text = self.dataSourceForSearchResult?[indexPath.row].animalName
            let reference = FIRStorageReference().child(animal.animalImage ?? "")
            cell.animalImage.sd_setImage(with: reference)
            cell.animalImage.sd_setShowActivityIndicatorView(true)
            
        } else {
            //     Animal Data When Search is NOT being performed
            
            let animal = allAnimals[indexPath.row]
            
            let reference = FIRStorageReference().child(animal.animalImage ?? "")
            cell.animalImage.sd_setImage(with: reference)
            cell.animalImage.sd_setShowActivityIndicatorView(true)
            cell.animalNameLabel.text = animal.animalName
            
            
            
            
        }
            // Show cascade animation on first load
        
        var delay = 0.05 * Double(index) / 2
            if cell.didAnimate == false {
                delay = 0.05 * Double(index) / 2
                
                UIView.animate(withDuration: 0.85, delay: delay, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.1, options: .allowUserInteraction, animations: {
                    cell.transform = CGAffineTransform.identity
                    cell.layoutIfNeeded()
                    cell.didAnimate = true
                }, completion: nil)
            } else {
            cell.transform = CGAffineTransform.identity
        }
        

                //Check for animal updates, and show ribbon
                if animal.animalUpdates != "none" {
                    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {
                        cell.newsRibbonHeight.constant = 58.0
                        cell.layoutIfNeeded()
                    }, completion: nil)
                    
                    // No animal updates at the moment, hide ribbon
                } else {
                    cell.newsRibbonHeight.constant = 0.0
                    cell.layoutIfNeeded()
            }
        
        
        cell.layer.cornerRadius = 5.0
        
        return cell
        
        
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! AnimalCollectionViewCell
        cell.heroID = "animal: \(indexPath.row)"
        cell.animalImage.heroID = "animalImage: \(indexPath.row)"
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((self.collectionView.frame.width / 2) - 12), height: collectionView.frame.height / 3.75)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }

    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    
    // MARK: - Gallery Selected Delegate Methods
    
    func gallerySelected(indexPath: Int) {
        
        switch indexPath {
        case 0: allAnimals = self.discoverUtahAnimals
        case 1: allAnimals = self.jsaAnimals
        case 2: allAnimals = self.oceanExplorerAnimals
        case 3: allAnimals = self.antarcticAdventureAnimals
        case 4: allAnimals = self.expeditionAsiaAnimals
        default: break
        }
        self.collectionView.reloadData()
        menu?.dismiss(animated: true, completion: nil)
    }
    
    ///////////////
    
    
    
    func updateToAllAnimals() {
        allAnimals = allAnimalsSorted
        self.collectionView.reloadData()
        menu?.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toExhibits" {
            let destinationViewController  = segue.destination as! MainExhibitTableViewController
            destinationViewController.transitioningDelegate = flowingMenuTransitionManager
            destinationViewController.delegate = self
            
            // Add the left pan gesture to the  menu
            flowingMenuTransitionManager.setInteractiveDismissView(destinationViewController.view)
            menu = destinationViewController
        }
        
        if segue.identifier == "toAnimalDetail" {
            self.searchBar.resignFirstResponder()
            self.searchBarIsActive = false
            if let destinationViewController = segue.destination as? AnimalDetailViewController {
                
                let indexPath = self.collectionView.indexPath(for: (sender as! UICollectionViewCell))
                
                guard let newIndexPath = indexPath else { return }
                let heroString = "animal: \(newIndexPath.row)"
                let imageHeroID = "animalImage: \(newIndexPath.row)"
                let titleLabelHeroID = "titleLabel: \(newIndexPath.row)"
                
                destinationViewController.view.heroID = heroString
                destinationViewController.imageHeroID = imageHeroID
                destinationViewController.titleLabelHeroID = titleLabelHeroID
                
                if let selectedItem = (indexPath as NSIndexPath?)?.row {
                    
                    if (self.searchBar.text?.characters.count)! > 0 {
                        let animal = dataSourceForSearchResult?[selectedItem]
                        destinationViewController.updateInfo(animal: animal!)
                        destinationViewController.view.heroID = heroString
                        destinationViewController.imageHeroID = imageHeroID
                        destinationViewController.titleLabelHeroID = titleLabelHeroID
                        
                    }
                    else  {
                        let animal = allAnimals[selectedItem]
                        destinationViewController.view.heroID = heroString
                        destinationViewController.imageHeroID = imageHeroID
                        destinationViewController.titleLabelHeroID = titleLabelHeroID
                        destinationViewController.updateInfo(animal: animal)
                        destinationViewController.animal = animal.animalName!
                    }
                }
            }
        }
        
        if segue.identifier == "toQRScanner" {
            
            if let destinationViewController = segue.destination as? QRScannerViewController {
                
                destinationViewController.scanType = "qr"
            }
        }
        
    
        
    }
    
    // MARK: - Delegate Functions
    
    func flowingMenuNeedsPresentMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        performSegue(withIdentifier: "toExhibits", sender: self)
    }
    
    func flowingMenuNeedsDismissMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        menu?.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    // MARK: - Search Filter
    
    func filterSearchResults(searchText: String) {
        
        let animals = allAnimals.filter { ( ($0.animalName?.range(of: searchText) != nil))}
        dataSourceForSearchResult = animals
        self.collectionView.reloadData()
        
    }
    
    
    deinit {
        removeObservers()
    }
    
    
}
