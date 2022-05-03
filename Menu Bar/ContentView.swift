//
//  ContentView.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/01/18.
//

import SwiftUI

struct ContentView: View {
    var items: [MenuItemManifist] = Array(repeating: 0, count: 10).map{_ in MenuItemManifist(name: "Name", author: "Author", desc: "Description", id: UUID())}
    
    var body: some View {
        VStack {
            Text("Menu Bar")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding()
            Text("Enabled Items")
                .font(.body)
            List(items) {
                MenuItemView(manifist: $0)
            }
            .listStyle(.plain)
            .padding()
        }
        .frame(idealWidth: 800, maxWidth: .infinity, idealHeight: 600, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
