//
//  RepositoryView.swift
//  jam-ca (iOS)
//
//  Created by Lukas Andrlik on 14.03.2022.
//

import SwiftUI
import Combine
import ComposableArchitecture

struct RepositoryListView: View {
    let store: Store<RepositoryState, RepositoryAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            ScrollView {
                LazyVStack {
                    ForEach(viewStore.repositories) { repository in
                        RepositoryView(store: store, repository: repository)
                            .padding([.leading, .trailing, .bottom])
                    }
                }
                .background(Color("indigo")
                .edgesIgnoringSafeArea([.top, .leading, .trailing]))
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
}

struct FavoritesListView: View {
    let store: Store<RepositoryState, RepositoryAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            ScrollView {
                LazyVStack {
                    ForEach(viewStore.favoriteRepositories) { repository in
                        RepositoryView(store: store, repository: repository)
                            .padding([.leading, .trailing, .bottom])
                    }
                }
                .background(Color("indigo")
                .edgesIgnoringSafeArea([.top, .leading, .trailing]))
            }
        }
    }
}

struct RepositoryView: View {
    let store: Store<RepositoryState, RepositoryAction>
    let repository: RepositoryModel

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                HStack {
                    Text(repository.name)
                        .font(.title)
                    Spacer()
                    Button(
                        action: { viewStore.send(.favoriteButtonTapped(repository)) },
                        label: {
                            if viewStore.favoriteRepositories.contains(repository) {
                                Image(systemName: "heart.fill")
                            } else {
                                Image(systemName: "heart")
                            }
                        })
                }
                Text(repository.description ?? "No description available")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 4)
                    .padding(.bottom, 4)
                HStack {
                    HStack {
                        Image(systemName: "star.fill")
                        Text("\(repository.stars)")
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "arrow.triangle.branch")
                        Text("\(repository.forks)")
                    }
                    Spacer()
                    if repository.language != nil {
                        Text("\(repository.language ?? "---")")
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .padding()
            .foregroundColor(Color("magnolia"))
            .background(Color("ruby"))
            .cornerRadius(8.0)
        }
    }
}

struct RepositoryListView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryListView(
            store: Store(
                initialState: RepositoryState(),
                reducer: repositoryReducer,
                environment: .dev(
                    environment: RepositoryEnvironment(
                        repositoryRequest: dummyRepositoryEffect))))
    }
}
