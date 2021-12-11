# pragma @version ^0.2.4

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

ENTRIES: constant(uint256) = 100
owner: public(address)
allbooks: books[ENTRIES]
bookNum: public(uint256)
reward: public(uint256)

@external
def __init__():
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
    self.allbooks[self.bookNum].name = name
    self.allbooks[self.bookNum].key = key
    self.allbooks[self.bookNum].owner = msg.sender
    self.allbooks[self.bookNum].price = msg.value
    self.allbooks[self.bookNum].uniqueID = self.bookNum
    self.allbooks[self.bookNum].url = bookurl
    self.bookNum += 1

@external
@payable
def change_ownership(newowner: address, bookid: uint256):
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            assert msg.sender == self.allbooks[i].owner
            self.allbooks[i].owner = newowner

@external
@payable
def borrow_book(bookid: uint256):
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            #assert msg.value >= self.allbooks[i].price
            #send(self.allbooks[i].owner, msg.value)
            self.allbooks[i].price += 1
            self.allbooks[i].rented = True
            self.allbooks[i].renter = msg.sender
            self.allbooks[i].numberOfTimesBorrowed += 1


@external
def return_book(bookid: uint256):
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            assert msg.sender == self.allbooks[i].owner
            self.allbooks[i].rented = False
            self.allbooks[i].renter = msg.sender


@external
def rate_book(bookid: uint256, bookrating: uint256):
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            assert msg.sender == self.allbooks[i].owner
            self.allbooks[i].rating = bookrating
            assert self.balance > self.reward
            send(self.allbooks[i].renter, self.reward)

@external
def change_rating_award(newreward: uint256):
    self.reward = newreward


@external
@view
def view_book_price(bookid: uint256) -> uint256:
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            return self.allbooks[i].price
    return 10000000


@external
@view
def view_book_name(bookid: uint256) -> String[32]:
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            return self.allbooks[i].name
    return "Not found"

@external
@view
def view_book_key(bookid: uint256) -> uint256:
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            assert msg.sender == self.allbooks[i].owner
            return self.allbooks[i].key
    return 10000000   

@external 
def set_key(bookid: uint256, newkey: uint256):
    for i in range(ENTRIES):
        if(self.allbooks[i].uniqueID == bookid):
            assert msg.sender == self.allbooks[i].owner
            self.allbooks[i].key = newkey

@external
def cashOut():
    selfdestruct(self.owner)

@external
@payable
def __default__():
    pass
