//
//  HistoryView.swift
//  CovidSimpleApp
//
//  Created by Furkan on 16.05.2020.
//  Copyright © 2020 Furkan İbili. All rights reserved.
//

import UIKit
import CoreData

class HistoryView: UIViewController {


    @IBOutlet var tableView: UITableView!
    @IBOutlet var backButton: UIButton!
    
    var historyData:[HistoryModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        giveDelegateToTableView()
        getData()
        
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /**
    Get history world statistic data from CoreData (local database).
    - Parse Data to History Model to user on tableView.
     
     */
    func getData(){
            guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext =
              appDelegate.persistentContainer.viewContext
            
            //2
            let fetchRequest =
              NSFetchRequest<NSManagedObject>(entityName: "WorldStatistic")
            
            //3
            do {
              let data = try managedContext.fetch(fetchRequest)
                
                //Parse data to model.
                for entry in data {
                    let date =  entry.value(forKey: "date") as! String
                    let cases = entry.value(forKey: "cases") as! Int
                    let death = entry.value(forKey: "death") as! Int
                    let recovered = entry.value(forKey: "recovered") as! Int
                                    
                    historyData.append(HistoryModel.init(date: date, cases: cases, death: death, recovered: recovered))
                }
            } catch let error as NSError {
              print("Could not save. \(error), \(error.userInfo)")
            }
         tableView.reloadData()
        }
    
    
    
}

/**
 - Show history datas which is fetched from Core Data on table view.
 */
extension HistoryView: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if historyData.count == 0 {
            return 10
        } else {
            return historyData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //If history data count is zero return empty cell to tableview
        if historyData.count == 0 {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "country") as! TableCell
        
        cell.case.text = "\(historyData[indexPath.row].cases)"
        cell.death.text = "\(historyData[indexPath.row].death)"
        
        cell.recovered.text = "\(historyData[indexPath.row].recovered)"
        cell.country.text = historyData[indexPath.row].date
        
        return cell
    }
    
    func giveDelegateToTableView() {
        tableView.register(UINib.init(nibName: "TableCell", bundle: nil), forCellReuseIdentifier:  "country")
        tableView.delegate = self
        tableView.dataSource = self
    }
}
