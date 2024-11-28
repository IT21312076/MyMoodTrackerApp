import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MoodEntry.date, ascending: false)],
        animation: .default
    ) private var moodEntries: FetchedResults<MoodEntry>
    
    @State private var showingAddEntry = false
    @State private var selectedEntry: MoodEntry? // For editing
    @State private var navigateToMainPage = false // State to manage navigation to Main Page

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(moodEntries) { entry in
                        HStack {
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
                            Spacer()
                            // Delete Button
                            Button(action: {
                                deleteEntry(entry)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle()) // Ensures button is clickable in a List
                        }
                        .padding(.vertical, 5)
                        .onTapGesture {
                            selectedEntry = entry
                            showingAddEntry = true
                        }
                    }
                }
                Button("Add Mood") {
                    selectedEntry = nil
                    showingAddEntry = true
                }
                .padding()
                
                // Button to trigger navigation to the Main Page
                Button("Go to Main Page") {
                    navigateToMainPage = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationTitle("My Mood Diary")
            .sheet(isPresented: $showingAddEntry) {
                AddEditMoodView(entryToEdit: selectedEntry)
            }
            
            // Use NavigationLink to navigate when the flag is set
            .background(
                NavigationLink(destination: MainPageView(showMainPage: .constant(true)), isActive: $navigateToMainPage) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }
    
    private func deleteEntry(_ entry: MoodEntry) {
        viewContext.delete(entry)
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
