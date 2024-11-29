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
    @State private var showLogoutAlert = false // For logout confirmation
    @State private var navigateToMainPage = false // For navigating to MainPageView after logout

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
            }
            .navigationTitle("My Mood Diary")
            .navigationBarItems(leading: logoutButton) // Add logout button to the top left corner
            .sheet(isPresented: $showingAddEntry) {
                AddEditMoodView(entryToEdit: selectedEntry)
            }
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Logout"),
                    message: Text("Are you sure you want to logout?"),
                    primaryButton: .destructive(Text("Logout")) {
                        // Set the flag to navigate to the MainPageView
                        navigateToMainPage = true
                    },
                    secondaryButton: .cancel()
                )
            }

            // NavigationLink that triggers navigation to MainPageView when logged out
            .background(
                NavigationLink(
                    destination: MainPageView(showMainPage: $navigateToMainPage),
                    isActive: $navigateToMainPage
                ) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }

    private var logoutButton: some View {
        Button(action: {
            showLogoutAlert = true // Show confirmation alert on logout
        }) {
            HStack {
                Image(systemName: "arrow.backward.circle.fill") // Add a logout icon
                Text("Logout")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.blue)
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
