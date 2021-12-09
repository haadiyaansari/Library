# @version ^0.2.0

struct books:
    key: uint256
    owner: address
    numberOfTimeBorrowed: uint256
    rating: uint256
    price: uint256
    uniqueID: uint256

struct users:
    borrowedBooks: books[10]
    booksOwned: books[10]



