//
//  HomeView.swift
//  LazyBear
//
//  Created by Dennis Concepción Martín on 28/3/21.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var home = Home()
    @State private var showTradingDates = false
    
    // Set recurrent price request
    @State private var timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
        }()

        let dueDate = Date()
    
    var body: some View {
        if home.showView {
            NavigationView {
                List {
                    if let sectorPerformance = home.data.sectorPerformance {
                        SectorRow(sectorPerformance: sectorPerformance)
                            .listRowInsets(EdgeInsets())
                    }
                    
                    if let lists = home.data.lists {
                        ForEach(Array(lists.keys.sorted()), id: \.self) { listName in
                            if let intradayPrices = home.data.intradayPrices {
                                StockRectangleRow(listName: listName, list: lists[listName]!, nestedIntradayPrices: intradayPrices)
                            } else {
                                StockRectangleRow(listName: listName, list: lists[listName]!, nestedIntradayPrices: nil)
                            }
                        }
                        .listRowInsets(EdgeInsets())
                    }
                }
                .onReceive(timer) { _ in home.request("https://api.lazybear.app/home/streaming") }
                .onDisappear { self.timer.upstream.connect().cancel() }  // Stop timer
                .navigationTitle("\(dueDate, formatter: Self.taskDateFormat)")
                .navigationBarTitleDisplayMode(.inline)
                .navigationViewStyle(StackNavigationViewStyle())
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showTradingDates = true }) {
                            Image(systemName: "calendar.badge.clock")
                        }
                    }
                }
            }
            .sheet(isPresented: $showTradingDates) {
                if let dates = home.data.tradingDates {
                    TradingDates(dates: dates)
                }
            }
        } else {
            ProgressView()
                .onAppear {
                    home.request("https://api.lazybear.app/home/init")
                    // Restart timer
                    self.timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
                }
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}