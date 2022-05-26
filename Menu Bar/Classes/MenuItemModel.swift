//
//  MenuItemModel.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/05/06.
//

import Foundation
import Zip

class MenuItemModel: ObservableObject {
    @Published var items: [MenuItemManifist]
    private let defaultItemPath = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("plugins", isDirectory: true)
    
    init() {
        let items = Array(repeating: 0, count: 10).map { _ in MenuItemManifist(name: "Name", author: "Author", desc: "Description", id: UUID()) }
        self.items = items
        for idx in 0 ..< 5 {
            self.items[idx].enabled = true
        }
    }
    
    func loadItems() async throws {
        try FileManager.default.createDirectory(at: defaultItemPath, withIntermediateDirectories: true)
        let items = try FileManager.default.contentsOfDirectory(at: defaultItemPath, includingPropertiesForKeys: nil)
        for item in items {
            
        }
    }
    
    func loadItem(url: URL) async throws {
        
    }
    
    func loadItems(items: [URL]) async throws {
//        for item in items {
//            let itemConverted: URL = try await item.loadItem(forTypeIdentifier: "public.zip-archive") as! NSURL as URL
//            try Zip.unzipFile(itemConverted)
//        }
    }
}
