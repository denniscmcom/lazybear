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
    @State private var timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()  /// Set recurrent price request
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
        }()

        let dueDate = Date()
    
    var body: some View {
        if home.showView {
            NavigationView {
                ScrollView(showsIndicators: false) {
                    VStack {
                        if let sectorPerformance = home.data.sectorPerformance {
                            SectorRow(sectorPerformance: sectorPerformance)
                                .listRowInsets(EdgeInsets())
                        }
                        
                        if let lists = home.data.lists {
                            let listNames = Array(lists.keys.sorted())
                            ForEach(listNames, id: \.self) { listName in
                                StockRow(listName: listName, companies: lists[listName]!)
                                    .listRowInsets(EdgeInsets())
                            }
                        }
                        
                        if let latestCurrencies = home.data.latestCurrencies {
                            CurrencyRow(latestCurrencies: latestCurrencies)
                                .listRowInsets(EdgeInsets())
                        }
                    }
                    .onAppear { self.timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect() }  /// Restart timer
                    .onReceive(timer) { _ in home.request("https://api.lazybear.app/home/type=streaming", .streaming) }  /// Receive timer notification
                    .onDisappear { self.timer.upstream.connect().cancel() }  // Stop timer
                    .navigationTitle("\(dueDate, formatter: Self.taskDateFormat)")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: { showTradingDates = true }) {
                                Image(systemName: "clock")
                            }
                        }
                    }
                }
                .background(Color("customBackground").edgesIgnoringSafeArea(.all))
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .sheet(isPresented: $showTradingDates) {
                if let dates = home.data.tradingDates {
                    TradingDatesSheet(dates: dates)
                }
            }
        } else {
            ProgressView()
                .onAppear { home.request("https://api.lazybear.app/home/type=initial", .initial) }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
