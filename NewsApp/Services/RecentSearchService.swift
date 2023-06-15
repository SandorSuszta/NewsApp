import RealmSwift

final class RecentSearchService {
    static let shared = RecentSearchService()
    
    private let realm: Realm
    
    //MARK: -  Init
    
    private init() {
        realm = try! Realm()
    }
    
    func saveSearch(query: String) {
        let search = RecentSearch()
        search.query = query
        
        try! realm.write {
            realm.add(search)
        }
    }
    
    func getRecentSearches() -> [String] {
        let searches = realm.objects(RecentSearch.self)
        return Array(searches).map { $0.query }
    }
}

