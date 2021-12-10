# pragma @version ^0.2.4

struct books:
    key: uint256
    owner: address
    numberOfTimesBorrowed: uint256
    rating: uint256
    price: uint256
    uniqueID: uint256
    rented: bool
    name: String[32]

ENTRIES: constant(uint256) = 100
owner: public(address)
allbooks: books[ENTRIES]
bookindex: public(uint256)
IDtracker: public(uint256)

@external
def __init__():
    self.owner = msg.sender
    self.bookindex = 0
    self.IDtracker = 0
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
def add_book(key: uint256, price: uint256, name: String[32]):
    self.allbooks[self.bookindex].name = name
    self.allbooks[self.bookindex].key = key
    self.allbooks[self.bookindex].owner = msg.sender
    self.allbooks[self.bookindex].price = msg.value
    self.allbooks[self.bookindex].uniqueID = self.bookindex
    self.bookindex += 1

@internal
def update_price(newprice: uint256, bookid: uint256):
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            self.allbooks[i].price = newprice

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
            assert msg.value >= self.allbooks[i].price
            send(self.allbooks[i].owner, msg.value)
            #self.allbooks[i].price += 0.000001
            self.allbooks[i].rented = True
            self.allbooks[i].numberOfTimesBorrowed += 1


@external
def return_book(bookid: uint256):
    for i in range(ENTRIES):
        if (self.allbooks[i].uniqueID == bookid):
            assert msg.sender == self.allbooks[i].owner
            self.allbooks[i].rented = False


# # rate book - calculate average rating TBD. Users get x% of contract funds if they leave a review
# @external
# def rate_book(bookid: uint256):

# get list of books in library
# @external
# @payable
# def get_all_books(bookid: uint256):

@external
def cashOut():
    selfdestruct(self.owner)

@external
@payable
def __default__():
    pass
