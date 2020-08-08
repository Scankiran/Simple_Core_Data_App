//
//  HistoryModel.swift
//  CovidSimpleApp
//
//  Created by Furkan on 16.05.2020.
//  Copyright © 2020 Furkan İbili. All rights reserved.
//

import Foundation

/**
 Model of History data.
 Used on history page for parse core data.
 */
struct HistoryModel {
    var date:String
    var cases:Int
    var death:Int
    var recovered:Int
}
