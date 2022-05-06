//
//  MenuItemModel.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/05/06.
//

import Foundation

class MenuItemModel: ObservableObject {
    @Published var items: [MenuItemManifist]
    
    init() {
        let items = Array(repeating: 0, count: 10).map{_ in MenuItemManifist(name: "Name", author: "Author", desc: "Description", id: UUID())}
        self.items = items
        for idx in 0..<5 {
            self.items[idx].enabled = true
        }
    }
}
