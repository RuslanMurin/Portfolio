import Foundation

class Result: Codable {
    let top: [Top]

    enum CodingKeys: String, CodingKey {
        case top = "top"
    }

    init(top: [Top]) {
        self.top = top
    }
}

class Top: Codable {
    let game: Game
    let viewers: Int
    let channels: Int

    init(game: Game, viewers: Int, channels: Int) {
        self.game = game
        self.viewers = viewers
        self.channels = channels
    }
}

class Game: Codable {
    let name: String
    let box: Box

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case box = "box"
    }

    init(name: String, box: Box) {
        self.name = name
        self.box = box
    }
}

class Box: Codable {
    let large: String

    init(large: String) {
        self.large = large
    }
}
