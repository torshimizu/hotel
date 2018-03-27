#### What classes does each implementation include? Are the lists the same?
Both implementations have the same list of classes: CartEntry, ShoppingCart, and Order

#### Write down a sentence to describe each class.
CartEntry: A product with its quantity
ShoppingCart: A list of products
Order: Manages the checkout of the ShoppingCart

#### How do the classes relate to each other? It might be helpful to draw a diagram on a whiteboard or piece of paper.
CartEntry < ShoppingCart < Order
An order has a shopping cart and a shopping cart has many cart entries

#### What data does each class store? How (if at all) does this differ between the two implementations?
In Implementation A, both the CartEntry and the ShoppingCart contain the data associated with each instance. The Order class calculates the cost of all the CartEntries in the ShoppingCart.

In Implementation B, the CartEntry is responsible for determining its gross price. The ShoppingCart is also responsible for determining the subtotal of the cart (sum of CartEntries' prices). The Order takes the cart subtotal and calculates the total by adding sales tax.

#### What methods does each class have? How (if at all) does this differ between the two implementations?
Both implementations have a total_price method in the Order class, but in Implementation A, the Order class is the only class to calculate costs/prices.

In Implementation B, each class is responsible for calculating its cost.

#### Consider the Order#total_price method. In each implementation:
- Is logic to compute the price delegated to "lower level" classes like ShoppingCart and CartEntry, or is it retained in Order? <br>
  The price computation is retained in Order in Implementation A, in Implementation B, it is delegated to each lower level class.

- Does total_price directly manipulate the instance variables of other classes? <br>
    In A, the data is accessed by the accessor method, but Order#total_price has to know about the accessor method (and thusly, the instance variable) for the CartEntry. <br>
    In B, each price method of the higher level classes calls the price method of the class directly below it.

#### If we decide items are cheaper if bought in bulk, how would this change the code? Which implementation is easier to modify?
If bulk pricing is desired, each item would need a minimum quantity to activate bulk price and would need the unit pricing for the item when bulk. This would change the calculation of price for each CartEntry. Implementation B would be easier to modify because the bulk pricing could be set or saved in CartEntry and none of the higher level classes would need to change their price method.

#### Which implementation better adheres to the single responsibility principle?
Implementation B

#### Bonus question once you've read Metz ch. 3: Which implementation is more loosely coupled?
Implementation B
