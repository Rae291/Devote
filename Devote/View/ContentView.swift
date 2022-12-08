//
//  ContentView.swift
//  Devote
//
//  Created by APPLE on 07/12/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    //MARK: - Property
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State var task: String = ""
    @State private var showNewTaskItem: Bool = false
    
    //Fetching Data
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    //MARK: - Functions

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    //MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                
                //MARK: - Main View
                VStack {
                    
                    //MARK: - Header
                    HStack(spacing: 10) {
                        
                        //Title
                        Text("Devote")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                        
                        Spacer()
                        
                        //Edit Button
                        EditButton()
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 10)
                            .frame(minWidth: 70, minHeight: 24)
                            .background(Capsule().stroke(Color.white, lineWidth: 2))
                        
                        //Appearance Button
                        Button(action: {
                            isDarkMode.toggle()
                            playSound(sound: "sound-tap", type: "mp3")
                        }, label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        })
                        
                    } // eo HStack
                    .padding()
                    .foregroundColor(.white)
                    
                    Spacer(minLength: 80)
                    
                    //MARK: - New Task Button
                     Button(action: {
                         showNewTaskItem = true
                         playSound(sound: "sound-ding", type: "mp3")
                     }, label: {
                         Image(systemName: "plus.circle")
                             .font(.system(size: 30, weight: .semibold, design: .rounded))
                         
                         Text("New Task")
                             .font(.system(size: 24, weight: .bold, design: .rounded))
                     })
                     .foregroundColor(.white)
                     .padding(.horizontal, 20)
                     .padding(.vertical, 15)
                     .background(LinearGradient(colors: [Color.pink, Color.blue], startPoint: .leading, endPoint: .trailing))
                     .clipShape(Capsule())
                     .shadow(color: .black.opacity(0.5), radius: 8, y: 4)
                    
                    //MARK: - Tasks
                    
                     List {
                        ForEach(items) { item in
                            ListRowItemView(item: item)
                        }
                        .onDelete(perform: deleteItems)
                    }// eo List
                     .scrollContentBackground(.hidden)
                     .listStyle(InsetGroupedListStyle())
                     .shadow(color: .black.opacity(0.5), radius: 12)
                     .padding(.vertical, 0)
                     .frame(maxWidth: 635)
                    
                } // eo VStack
                .blur(radius: showNewTaskItem ? 8 : 0, opaque: false)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.5), value: task)
                
                //MARK: - New Task Item
                if showNewTaskItem {
                    BlankView(
                        bgColor: isDarkMode ? .black : .gray,
                        bgOpacity: isDarkMode ? 0.3 : 0.5
                    )
                        .onTapGesture {
                            withAnimation {
                                showNewTaskItem = false
                            }
                        }
                    
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
                
            } // eo ZStack
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .navigationTitle("Daily Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar(.hidden)
            .background(
                BackgroundImageView()
                    .blur(radius: showNewTaskItem ? 8 : 0, opaque: false)
            )
            .background(backgroundGradient.ignoresSafeArea(.all))
        } // eo NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
