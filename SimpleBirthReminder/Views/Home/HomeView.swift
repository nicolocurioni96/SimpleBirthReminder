//
//  HomeView.swift
//  SimpleBirthReminder
//
//  Created by Nicolò Curioni on 04/03/24.
//

import SwiftUI
import SwiftData
import Combine

struct HomeView: View {
    // MARK: - Properties
    @Environment(\.modelContext) private var modelContext
    
    @Query var birthdayItems: [Birthday]
    
    @State private var showAddNewBirthday = false
    
    // MARK: - View Life-cycle
    var body: some View {
        NavigationStack {
            List {
                ForEach(birthdayItems) { birthdayItem in
                    NavigationLink {
                        DetailView(birthday: birthdayItem)
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(birthdayItem.name)
                                    .foregroundStyle(Color.primary)
                                    .font(.title2)
                                
                                Text(DateFormatter.localizedString(from: birthdayItem.dateOfBirth, dateStyle: .medium, timeStyle: .none))
                                    .foregroundStyle(Color.primary)
                                    .font(.headline)
                            }
                            
                        }
                    }

                }
                .onDelete(perform: deleteBirthday)
            }
            .navigationTitle("Birthdays")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        self.showAddNewBirthday.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .fontWeight(.medium)
                    }
                }
            }
            .sheet(isPresented: self.$showAddNewBirthday) {
                AddBirthdayView()
            }
        }
    }
    
    // MARK: - Private Methods
    func deleteBirthday(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(birthdayItems[index])
        }
    }
}
