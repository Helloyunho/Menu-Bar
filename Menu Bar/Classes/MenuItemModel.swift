//
//  MenuItemModel.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/05/06.
//

import Foundation
import Zip
import Defaults

class MenuItemModel: ObservableObject {
    @Published var items = [MenuItemManifist]()
    @Published var errorAlert = false
    var errorContent: Error? = nil
    private let defaultItemPath = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Menu Bar", isDirectory: true).appendingPathComponent("plugins", isDirectory: true)
    
    init() {
        self.errorWrapper {
            try self.loadItems()
        }
    }
    
    func loadItems() throws {
        try FileManager.default.createDirectory(at: defaultItemPath, withIntermediateDirectories: true)
        let items = try FileManager.default.contentsOfDirectory(at: defaultItemPath, includingPropertiesForKeys: [.isDirectoryKey])
        for item in items {
            self.errorWrapper {
                if try item.resourceValues(forKeys: [.isDirectoryKey]).isDirectory ?? false {
                    try self.loadItem(url: item)
                }
            }
        }
    }
    
    func loadItem(url: URL) throws {
        guard let id = UUID(uuidString: url.lastPathComponent) else {
            throw MenuBarError.directoryUUID
        }
        
        let manifistPath = url.appendingPathComponent("manifist").appendingPathExtension("json")
        if !FileManager.default.fileExists(atPath: manifistPath.path) {
            throw MenuBarError.manifistFileNotFound
        }
        
        let decoder = JSONDecoder()
        let manifistJSON = try decoder.decode(MenuItemManifistJSON.self, from: Data(contentsOf: manifistPath))
        let enabled = Defaults[.enabledItems].contains(id)
        let manifist = MenuItemManifist(name: manifistJSON.name, author: manifistJSON.author, desc: manifistJSON.desc, id: id, script: manifistJSON.script, enabled: enabled)
        self.items.append(manifist)
    }

    func loadItems(items: [URL]) {
        for item in items {
            let id = UUID()
            let dest = defaultItemPath.appendingPathComponent(id.uuidString, isDirectory: true)
            self.errorWrapper {
                try Zip.unzipFile(item, destination: dest, overwrite: false, password: nil)
                try self.loadItem(url: dest)
            }
        }
    }
    
    func errorWrapper(action: () throws -> Void) {
        do {
            try action()
        } catch {
            self.errorContent = error
            self.errorAlert = true
        }
    }
    
    func getErrorMessage() -> String {
        guard let errorContent = errorContent else {
            return "I don't know... You weren't supposed to see this message..."
        }
        
        switch errorContent {
        case MenuBarError.directoryUUID:
            return "Some directories' name are not valid UUID."
        case MenuBarError.manifistFileNotFound:
            return "Manifist JSON could not be found."
        case is DecodingError:
            return "Failed to parse manifist JSON. \(String(describing: errorContent))"
        default:
            return errorContent.localizedDescription
        }
    }
}
