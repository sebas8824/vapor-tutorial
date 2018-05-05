import Vapor
import FluentProvider
import HTTP

final class Pokemon: Model {
    let storage = Storage()
    
    // MARK: Properties and database keys
    
    /// The content of the post
    var name: String
    
    /// The column names for `id` and `content` in the database
    struct Keys {
        static let id = "id"
        static let name = "name"
    }
    
    /// Creates a new Post
    init(name: String) {
        self.name = name
    }
    
    // MARK: Fluent Serialization
    
    /// Initializes the Post from the
    /// database row
    init(row: Row) throws {
        name = try row.get(Pokemon.Keys.name)
    }
    
    // Serializes the Post to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Pokemon.Keys.name, name)
        return row
    }
}

// MARK: Fluent Preparation

extension Pokemon: Preparation {
    /// Prepares a table/collection in the database
    /// for storing Posts
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Pokemon.Keys.name)
        }
    }
    
    /// Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON

// How the model converts from / to JSON.
// For example when:
//     - Creating a new Post (POST /posts)
//     - Fetching a post (GET /posts, GET /posts/:id)
//
extension Pokemon: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            name: try json.get(Pokemon.Keys.name)
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Pokemon.Keys.id, id)
        try json.set(Pokemon.Keys.name, name)
        return json
    }
}

// MARK: HTTP

// This allows Post models to be returned
// directly in route closures
extension Pokemon: ResponseRepresentable { }

// MARK: Update

// This allows the Post model to be updated
// dynamically by the request.
extension Pokemon: Updateable {
    // Updateable keys are called when `post.update(for: req)` is called.
    // Add as many updateable keys as you like here.
    public static var updateableKeys: [UpdateableKey<Pokemon>] {
        return [
            // If the request contains a String at key "content"
            // the setter callback will be called.
            UpdateableKey(Pokemon.Keys.name, String.self) { pokemon, name in
                pokemon.name = name
            }
        ]
    }
}
