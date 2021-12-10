# pragma @version ^0.2.4

struct books:
    key: uint256
    owner: address
    numberOfTimesBorrowed: uint256
    rating: uint256
    price: uint256
    uniqueID: uint256

struct users:
    username: String[32]
    useradr: address
    borrowedBooks: uint256
    booksOwned: uint256

ENTRIES: constant(uint256) = 100
owner: public(address)
allbooks: public(books[ENTRIES])
allusers: public(users[ENTRIES])
bookindex: public(uint256)
userindex: public(uint256)
IDtracker: public(uint256)

@external
def __init__():
    self.owner = msg.sender
    self.bookindex = 0
    self.userindex = 0
    self.IDtracker = 0
    for i in range(ENTRIES):
        self.allbooks[i].key = 0
        self.allbooks[i].owner = msg.sender
        self.allbooks[i].numberOfTimesBorrowed = 0
        self.allbooks[i].rating = 0
        self.allbooks[i].price = 0
        self.allbooks[i].uniqueID = 0

    for i in range(ENTRIES):
        #self.allusers[i].username = "default"
        self.allusers[i].useradr = msg.sender
        self.allusers[i].borrowedBooks = 0
        self.allusers[i].booksOwned = 0


@external
@payable
def create_user(name: String[32]):
    self.allusers[self.userindex].username = name
    self.allusers[self.userindex].useradr = msg.sender
    self.userindex += 1

@external 
@view
def user_count() -> uint256:
    return self.userindex
