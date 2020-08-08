//
//  InformationView.swift
//  CovidSimpleApp
//
//  Created by Furkan on 16.05.2020.
//  Copyright © 2020 Furkan İbili. All rights reserved.
//

import UIKit

class InformationView: UIViewController {
    
    //Outlets
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        giveDelegate()
        // Do any additional setup after loading the view.
    }

    //Save which row selected on tableView.
    var selectedRow = 0

}

extension InformationView: UITableViewDelegate,UITableViewDataSource {
    //Create row with static Information Header Count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Informations.shared.dataHeader.count
    }
    
    //Show headers on cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "information") as! InformationCell
        
        cell.contentView.layer.cornerRadius = 20
        
        cell.headerLabel.text = Informations.shared.dataHeader[indexPath.row]
        cell.headerLabel.numberOfLines = 2
        
        return cell
    }
    
    //Go to detail page with selected row id.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        self.performSegue(withIdentifier: "showInformation", sender: self)
    }
    
    
    func giveDelegate() {
        self.tableView.register(UINib.init(nibName: "InformationCell", bundle: nil), forCellReuseIdentifier: "information")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! InformationDetailsView
        vc.selectedRow = self.selectedRow
    }
}

