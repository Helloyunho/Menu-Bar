//
//  MenuItemManifistJSON.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/05/18.
//

import Foundation

struct MenuItemManifistJSON: Codable {
    var name: String
    var icon: URL?
    var author: String
    var desc: String
    var script: String?
}
