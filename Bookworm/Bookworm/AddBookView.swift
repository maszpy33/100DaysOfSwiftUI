//
//  AddBookView.swift
//  Bookworm
//
//  Created by Andreas Zwikirsch on 29.11.21.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    // Challenge 1
    var isValid: Bool {
        if title == "" || author == "" || genre == "" {
            return false
        }
        
        if title.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        
        if author.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        
        if genre.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        
        return true
    }
    
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text : $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }
                
                Section {
                    Button("Save") {
                        let newBook = Book(context: moc)
                        newBook.id = UUID()
                        newBook.title = title
                        newBook.author = author
                        newBook.rating = Int16(rating)
                        newBook.genre = genre
                        newBook.review = review
                        
                        try? moc.save()
                        dismiss()
                    }
                }
                .disabled(isValid == false)
            }
            .navigationTitle("Add Book")
        }
    }
    
//    func setHighlightColor() -> String {
//
//        if self.rating == 1 {
//            return "red"
//        }
//
//        if self.rating == 4 || self.rating == 5 {
//            return "green"
//        }
//
//        return "gray"
//    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
