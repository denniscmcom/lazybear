//
//  KeyStatsView.swift
//  LazyBear
//
//  Created by Dennis Concepción Martín on 19/3/21.
//

import SwiftUI

struct KeyStatsView: View {
    var symbol: String
    @State private var keyStats = KeyStatsModel()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                let keys = Array(mirrorStructure().keys)
                let values = Array(mirrorStructure().values)
                ForEach(keys.indices, id: \.self) { index in
                    KeyStatComponent(text: keys[index], data: values[index])
                }
            }
            .padding()
        }
        .onAppear {
            let url = getUrl(endpoint: .keyStats, symbol: symbol)
            request(url: url, model: KeyStatsModel.self) { result in
                self.keyStats = result
            }
        }
    }
    
    // Get an array with all the stats from the struct
    func mirrorStructure() -> ([String: Any]) {
        let mirrorKeyStats = Mirror(reflecting: keyStats)
        var statsDict = [String: Any]()

        for stat in mirrorKeyStats.children {
            if let numValue = stat.value as? Double {
                statsDict[stat.label!] = numValue
            } else if let stringValue = stat.value as? String {
                statsDict[stat.label!] = stringValue
            }
        }
        
        return statsDict
    }
}

struct KeyStatsView_Previews: PreviewProvider {
    static var previews: some View {
        KeyStatsView(symbol: "aapl")
    }
}
