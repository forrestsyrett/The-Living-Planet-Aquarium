//
//  EventsViewController.swift
//  Aquarium
//
//  Created by Forrest Syrett on 5/31/17.
//  Copyright © 2017 Forrest Syrett. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import JTAppleCalendar
import AlamofireObjectMapper
import UserNotifications



class EventsViewController: UIViewController {
    
    //  @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var notificationController = NotificationController()
    
    
    var currentDate = Date()
    
    let outsideMonthColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
    let monthColor = UIColor.white
    let dateFormatter = DateFormatter()
    
    
    var calendarEvents: [Event] = []
    var month = ""
    var monthIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendar()
        gradient(self.view)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        IndexController.shared.index = (self.tabBarController?.selectedIndex)!
        self.tableView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func setupCalendar() {
        
        //Set currentDate
        var date = Date()
        var components = DateComponents()
        let calendar = Calendar.current
        components.year = Calendar.current.component(.year, from: date)
        components.month = Calendar.current.component(.month, from: date)
        components.day = Calendar.current.component(.day, from: date)
        components.hour = Calendar.current.component(.hour, from: date)
        components.minute = Calendar.current.component(.minute, from: date)
        components.second = Calendar.current.component(.second, from: date)
        components.timeZone = TimeZone(abbreviation: "MDT")!
        date = calendar.date(from: components)!
        
        
        self.currentDate = calendar.date(from: components)!
        
        calendarView.scrollToDate(currentDate)
        calendarView.selectDates([currentDate])
        
        //Setup Calendar Spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        
        calendarView.layer.borderColor = UIColor.white.cgColor
        calendarView.layer.borderWidth = 1.0
        
        //setup labels
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    

    
    
    
    
    func animateTableView(completion: @escaping (Bool) -> ()) {
      
        self.tableView.reloadData()
        
        let cells = self.tableView.visibleCells
        let tableHeight: CGFloat = self.tableView.bounds.size.height
        
        
        for eventCell in cells {
            let cell: UITableViewCell = eventCell as! EventTableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            
            let cell: UITableViewCell = a as! EventTableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: { _ in
                self.tableView.reloadData()
            })
            
            index += 1
        
        }
        completion(true)
 
    }
    
    
    
    
    
    
    /////////////////////////////////////////////
    func getCalendarItems() {
        
        
        self.activityMonitor.isHidden = false
        self.activityMonitor.startAnimating()
        
        let calendar = Calendar.current
        self.calendarEvents = []
        
        let currentDate = self.currentDate
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
        let dateTimeMin = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentDate)
        
        let dateTimeMax = calendar.date(bySettingHour: 23, minute: 59, second: 0, of: dateTimeMin!)
        
        let timeMin = formatter.string(from: dateTimeMin!)
        let timeMax = formatter.string(from: dateTimeMax!)
   
        
        let body : Parameters  = [
            "calendarId" : "ahyde1973@gmail.com",
            "singleEvents": "true",
            "timeMin": timeMin,
            "timeMax": timeMax,
            "orderBy": "startTime"
        ]
        let calendarId: String = "ahyde1973@gmail.com"
        let apiKey: String = "AIzaSyCRN-lvkpHLtGj8ZX_gkHXkM7O16RTUn_w"
        let urlFormat: String = "https://www.googleapis.com/calendar/v3/calendars/%@/events?key=%@&fields=items(id,start,summary,status)"
        let calendarUrl = String(format: urlFormat, calendarId, apiKey)
        
