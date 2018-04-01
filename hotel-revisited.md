## What is the responsibility of each class?

- **Room**: check if the room is available

- **Reservation**: calculates the cost of the reservation

- **Block**: validate the number of rooms that are to be reserved for the block

- **Admin**: manage rooms

  Reference implementation methods:

  - reserve
  - list reservations
  - available rooms (includes block)
  - build block
  - reserve from block

  My implementation

  - new reservation
  - list reservations
  - calculate reservation cost
  - find reservation
  - find available rooms
  - reserve block
  - get available block rooms
  - helpers:
    - get rooms (initialize with a certain number of rooms)
    - specified room check
    - check for reservation
    - find block


## Where does a class directly modify the attributes of another class?

- find_block finds based on attributes (does not modify)
