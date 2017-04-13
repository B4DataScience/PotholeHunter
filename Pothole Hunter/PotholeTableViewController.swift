//
//  PotholeTableViewController.swift
//  Pothole Hunter
//
//  Created by Brijesh Patel on 2017-03-15.
//  Copyright © 2017 Brijesh Patel. All rights reserved.
//

import UIKit
import Firebase

class PotholeTableViewController: UITableViewController {
    
    var index:Int?
    var refresher:UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(PotholeTableViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refresher)
        self.tableView.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PotholeData.potholes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PotholeTabelViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PotholeTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PotholeTableViewCell.")
        }
        let pothole = PotholeData.potholes[indexPath.row]
        print("table cell creation")
        print(pothole)
        cell.addressLabel.text = pothole.address
        cell.dateLabel.text = "Captured On:" + pothole.FirstCapturedOn!
        cell.severityLabel.text = "Severity: \(pothole.severity!) out of 10"
        if(pothole.severity! <= 4){
            cell.colorView.backgroundColor = .green
            print("color yellow")
        }
        else if(pothole.severity! < 8){
            cell.colorView.backgroundColor = .purple
            print("color blue")
        }
        else{
            cell.colorView.backgroundColor = .red
            print("color red")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        performSegue(withIdentifier: "tableToDetail", sender: PotholeData.potholes[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableToDetail"{
            if let destinationVC = segue.destination as? ShowDetailViewController{

                let pothole = PotholeData.potholes[self.index!]
                destinationVC.firstCapturedOn = pothole.FirstCapturedOn!
                destinationVC.lastCapturedOn = pothole.LastCapturedOn!
                destinationVC.address = pothole.address!
                destinationVC.severity = String(pothole.severity!)
                destinationVC.additionalInfo = pothole.additionalInfo!
                destinationVC.pCount = pothole.pCount!
                destinationVC.indexCalled = self.index!
        
            }
        }
        
    }
    
    func refresh(){
        self.tableView.reloadData()
        refresher.endRefreshing()
    }
    
}
