import SwiftUI

struct ContentView: View {
    
    @State var results: ResultJson?
    
    var body: some View {
        
        NavigationView {
            if let arts = results?.articles {
                List(arts, id: \.title) { item in
                    if let tit = item.title {
                        Text(tit)
                            .onTapGesture {
                                if let url_string = item.url {
                                    if let url = URL(string: url_string) {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            }
                    }
                }
                .navigationTitle("ニュースリスト")
            }
        }
        .onAppear {
            LoadNews()
        }
    }
    
    func LoadNews() {
        let newsUrl = "https://newsapi.org/v2/everything?q=google&from=2023-06-20&sortBy=publishedAt&apiKey=ca414e7382b44ca8af57ca4208c9651d&language=jp"
        
        guard let url = URL(string: newsUrl) else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            
            guard let response = try? decoder.decode(ResultJson.self, from: data) else { return }
            
            DispatchQueue.main.async {
                results = response
            }
        }
        
        task.resume()
    }
}

struct Article: Codable {
    let title: String?
    let url: String?
}

struct ResultJson: Codable {
    let articles: [Article]?
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
