//
//  Item.swift
//  ToDo
//
//  Created by Dhiva Krishna on 1/7/21.
//

import Foundation

/*
 Encodable makes sure that we adhere to protocols that make
 our data compatible with external representations such as
 JSON or PLists in this case
*/
class Item: Encodable {
    var title: String = ""
    var itemDone: Bool = false
    
}

