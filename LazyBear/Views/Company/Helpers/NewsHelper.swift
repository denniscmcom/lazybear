//
//  NewsHelper.swift
//  LazyBear
//
//  Created by Dennis Concepción Martín on 21/6/21.
//

import SwiftUI

struct NewsHelper: View {
    var latestNews: [LatestNewsModel]
    
    @State private var showList = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Latest news")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
                Button("See all", action: { showList = true } )
            }
            .padding(.bottom)
            
            ForEach(latestNews.prefix(4), id: \.self) { new in
                if !new.headline.isEmpty {
                    NewsRow(new: new)
                    Divider()
                        .padding(.leading, 80)
                    
                }
            }
        }
        .padding()
        .background(
            CustomRectangleBox()
        )
        .sheet(isPresented: $showList) {
            NewsList(latestNews: latestNews)
        }
    }
}

struct NewsHelper_Previews: PreviewProvider {
    static var previews: some View {
        NewsHelper(
            latestNews: [
                LatestNewsModel(
                    datetime: 1621037430000,
                    headline: "Chaos Monkeys' author calls Apple's statement on his departure defamatory",
                    image: "https://cloud.iexapis.com/v1/news/image/99abeb99-6d9e-47c8-ae7b-53404eacccec",
                    source: "Investing.com",
                    summary: "https://www.investing.com/news/stock-market-news",
                    url: "https://cloud.iexapis.com/v1/news/article/99abeb99-6d9e-47c8-ae7b-53404eacccec")
            ]
        )
    }
}