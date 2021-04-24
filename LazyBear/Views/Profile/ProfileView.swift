//
//  ProfileView.swift
//  LazyBear
//
//  Created by Dennis Concepción Martín on 4/4/21.
//

import SwiftUI
import CoreData

struct ProfileView: View {
    @ObservedObject var profile = Profile()
    @FetchRequest(entity: WatchlistCompany.entity(), sortDescriptors: [])
    var watchlistCompanies: FetchedResults<WatchlistCompany>

    var body: some View {
        if profile.showView {
            NavigationView {
                List {
                    // Take all the different watchlist created
                    let watchlists = Set(watchlistCompanies.map { $0.watchlist })  // Set -> avoid duplicates names
                    ForEach(Array(watchlists), id: \.self) { watchlist in
                        
                        // Get all the symbols of this watchlist
                        let symbols = watchlistCompanies.filter({ $0.watchlist == watchlist }).map { $0.symbol }
                        
                        if let companies = profile.data.quotes {
                            let filteredCompanies = companies.filter({ symbols.contains($0.key) })
                            StockRow(listName: watchlist,
                                     list: filteredCompanies,
                                     intradayPrices: profile.data.intradayPrices,
                                     addOnDelete: true
                            )
                            .listRowInsets(EdgeInsets())
                        }
                    }
                }
                .navigationTitle("My profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {}) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        } else {
            ProgressView()
                .onAppear { prepareUrl() }
        }
    }
    
    private func prepareUrl() {
        if watchlistCompanies.isEmpty {
            profile.showView = true
        } else {
            let symbols = watchlistCompanies.map { $0.symbol }  // Get symbols in watchlists
            var url = "https://api.lazybear.app/profile/type=init/symbols="

            var counter = 0
            for symbol in symbols {
                counter += 1
                if counter == 1 {
                    url += symbol
                } else {
                    url += ",\(symbol)"
                }
            }
            profile.request(url)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
