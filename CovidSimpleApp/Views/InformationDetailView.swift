//
//  InformationDetailView.swift
//  CovidSimpleApp
//
//  Created by Furkan on 16.05.2020.
//  Copyright © 2020 Furkan İbili. All rights reserved.
//

import UIKit

class InformationDetailsView: UIViewController {
    
    //Outlets
    @IBOutlet var backButton: UIButton!
    @IBOutlet var textSpace: UITextView!
    
    let contentData = Informations.shared.dataContent
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Show selected headers detail.
        textSpace.text = contentData[selectedRow]
        // Do any additional setup after loading the view.
        self.backButton.layer.cornerRadius = self.backButton.bounds.height / 2
    }
    

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