        Alamofire.request(calendarUrl, parameters: body).responseObject { (response: DataResponse<AllEvents>) in
            print("EXECUTING...")
            
            switch response.result {
            case .success:
                guard let event = response.result.value else { return }
                
                guard let events = event.events else { return }
                
                for singleEvent in events {
                    self.calendarEvents.append(singleEvent)
                 //   print("EventName: \(singleEvent.eventName) \(singleEvent.scheduled)")
                    
                }
                self.checkScheduledEvents(completionHandler: { (complete) in
                    
                    if complete {
                self.animateTableView(completion: { (true) in
                    
                        self.activityMonitor.stopAnimating()
                        self.activityMonitor.isHidden = true
                        print("Execution Finished")
                        })
                
                } else {
                    print("not complete")
                        }
                    
                
                
                
                
            })
            case .failure(let error):
                print(error)
                
            }
        
        }
        
    }
    
    
    ////////////////////////////////////////////
    
    func getDate(dateString: String) -> Date {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy, HH:mm"
        let date = formatDate(dateString: dateString)
        guard let newDate = formatter.date(from: date) else { return Date() }
        
        print("newDate: \(newDate)")
        return newDate
    }
    
    
    func getComparableDate(dateString: String) -> Date {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
        guard let date = formatter.date(from: dateString) else { return Date() }
        
        return date
    }
    
    
    
    func formatDate(dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
        
        let cleanDateFormat = DateFormatter()
        cleanDateFormat.dateStyle = .none
        cleanDateFormat.timeStyle = .short
        
        guard let newDate = formatter.date(from: dateString) else { return "" }
        
        
        let cleanDate = cleanDateFormat.string(from: newDate)
        
        return cleanDate
        
    }
    
    
    
    func handleCellSelected(cell: JTAppleCell?, cellState: CellState) {
        
        guard let validCell = cell as? CustomCell else { return }
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else { return }
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = .black
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = self.monthColor
            } else {
                validCell.dateLabel.textColor = self.outsideMonthColor
            }
        }
    }
    
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        
        
        guard let date = visibleDates.monthDates.first?.date else { return }
        
        //   self.dateFormatter.dateFormat = "yyyy"
        // self.yearLabel.text = self.dateFormatter.string(from: date)
        
        
        self.dateFormatter.dateFormat = "MMMM"
        self.monthLabel.text = self.dateFormatter.string(from: date)
    }
    
    @IBAction func reloadTableVIew(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    
    
/////////////////////////////////////////
    
    func checkScheduledEvents(completionHandler: @escaping (_ complete: Bool) -> ()) {
        var identifiers: [String] = []
        print("checking events")
         UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (requests) in
            
            for request in requests {
                if !identifiers.contains(request.identifier) {
                    identifiers.append(request.identifier)
                }
            }
            print(self.calendarEvents.count)
            
        for event in self.calendarEvents {
             let notificationIdentifier = "\(event.eventName ?? "Event Name") \(event.eventDate ?? "Event Date")"
            
            if identifiers.contains(notificationIdentifier) {
                event.scheduled = true
            } else {
                event.scheduled = false
            }
        }
    })

        let flag = true
       
        completionHandler(flag)
        
    }
}

    // MARK: - Calendar Methods
extension EventsViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        
        let startDate = dateFormatter.date(from: "2017 01 01")!
        let endDate = dateFormatter.date(from: "2017 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 1, calendar: nil, generateInDates: nil, generateOutDates: nil, firstDayOfWeek: nil, hasStrictBoundaries: nil)
        return parameters
    }
    
}


extension EventsViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
        cell.selectedView.layer.cornerRadius = 15.0
        cell.selectedView.layer.borderWidth = 1.0
        cell.selectedView.layer.borderColor = UIColor.white.cgColor
        cell.selectedView.backgroundColor = aquaLight
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
        
        
        if cellState.dateBelongsTo == .followingMonthWithinBoundary || cellState.dateBelongsTo == .previousMonthWithinBoundary {
            calendar.scrollToDate(date)
        }
        
        self.currentDate = cellState.date
        getCalendarItems()
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
        
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
}



extension EventsViewController: UITableViewDelegate, UITableViewDataSource,EventTableViewCellDelegate {
    
    
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calendarEvents.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
        cell.delegate = self
        
        let event = self.calendarEvents[indexPath.row]
        cell.eventNameLabel.text = event.eventName
        
        guard let eventDate = event.eventDate else {
            cell.eventTimeLabel.text = ""
            return cell
        }
        cell.eventTimeLabel.text = self.formatDate(dateString: eventDate)
        
        
        
        let date = getComparableDate(dateString: eventDate)
        let currentDate = Date()

        // Check to see if event notification is already scheduled
        // Disable scheduling notification if event is in the past.
        // Allow User to cancel notification if event is currently scheduled.
      
        cell.notifyMeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cell.notifyMeButton.titleLabel?.minimumScaleFactor = 0.5
        
        
        
