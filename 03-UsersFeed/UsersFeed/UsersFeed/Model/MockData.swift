
import Foundation

let names = ["Fyodor Dostoevsky", "Anton Chekhov", "Ivan Turgenev", "Mikhail Bulgakov",
             "Boris Pasternak", "Anna Akhmatova", "Marina Tsvetaeva", "Nikolai Gogol", "Alexander Pushkin",
             "Franz Kafka", "Albert Camus", "Jean-Paul Sartre", "Simone de Beauvoir", "Marcel Proust",
             "Ernest Hemingway", "F. Scott Fitzgerald", "Virginia Woolf", "James Joyce", "George Orwell",
             "Gabriel Garcia Marquez", "Jorge Luis Borges", "Pablo Neruda", "Haruki Murakami", "Yasunari Kawabata",
             "Toni Morrison", "Sylvia Plath", "William Faulkner", "John Steinbeck", "Oscar Wilde", "Mark Twain"]

var users: [User] = names.enumerated().map { index, name in
    User(
        id: UUID(),
        avatarURL: URL(string: "https://i.pravatar.cc/150?img=\(index)")!,
        name: name,
        status: StatusType.allCases.randomElement()!,
        like: false
        )
}
