//
//  ContentView.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/01/18.
//

import SwiftUI

struct ContentView: View {
    @StateObject var menuItemModel = MenuItemModel()
    
    var body: some View {
        VStack {
            Text("Menu Bar")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding()
            Text("Enabled Items")
                .font(.body)
            List(menuItemModel.items.indices, id: \.self) { idx in
                HStack {
                    Toggle("", isOn: $menuItemModel.items[idx].enabled)
                    MenuItemView(manifist: menuItemModel.items[idx])
                }
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