        if currentDate >= date.addingTimeInterval(15 * 60) {
            cell.notifyMeButton.alpha = 0.45
            cell.notifyMeButton.tintColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 0.45)
            cell.notifyMeButton.isEnabled = false
            cell.notifyMeButton.layer.borderWidth = 0.0
            cell.notifyMeButton.setTitle("Event Over", for: .normal)
            
        } else if currentDate > date.addingTimeInterval(-15 * 60) && currentDate < date {
            cell.notifyMeButton.alpha = 1.0
            cell.notifyMeButton.tintColor = .white
            cell.notifyMeButton.isEnabled = false
            cell.notifyMeButton.layer.borderColor = UIColor.lightGray.cgColor
            cell.notifyMeButton.layer.borderWidth = 1.0
            cell.notifyMeButton.setTitle("Starting Soon", for: .normal)
            
        } else if currentDate >= date && currentDate < date.addingTimeInterval(15 * 60) {
            cell.notifyMeButton.alpha = 1.0
            cell.notifyMeButton.tintColor = .white
            cell.notifyMeButton.isEnabled = false
            cell.notifyMeButton.layer.borderColor = UIColor.white.cgColor
            cell.notifyMeButton.layer.borderWidth = 1.0
            cell.notifyMeButton.setTitle("In Progress", for: .normal)
            
        } else {
            
                if currentDate < date.addingTimeInterval(-15 * 60) {
                    
          if event.scheduled == true {
            cell.notifyMeButton.alpha = 1.0
            cell.notifyMeButton.tintColor = .white
            cell.notifyMeButton.isEnabled = true
            cell.notifyMeButton.layer.borderWidth = 0.0
            cell.notifyMeButton.setTitle("Cancel", for: .normal)
           
        } else if event.scheduled == false {
            cell.notifyMeButton.alpha = 1.0
            cell.notifyMeButton.tintColor = .white
            cell.notifyMeButton.isEnabled = true
            cell.notifyMeButton.layer.borderWidth = 0.0
            cell.notifyMeButton.setTitle("Notify Me!", for: .normal)
          } else {
            cell.notifyMeButton.alpha = 0.45
            cell.notifyMeButton.tintColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 0.45)
            cell.notifyMeButton.isEnabled = false
            cell.notifyMeButton.layer.borderWidth = 0.0
            cell.notifyMeButton.setTitle("Loading...", for: .normal)
        }
    }
}
        return cell
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - EventCell Delegate Schedule Notification
    
    func eventNotificationScheduled(_ eventTableViewCell: EventTableViewCell) {
        
        UNUserNotificationCenter.current().delegate = self
        
        let notificationStatus = UIApplication.shared.currentUserNotificationSettings?.types.contains([.alert]) ?? false
        
        
        guard let indexPath = tableView.indexPath(for: eventTableViewCell) else { return }
        
        let event = self.calendarEvents[indexPath.row]
        
        // Check if user has allowed for local notifications
        
        // User has not allowed for notifications, but tapped "notify me" button. Prompt to change settings
        if notificationStatus == false && eventTableViewCell.notifyMeButton.titleLabel?.text == "Notify Me!" {
            let alert = UIAlertController(title: "Notifications are not enabled", message: "To receive notifications on feeding times and other Aquarium events, please change your notification settings.", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
    
            let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { (toSettings) in
                guard let url = URL(string: UIApplicationOpenSettingsURLString) else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
            
            alert.addAction(dismissAction)
            alert.addAction(settingsAction)
            
            
            self.present(alert, animated: true, completion: nil)
            
            // User has allowed for notifications
            
        } else {
            
            // Check to see if notification is already pending
            // Notification is not pending
            
            if eventTableViewCell.notifyMeButton.titleLabel?.text == "Notify Me!" {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssxxxxx"
                formatter.locale = Locale(identifier: "en_US")
                let date = formatter.date(from: event.eventDate!)
                let notificationDate = date?.addingTimeInterval(TimeInterval(-60 * 15))
                
                notificationController.scheduleNewNotification(on: notificationDate!, event: event)
           
                // set button title label to show notification is pending
                eventTableViewCell.notifyMeButton.setTitle("Cancel", for: .normal)
                checkScheduledEvents(completionHandler: { (true) in
                
                })
                
                // Cancel pending notification
            } else {
                eventTableViewCell.notifyMeButton.setTitle("Notify Me!", for: .normal)
            
                print("cancel function reached")
                
                                        // Get notification that corresponds to the cell tapped
                        let notificationIdentifier = "\(event.eventName ?? "Event Name") \(event.eventDate ?? "Event Date")"
         
                            // Remove the notification
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
                            print("Notification Removed")
                checkScheduledEvents(completionHandler: { (true) in
                    
                })
                        }
                    }
            }
            
        }


extension EventsViewController: UNUserNotificationCenterDelegate {

        
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
            print("User Tapped Notification")
        }
        
        //This is key callback to present notification while the app is in foreground
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            
            print("Notification being triggered")
            
                completionHandler( [.alert, .sound, .badge])
                
            }
        }



