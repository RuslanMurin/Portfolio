import Foundation

class Landmark: Codable {
    let name: String
    let category: Category
    let city, state: String
    let id: Int
    let isFeatured, isFavorite: Bool
    let park: String
    let coordinates: Coordinates
    let landmarkDescription, imageName: String
    
    enum CodingKeys: String, CodingKey {
        case name, category, city, state, id, isFeatured, isFavorite, park, coordinates
        case landmarkDescription = "description"
        case imageName
    }

    init(name: String, category: Category, city: String, state: String, id: Int, isFeatured: Bool, isFavorite: Bool, park: String, coordinates: Coordinates, landmarkDescription: String, imageName: String) {
        self.name = name
        self.category = category
        self.city = city
        self.state = state
        self.id = id
        self.isFeatured = isFeatured
        self.isFavorite = isFavorite
        self.park = park
        self.coordinates = coordinates
        self.landmarkDescription = landmarkDescription
        self.imageName = imageName
    }
}

enum Category: String, Codable {
    case lakes = "Lakes"
    case mountains = "Mountains"
    case rivers = "Rivers"
}

class Coordinates: Codable {
    let longitude, latitude: Double

    init(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
}

typealias Landmarks = [Landmark]
