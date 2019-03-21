//
//  AppleSearchTableViewController.swift
//  AppleSearch
//
//  Created by Carson Buckley on 3/21/19.
//  Copyright © 2019 Launch. All rights reserved.
//

import UIKit

class AppleSearchTableViewController: UITableViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var appleSearchBar: UISearchBar!
    @IBOutlet weak var itemTypeSegmentedControl: UISegmentedControl!
    
    
    
    //MARK: - Properties
    //Local Source of Truth <<<<<<<<<<<<<<<<<<<<<
    var appStoreItems: [AppStoreItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appleSearchBar.delegate = self
        AppStoreItemController.fetchItemsOf(type: .song, searchTerm: "The Killers") { (appStoreItems) in
            guard let appStoreItems = appStoreItems else { return }
            self.appStoreItems = appStoreItems
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appStoreItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appItemCell", for: indexPath) as! AppStoreItemTableViewCell
        let appStoreItem = appStoreItems[indexPath.row]
        cell.appStoreItem = appStoreItem
        
        // Configure the cell...
        
        return cell
    }
    
    
    @IBAction func segmentControlToggled(_ sender: UISegmentedControl) {
        
        if itemTypeSegmentedControl.selectedSegmentIndex == 0 {
            AppStoreItem.ItemType.song
            
        } else if itemTypeSegmentedControl.selectedSegmentIndex == 1 {
            AppStoreItem.ItemType.app
        }
    }
}

extension AppleSearchTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else { return }
        let itemType = itemTypeSegmentedControl.selectedSegmentIndex == 0 ? AppStoreItem.ItemType.song : AppStoreItem.ItemType.app
        AppStoreItemController.fetchItemsOf(type: itemType, searchTerm: searchText) { (items) in
            DispatchQueue.main.async {
                guard let items = items else { return }
                self.appStoreItems = items
                self.tableView.reloadData()
            }
        }
    }
}
