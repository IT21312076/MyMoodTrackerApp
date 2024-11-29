import SwiftUI

struct AddEditMoodView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var mood: String = ""
    @State private var notes: String = ""
    @State private var date: Date = Date()
    
    var entryToEdit: MoodEntry?

    // List of emojis to choose from
    private let emojiList = ["😊", "😢", "😎", "🥰", "😠", "😐", "🤔", "😜", "😴"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Mood")) {
                    HStack {
                        // Emoji Picker
                        Text("Select Mood Emoji:")
                        Picker("Mood Emoji", selection: $mood) {
                            ForEach(emojiList, id: \.self) { emoji in
                                Text(emoji).tag(emoji)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 150, height: 100)
                    }
                }
                
                Section(header: Text("Notes")) {
                    TextField("Write your notes", text: $notes)
                }
                
                Section(header: Text("Date")) {
                    DatePicker("Select Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle(entryToEdit == nil ? "Add Mood" : "Edit Mood")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveMood()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear {
                if let entry = entryToEdit {
                    mood = entry.mood ?? ""
                    notes = entry.notes ?? ""
                    date = entry.date ?? Date()
                }
            }
        }
    }
    
    private func saveMood() {
        let entry = entryToEdit ?? MoodEntry(context: viewContext)
        entry.mood = mood
        entry.notes = notes
        entry.date = date
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Failed to save: \(error.localizedDescription)")
        }
    }
}
