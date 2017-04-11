//
//  MainVC.swift
//  MicrosoftChallenge
//
//  Created by Jason Piao on 2017-03-19.
//  Copyright © 2017 Jason Piao. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segControl: UISegmentedControl!
    
    var fetchedResultsController: NSFetchedResultsController<Event>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        attemptFetchRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        attemptFetchRequest()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as? EventCell {
            configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            return cell
        }
        
        return EventCell()
    }
    
    //calling configure cell in this VC too, configure cell func in EventCell as well
    func configureCell(cell: EventCell, indexPath: NSIndexPath) {
    
        let event = fetchedResultsController.object(at: indexPath as IndexPath)
        cell.configureCell(event: event)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let event = fetchedResultsController.object(at: indexPath as IndexPath)
        performSegue(withIdentifier: "DetailsVC", sender: event)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailsVC" {
            if let dest = segue.destination as? DetailsVC {
                if let event = sender as? Event {
                    dest.eventToEdit = event
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.name
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
    func attemptFetchRequest() {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        //will keep track of how to sort our table view and modify our headers
        var key: String!
        
        if segControl.selectedSegmentIndex == 0 {
            key = "fullDate"
        } else {
            key = "tag"
        }
        
        let sort = NSSortDescriptor(key: key, ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: key, cacheName: nil)
        
        controller.delegate = self
        
        self.fetchedResultsController = controller
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let err = error as NSError
            print("\(err)")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        //tableView.beginUpdates()
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.reloadData()
        //tableView.endUpdates()
    }
    
    //    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    //
    //        switch(type) {
    //
    //        case.insert:
    //            if let indexPath = newIndexPath {
    //                tableView.insertRows(at: [indexPath], with: .fade)
    //            }
    //            break
    //        case.delete:
    //            if let indexPath = indexPath {
    //                tableView.deleteRows(at: [indexPath], with: .fade)
    //            }
    //            break
    //        case.update:
    //            if let indexPath = newIndexPath {
    //                if let cell = tableView.cellForRow(at: indexPath) as? EventCell {
    //                    configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
    //                }
    //
    //            }
    //            break
    //        case.move:
    //            if let indexPath = indexPath {
    //                tableView.deleteRows(at: [indexPath], with: .fade)
    //            }
    //            if let indexPath = newIndexPath {
    //                tableView.insertRows(at: [indexPath], with: .fade)
    //            }
    //            break
    //
    //        }
    //    }
    
    @IBAction func segControllerChanged(_ sender: Any) {
        
        attemptFetchRequest()
        tableView.reloadData()
    }
    
}
