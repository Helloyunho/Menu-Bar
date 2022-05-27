//
//  ZipDropDelegate.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/05/27.
//

import Foundation
import SwiftUI

struct ZipDropDelegate: DropDelegate {
    var model: MenuItemModel
    
    func validateDrop(info: DropInfo) -> Bool {
        return info.hasItemsConforming(to: [.zip, .fileURL])
    }
    
    func performDrop(info: DropInfo) -> Bool {
        Task {
            var converted = [URL]()
            for item in info.itemProviders(for: [.zip, .fileURL]) {
                let itemConverted: Data = try await item.loadItem(forTypeIdentifier: "public.file-url") as! Data
                if let itemURLString = String(data: itemConverted, encoding: .utf8), let itemURL = URL(string: itemURLString) {
                    converted.append(itemURL)
                }
            }
            model.errorWrapper {
                try model.loadItems(items: converted)
            }
        }
        return true
    }
}
