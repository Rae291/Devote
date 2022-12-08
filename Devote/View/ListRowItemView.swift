//
//  ListRowItemView.swift
//  Devote
//
//  Created by APPLE on 07/12/22.
//

import SwiftUI

struct ListRowItemView: View {
    
    //MARK: - Property
    @Environment (\.managedObjectContext) var viewContext
    @ObservedObject var item: Item
    
    //MARK: - Body
    var body: some View {
        Toggle(isOn: $item.completion) {
            Text(item.task ?? "")
                .font(.system(.title, design: .rounded, weight: .heavy))
                .foregroundColor(item.completion ? Color.pink : Color.primary)
                .padding(.vertical, 12)
                .animation(.default, value: item.task)
        }
        .toggleStyle(CheckBoxStyle())
        .onReceive(item.objectWillChange) { _ in
            if self.viewContext.hasChanges {
                try? self.viewContext.save()
            }
        }
    }
}
