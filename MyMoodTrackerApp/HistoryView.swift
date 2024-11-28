import SwiftUI
import CoreData

struct HistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MoodEntry.date, ascending: false)],
        animation: .default
    ) private var moodEntries: FetchedResults<MoodEntry>

    var body: some View {
        NavigationView {
            List {
                ForEach(moodEntries) { entry in
                    VStack(alignment: .leading) {
                        Text(entry.mood ?? "Unknown Mood")
                            .font(.headline)
                        if let date = entry.date {
                            Text("\(date, style: .date)")
                                .font(.subheadline)
                        }
                        if let notes = entry.notes {
                            Text(notes)
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: deleteEntries) // Add delete action here
            }
            .navigationTitle("Mood History")
        }
    }

    // Add delete function
    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            let entry = moodEntries[index]
            viewContext.delete(entry) // Delete from context
        }
        saveContext() // Save changes
    }
    
    // Save context function
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
