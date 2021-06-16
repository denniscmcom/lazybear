//
//  TradingDate.swift
//  LazyBear
//
//  Created by Dennis Concepción Martín on 30/3/21.
//

import SwiftUI


struct TradingDates: View {
    var dates: [String]
    @Environment(\.presentationMode) private var presentationTradingDates
    
    let columns = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(dates, id: \.self) { date in
                        TradingDatesItem(date: convertStringToDate(date))
                    }
                }
                .padding()
            }
            .navigationTitle("Holiday dates")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationTradingDates.wrappedValue.dismiss() }) {
                        Image(systemName: "multiply")
                            .imageScale(.large)
                    }
                }
            }
        }
    }
}

struct TradingDate_Previews: PreviewProvider {
    static var previews: some View {
        // Format is YYYY-MM-DD
        TradingDates(dates: ["2021-01-01"])
    }
}
