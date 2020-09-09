import Foundation

/**
 The task is to implement the Library protocol (you can do that in this file directly).
 - No database or any other storage is required, just store data in memory
 - No any smart search, use String method contains (case sensitive/insensitive - does not matter)
 –   Performance optimizations are optional
*/

struct Book {
    let id: String; // unique identifier
    let name: String;
    let author: String;
}

protocol Library {
    /**
     Adds a new book object to the Library.
     - Parameter book: book to add to the Library
     - Returns: false if the book with same id already exists in the Library, true – otherwise.
    */
    func addNewBook(book: Book) -> Bool;
    
    /**
     Deletes the book with the specified id from the Library.
     - Returns: true if the book with same id existed in the Library, false – otherwise.
    */
    func deleteBook(id: String) -> Bool;
    
    /**
     - Returns: 10 book names containing the specified string. If there are several books with the same name, author's name is appended to book's name.
    */
    func listBooksByName(searchString: String) -> Set<String>;
    
    /**
     - Returns: 10 book names whose author contains the specified string, ordered by authors.
    */
    func listBooksByAuthor(searchString: String) -> [String];
}

// TODO: your implementation goes here
class LibraryImpl: Library {
	
	// MARK: - Private properties

	private var library = [String: Book]()

	// MARK: - Public functions

    func addNewBook(book: Book) -> Bool {
		if library[book.id] != nil {
			return false
		}
		library[book.id] = book
		return true
    }
    
    func deleteBook(id: String) -> Bool {
		if library[id] == nil {
			return false
		}
		library[id] = nil
		return true
    }
    
    func listBooksByName(searchString: String) -> Set<String> {
        let books = library.map { $1 }
			.filter { $0.name.contains(searchString) }
			.prefix(10)
		
		return books.reduce(into: Set<String>()) { (result, book) in
			if books.filter({ $0.name == book.name }).count > 1 {
				result.insert(book.author + " - " + book.name)
			} else {
				result.insert(book.name)
			}
		}
    }
    
    func listBooksByAuthor(searchString: String) -> [String] {
		return library.sorted { (item1, item2) -> Bool in
			item1.value.author < item2.value.author
		}.map { $1 }
			.filter { $0.author.contains(searchString) }
			.sorted { $0.author < $1.author }
			.prefix(10)
			.map {$0.name}
    }
    
}

func test(lib: Library) {
    assert(!lib.deleteBook(id: "1"))
    assert(lib.addNewBook(book: Book(id: "1", name: "1", author: "Lex")))
    assert(!lib.addNewBook(book: Book(id: "1", name: "1", author: "Lex")))
    assert(lib.deleteBook(id: "1"))
    assert(lib.addNewBook(book: Book(id: "4", name: "Name1", author: "Lex3")))
    assert(lib.addNewBook(book: Book(id: "3", name: "Name3", author: "Lex2")))
    assert(lib.addNewBook(book: Book(id: "2", name: "Name2", author: "Lex2")))
    assert(lib.addNewBook(book: Book(id: "1", name: "Name1", author: "Lex1")))
    let byNames: Set<String> = lib.listBooksByName(searchString: "Name")
    assert(byNames.contains("Lex3 - Name1"))
    assert(byNames.contains("Name2"))
    assert(byNames.contains("Name3"))
    assert(byNames.contains("Lex1 - Name1"))
    let byAuthor: [String] = lib.listBooksByAuthor(searchString: "Lex")
    assert(byAuthor[0] == "Name1")
    assert(byAuthor[1] == "Name2" || byAuthor[1] == "Name3")
    assert(byAuthor[2] == "Name2" || byAuthor[2] == "Name3")
    assert(byAuthor[3] == "Name1")
}

test(lib: LibraryImpl())
