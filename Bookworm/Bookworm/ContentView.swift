//
//  ContentView.swift
//  Bookworm
//
//  Created by Andreas Zwikirsch on 27.11.21.
//

import SwiftUI

// Challenge 2
struct HighlightColor: ViewModifier {
    var colorInt: Int
    var highlightColor: Color {
        if colorInt == 1 {
            return Color.red
        }
        
        if colorInt == 4 || colorInt == 5 {
            return Color.green
        }
        
        return Color.yellow
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(highlightColor)
    }
}


struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.title),
        SortDescriptor(\.author)
    ]) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.2, green: 0.2, blue: 0.2), .white]), startPoint: .leading, endPoint: .trailing)
            
            
            NavigationView {
                List {
                    ForEach(books) { book in
                        NavigationLink {
                            DetailsView(book: book)
                        } label: {
                            HStack {
                                EmojiRatingView(rating: book.rating)
                                    .font(.largeTitle)
                                
                                VStack(alignment: .leading) {
                                    Text(book.title ?? "Unknowen Title")
                                        .font(.headline)
                                    
                                    HStack {
                                        // Challenge 2
                                        Image(systemName: "circle.fill")
                                            .modifier(HighlightColor(colorInt: Int(book.rating)))
                                        
                                        Text(book.author ?? "Unknowen Author")
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteBooks)
                    .listRowBackground(Color(red: 0.2, green: 0.2, blue: 0.2))
                }
                .navigationTitle("Bookworm")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddScreen.toggle()
                        } label: {
                            Label("Add Book", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingAddScreen) {
                    AddBookView()
                }
            }
        }
        
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
