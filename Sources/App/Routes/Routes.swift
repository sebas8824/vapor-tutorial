import Vapor
//JSONInitializable is a way to serialize a data recieved from a client from a JSON
class User: JSONRepresentable, ResponseRepresentable, JSONInitializable {
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("firstName", self.firstName)
        try json.set("lastName", self.lastName)
        return json
    }
    
    var firstName: String!
    var lastName: String!
    
    convenience required init(json: JSON) throws {
        try self.init(firstName: json.get("firstName"), lastName: json.get("lastName"))
    }
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

extension Droplet {
    func setupRoutes() throws {
        get("users") { req in
            var users = [User]()
            users.append(User(firstName: "Jhon", lastName: "Doe"))
            users.append(User(firstName: "Mary", lastName: "Doe"))
            
            return try users.makeJSON()
        }
        
        get("user") { req in
            /* Using JSONInitializable */
            var json = JSON()
            try json.set("firstName","John")
            try json.set("lastName","Doe")
            let user = try User(json: json)
            //let user = User(firstName: "Sebastian", lastName: "Benitez")
            /* Without ResponseRepresentable
            return try user.makeJSON() */
            /* With ResponseRepresentable */
            return user
        }
        
        // Passes an id parameter of type int
        get("user",":id") { req in
            guard let userId = req.parameters["id"]?.int else {
                fatalError("id not found")
            }
            
            return "user id is \(userId)"
        }
        
        // Passes multiple parameters
        get("movies/:genre/:year") { req in
            guard let genre = req.parameters["genre"]?.string,
                let year = req.parameters["year"]?.int else {
                    fatalError("invalid parameters")
            }
            
            return "Genre is \(genre), Year is \(year)"
            
        }
        
        // Ensures that the next parameter is of type integer
        get("customer", Int.parameter) { req in
            let customerId = try req.parameters.next(Int.self)
            return "The customerId is \(customerId)"
        }
        
        // MARK: Group & Grouped
        
        group("v1") { v1 in
            
            // v1/customers
            v1.get("customers") { req in
                return "customers in v1"
            }
            // v1/users
            v1.get("users") { req in
                return "users in v1"
            }
        }
        
        // Grouped does not provide a closure
        let v2 = grouped("v2")
        v2.get("customers") { req in
            return "returned v2/customers"
        }
        
        v2.get("users") { req in
            return "returned v2/users"
        }
        
        // MARK: Post
        post("customer") { req in
            guard let name = req.json?["name"]?.string,
                let age = req.json?["age"]?.int
            else {
                fatalError("Invalid parameters")
            }
            
            return "the name is \(name), the age is \(age)"
        }
        
    }
}
