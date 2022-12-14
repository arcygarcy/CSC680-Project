//
//  ContentView.swift
//  HeapOverload
//
//  Created by Adam Garcia on 12/9/22.
//

import SwiftUI

struct ContentView: View {
    @State var post = ["Title", "Content", "Meme,MemeMan"]
    
    var body: some View {
        TabView() {
            HomeView(post: $post) .tabItem({
                Image(systemName: "house")
                Text("Home")
            })
            ViewPost(post: $post).tabItem ({
                Image(systemName: "doc")
                Text("View Post")
            })
            AddPost().tabItem({
                Image(systemName: "doc.badge.plus")
                Text("Add Post")
            })
            LoginView().tabItem({
                Image(systemName: "person.fill")
                Text("Account")
            })
        }.accentColor(.pink)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
