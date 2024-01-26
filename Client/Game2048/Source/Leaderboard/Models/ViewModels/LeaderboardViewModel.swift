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
    let date: String
    let rank: Int
    let id = UUID()
    
    init?(username: String, score: Int, date: String, rank: Int) {
        self.username = username
        self.score = score
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: date) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MM/dd/yyyy"
            self.date = outputFormatter.string(from: date)
        } else {
            return nil
        }
        self.rank = rank
    }
}

class LeaderboardViewModel: ObservableObject {
    let type: LeaderboardType
    private let service = LeaderboardService()
    @Published var state: State = .loading
    
    init(type: LeaderboardType) { self.type = type }
    
    enum State {
        case loading, loaded([LeaderboardEntryViewModel]), error
        
        init(result: Result<LeaderboardResponse, Error>) {
            switch result {
            case .success(let response):
                let data = response.data
                // sort and rank the entry data and map to entry view model
                let entryViewModels = Dictionary(grouping: data, by: { $0.score })
                    .sorted(by: { $0.key > $1.key })
                    .enumerated()
                    .flatMap { (index, entryGroup) in
                        entryGroup.value.compactMap { entry in
                            LeaderboardEntryViewModel(username: entry.username, score: entry.score, date: entry.date, rank: index + 1)
                        }
                    }
                self = .loaded(entryViewModels)
            case .failure: self = .error
            }
        }
    }
    
    /// Updates the view model using the given API result.
    /// - Parameter result: The result of the `LeaderboardService` get call.
    func update(with result: Result<LeaderboardResponse, Error>) {
        state = State(result: result)
    }
}
