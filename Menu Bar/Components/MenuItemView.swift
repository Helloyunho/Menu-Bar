//
//  MenuItemView.swift
//  Menu Bar
//
//  Created by Helloyunho on 2022/05/03.
//

import SwiftUI

struct MenuItemView: View {
    var manifist: MenuItemManifist
    
    var body: some View {
        HStack {
            if let appIcon = manifist.appIcon {
                Image(nsImage: appIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
            } else {
                Image(systemName: "app.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(manifist.name)
                    Text(manifist.author)
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                }
                Text(manifist.desc)
                    .font(.caption)
                    .foregroundColor(Color.gray)
            }
        }
        .padding()
    }
}

struct MenuItemView_Previews: PreviewProvider {
    static var testManifist = MenuItemManifist(name: "Name", author: "Author", desc: "Description", id: UUID())
    
    static var previews: some View {
        MenuItemView(manifist: MenuItemView_Previews.testManifist)
    }
}