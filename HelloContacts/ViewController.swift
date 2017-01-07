//
//  ViewController.swift
//  HelloContacts
//
//  Created by Weijie Gao on 1/6/17.
//  Copyright © 2017 Weijie. All rights reserved.
//
import UIKit
import Contacts

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var tableView: UITableView!

    var contacts = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        let store = CNContactStore()
        
        if CNContactStore.authorizationStatus(for: .contacts) == .notDetermined {
            store.requestAccess(for: .contacts, completionHandler: {[weak self]
                authorized, error in
                    if authorized {
                        self?.retrieveContacts(fromStore: store)
                    }
            })
        }else if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            self.retrieveContacts(fromStore: store)
        }
    }
    
    
    
    // table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as! ContactTableViewCell
        
        let contact = contacts[indexPath.row]
        
        cell.nameLabel.text = "\(contact.givenName) \(contact.familyName)"
        if let imageData = contact.imageData, contact.imageDataAvailable {
            cell.contactImage.image = UIImage(data: imageData)
            
        }
        return cell
    }
    
   
    

    
    
    
    func retrieveContacts(fromStore store: CNContactStore) {
        let keysToFetch =
            [CNContactGivenNameKey as CNKeyDescriptor,
             CNContactFamilyNameKey as CNKeyDescriptor,
             CNContactImageDataKey as CNKeyDescriptor,
             CNContactImageDataAvailableKey as CNKeyDescriptor]
        let containerId = store.defaultContainerIdentifier()
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
        contacts = try! store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
        tableView.reloadData()
    }
    

    
    
    
    
    
    
    
    
    

}

