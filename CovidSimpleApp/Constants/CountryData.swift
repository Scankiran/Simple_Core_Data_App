//
//  CountryData.swift
//  CovidSimpleApp
//
//  Created by Furkan on 16.05.2020.
//  Copyright © 2020 Furkan İbili. All rights reserved.
//


/**
 On this class created for save country data on memory to use another page.
 Use with singleton structure.
 */
import Foundation

class CountryData {
    
    //This array created for show all country statistics on tableView where world view.
    var data:[CountryDataModel] = []
    
    //Singleton Structure
    static let shared = CountryData()
}
