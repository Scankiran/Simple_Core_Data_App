//
//  CountryDataModel.swift
//  CovidSimpleApp
//
//  Created by Furkan on 16.05.2020.
//  Copyright © 2020 Furkan İbili. All rights reserved.
//

import Foundation

/**
 Struct for country information.
 Used on parse API response data.
 */
struct CountryDataModel {
    var country:String?
    var cases:Int?
    var deaths:Int?
    var recovered:Int?
    var todayCases:Int?
    var todayDeath:Int?
}
