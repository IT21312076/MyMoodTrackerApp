import SwiftUI

struct AddEditMoodView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var mood: String = ""
    @State private var notes: String = ""
    @State private var date: Date = Date()
    
    var entryToEdit: MoodEntry?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Mood")) {
                    TextField("Enter your mood", text: $mood)
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
