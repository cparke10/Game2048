//
//  LeaderboardViewModel.swift
//  Game2048
//
//  Created by Charlie Parker on 1/23/24.
//

import SwiftUI

struct LeaderboardEntryViewModel: Identifiable, Hashable {
    let username: String
    let score: Int
    let date: String // TODO: formatting
    let rank: Int
    let id = UUID()
}

class LeaderboardViewModel: ObservableObject {
    let type: LeaderboardType
    private let service = LeaderboardService()
    @Published var state: State = .loading
    
    enum State {
        case loading, loaded([LeaderboardEntryViewModel]), error
        
        init(result: Result<[LeaderboardEntry], Error>) {
            switch result {
            case .success(let data):
                // sort and rank the entry data and map to the entry view model
                let entryViewModels = Dictionary(grouping: data, by: { $0.score })
                    .sorted(by: { $0.key > $1.key })
                    .enumerated()
                    .flatMap { (index, entryGroup) in
                        entryGroup.value.map { entry in
                            LeaderboardEntryViewModel(username: entry.username, score: entry.score, date: entry.date, rank: index + 1)
                        }
                    }
                self = .loaded(entryViewModels)
            case .failure: self = .error
            }
        }
    }
    
    init(type: LeaderboardType) { self.type = type }
    
    /// Requests the `LeaderboardService` using the instance's `LeaderboardType` and updates the view state using the response.
    /// - Parameter type: The `LeaderboardType` to request.
    func requestLeaderboard() {
        service.request(with: type) { result in
            DispatchQueue.main.async { [weak self] in
                self?.state = State(result: result)
            }
        }
    }
}
