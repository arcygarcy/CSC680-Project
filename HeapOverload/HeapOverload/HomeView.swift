//
//  HomeView.swift
//  HeapOverload
//
//  Created by Adam Garcia on 12/10/22.
//

import Foundation
import SwiftUI

struct Post: Hashable {
    var title: String = ""
    var content: String = ""
//    var tags: String = ""
}

struct HomeView: View {
    @Binding var post: Array<String>
    
    @State var search = ""
    @State var posts: Array<Post> = []
    
    @State var resultsCount = "0"
    
    var body: some View {
        VStack {
            HStack{
                TextField("Title Search", text: $search).frame(width: 300).textFieldStyle(.roundedBorder).font(.system(size: 24))
                Button("Search", action: {getPosts()}).buttonStyle(.bordered)
            }
            Text("\(resultsCount) results")
            List(posts, id: \.self) { item in
                Button("\(item.title)", action: {
                    post[0] = item.title
                    post[1] = item.content
                })
            }
        }
    }
    
    func getPosts() {
        let url = URL(string: "http://34.125.134.2:5000/api/post?title=\(search)")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let string = String(data: data, encoding: .utf8)!
                let json = """
                    \(string)
                    """
                let data = json.data(using: .utf8)!
                let dict = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                let tPosts = dict["data"] as! Array<[String:Any]>
                posts.removeAll()
                for i in 0..<tPosts.count {
                    let temp = Post(title: "\(tPosts[i]["title"] as! String)", content: "\(tPosts[i]["content"] as! String)")
                    posts.append(temp)
                }
                resultsCount = String(posts.count)
            }
        }
        task.resume()
    }
}
