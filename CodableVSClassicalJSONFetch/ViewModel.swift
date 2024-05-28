//
//  ViewModel.swift
//  CodableVSClassicalJSONFetch
//
//  Created by Andrei Ionescu on 28.05.2024.
//

import Foundation
import Combine

enum TableSection {
    case main
}

class ViewModel {
    var updateTableView = PassthroughSubject<Void, Never>()
    var films = [Film]()
    var filmsOLD = [FilmClassic]()
    private let filmsURL = "https://ionescuandrei.com/apps/jsons/films.json"
    var hasInternetConnection = false
    
    init(hasInternetConnection: Bool) {
        self.hasInternetConnection = hasInternetConnection
    }
    
    func getFilms() {
        if hasInternetConnection {
            getLatestFilms()
        } else {
            getLatestFilmsOffline()
        }
    }
    
    
    private func getLatestFilmsOffline() {
        let fileName = "films"
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let filmsData = try decoder.decode(Films.self, from: data)
                self.films = filmsData.films
                self.updateTableView.send()
            } catch {
                print(error)
            }
        }
    }
    
    private func getLatestFilms() {
        guard let loanUrl = URL(string: filmsURL) else {
            return
        }
        
        let request = URLRequest(url: loanUrl)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {
                self.films = self.parseJsonDataCodable(data: data)
                self.filmsOLD = self.parseJsonDataOLD(data: data)
                
                // Update table view's data
                OperationQueue.main.addOperation({
                    self.updateTableView.send()
                })
            }
        })
        
        task.resume()
    }
    
    private func parseJsonDataCodable(data: Data) -> [Film] {
        var films = [Film]()
        let decoder = JSONDecoder()
        
        do {
            let filmsData = try decoder.decode(Films.self, from: data)
            films = filmsData.films
            
        } catch {
            print(error)
        }
        
        return films
    }
    
    private func parseJsonDataOLD(data: Data) -> [FilmClassic] {
        
        var films = [FilmClassic]()
        
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            // Parse JSON data
            let jsonFilms = jsonResult?["films"] as! [AnyObject]
            for jsonFilm in jsonFilms {
                
                guard let title = jsonFilm["title"] as? String,
                      let year = jsonFilm["year"] as? String,
                      let rated = jsonFilm["rated"] as? String,
                      let _ = jsonFilm["released"] as? String,
                      let runtime = jsonFilm["runtime"] as? String,
                      let genre = jsonFilm["genre"] as? String,
                      let _ = jsonFilm["director"] as? String,
                      let country = jsonFilm["country"] as? [String: String?] else {
                    continue
                    
                }
                let film = FilmClassic(title: title, year: year, rated: rated, runtime: runtime, genre: genre, country1: country["country1"] as? String ?? "", country2: country["country2"] as? String)
                films.append(film)
            }
            
        } catch {
            print(error)
        }
        
        return films
    }
}
