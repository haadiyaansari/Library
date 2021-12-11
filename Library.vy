# pragma @version ^0.2.4

# Book struct - contains information about books
struct books:
    url: String[32]
    key: uint256
    owner: address
    renter: address
    numberOfTimesBorrowed: uint256
    rating: uint256
    price: uint256
    uniqueID: uint256
    rented: bool
    name: String[32]

ENTRIES: constant(uint256) = 100 #max number of book
owner: public(address)   #owner of the contract
allbooks: books[ENTRIES] #list of books
bookNum: public(uint256) #number of books
reward: public(uint256)  #reward for rating a book

@external
def __init__():
    '''Constructor'''
    self.owner = msg.sender
    self.bookNum = 0
    self.reward = 1
    for i in range(ENTRIES):
        self.allbooks[i].key = 0
        self.allbooks[i].owner = msg.sender
        self.allbooks[i].numberOfTimesBorrowed = 0
        self.allbooks[i].rating = 0
        self.allbooks[i].price = 0
        self.allbooks[i].uniqueID = 0
        self.allbooks[i].rented = False

@external 
@payable
def add_book(key: uint256, bookurl: String[32], name: String[32]):
    '''Takes in key, bookurl, name and adds book to contract'''
    self.allbooks[self.bookNum].name = name
    self.allbooks[self.bookNum].key = key
    self.allbooks[self.bookNum].owner = msg.sender
    self.allbooks[self.bookNum].price = msg.value
    self.allbooks[self.bookNum].uniqueID = self.bookNum
    self.allbooks[self.bookNum].url = bookurl
    self.bookNum += 1

@external
def change_ownership(newowner: address, bookid: uint256):
    '''Takes in key and book id and changes ownership of book'''
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            assert msg.sender == self.allbooks[i].owner
            self.allbooks[i].owner = newowner

@external
@payable
def borrow_book(bookid: uint256):
    '''Allows users to borrow book - takes in book id'''
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            assert msg.value >= self.allbooks[i].price
            send(self.allbooks[i].owner, msg.value)
            #self.allbooks[i].price += 1
            self.allbooks[i].rented = True
            self.allbooks[i].renter = msg.sender
            self.allbooks[i].numberOfTimesBorrowed += 1


@external
def return_book(bookid: uint256):
    '''Takes in book id and sets the borrowed bool to false - aka the book has been returned'''
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            assert msg.sender == self.allbooks[i].owner
            self.allbooks[i].rented = False
            self.allbooks[i].renter = self.owner


@external
def rate_book(bookid: uint256, bookrating: uint256):
    '''Takes in book id and rating and sets the rating of the book'''
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            assert msg.sender == self.allbooks[i].renter
            self.allbooks[i].rating = bookrating
            assert self.balance > self.reward
            send(self.allbooks[i].renter, self.reward)

@external
def change_rating_award(newreward: uint256):
    '''Sets award for rating a book'''
    assert msg.sender == self.owner
    self.reward = newreward

@external
@view
def view_book_price(bookid: uint256) -> uint256:
    '''Takes in book id and spits out price of book'''
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            return self.allbooks[i].price
    return 10000000

@external
@view
def view_book_name(bookid: uint256) -> String[32]:
    '''Takes in book id and spits out name of book'''
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            return self.allbooks[i].name
    return "Not found"

@external
@view
def view_book_key(bookid: uint256) -> uint256:
    '''Takes in book id and spits out the key to access book'''
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            assert(msg.sender == self.allbooks[i].renter)
            return self.allbooks[i].key
    return 10000000   

@external
@view
def view_book_url(bookid: uint256) -> String[32]:
    '''Takes in book id and spits out url of book'''
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            return self.allbooks[i].url
    return "Not found"

@external
@view
def view_book_owner(bookid: uint256) -> address:
    '''Takes in book id and spits out owner of book'''
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            return self.allbooks[i].owner
    return self.owner

@external
@view
def view_book_rented(bookid: uint256) -> bool:
    '''Takes in book id and spits out if book is rented out'''
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            return self.allbooks[i].rented
    return True

@external 
def set_key(bookid: uint256, newkey: uint256):
    '''Takes in book id and newkey and sets key for book'''
    for i in range(ENTRIES):
        if(self.allbooks[i].uniqueID == bookid):
            assert msg.sender == self.allbooks[i].owner
            self.allbooks[i].key = newkey


@external
@view
def view_book_rating(bookid: uint256) -> uint256:
    '''Takes in book id and spits out rating of book'''
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            return self.allbooks[i].rating
    return 10000000   

#Owner gets all ether from contract
@external
def cashOut():
    selfdestruct(self.owner)

#Send us ether!!!
@external
@payable
def __default__():
    pass
