
CREATE TABLE IF NOT EXISTS Customer
(
    customerId  integer NOT NULL PRIMARY KEY,
    customerName text NOT NULL
);

CREATE TABLE IF NOT EXISTS Orders
(
    orderId     integer PRIMARY KEY,
    customerId  integer NOT NULL,
    date        date NOT NULL,
    city         text NOT NULL,
    --containerId   integer  NOT NULL,
    FOREIGN KEY (customerId) REFERENCES Customer (customerId)
    --FOREIGN KEY (containerId) REFERENCES Contains (containerId)
);

CREATE TABLE IF NOT EXISTS Item
(
    itemId   integer PRIMARY KEY,
    itemName text NOT NULL,
    price real NOT NULL
);

CREATE TABLE IF NOT EXISTS Container
(
    containerId  integer PRIMARY KEY,
    orderId integer NOT NULL,
    itemId  integer NOT NULL,
    quant integer NOT NULL,
    FOREIGN KEY (itemId) REFERENCES Item (itemId),
    FOREIGN KEY (orderId) REFERENCES Orders (orderId)

);
INSERT INTO Customer
VALUES (101, 'Martin'),
	   (107, 'Herman'),
       (110, 'Pedro')
ON CONFLICT DO NOTHING;

INSERT INTO Orders
VALUES (2301, 101, TO_DATE('23/02/2011','DD/MM/YYYY'), 'Prague'),
       (2302, 107, TO_DATE('25/02/2011','DD/MM/YYYY'), 'Madrid'),
       (2303, 110, TO_DATE('27/02/2011','DD/MM/YYYY'), 'Moscow')
ON CONFLICT DO NOTHING;

INSERT INTO Item
VALUES (3786, 'Net', 35),
       (4011, 'Racket', 65),
       (9132, 'Pack-3', 4.75),
       (5794, 'Pack -6', 5),
       (3141, 'Cover', 10)
ON CONFLICT DO NOTHING;



INSERT INTO Container
VALUES (1, 2301, 3786, 3),
       (2, 2301, 4011, 6),
       (3, 2301, 9132, 8),
       (4, 2302, 5794, 4),
       (5, 2303, 4011, 2),
       (6, 2303, 3141, 2)
ON CONFLICT DO NOTHING;


-- Calculate the total number of items per order and the total amount to pay for the order.
SELECT orderId, SUM(quant) as quant, SUM(price*quant) as payment
FROM Container, Item
WHERE Container.itemId=Item.itemId
GROUP BY orderId;



-- Obtain the customer whose purchase in terms of money has been greater than the others
SELECT customerId, SUM(price*quant) AS purchase
FROM Container, Item, Orders
WHERE Container.itemId=Item.itemId AND Container.orderId=Orders.orderId
GROUP BY customerId
ORDER BY purchase DESC
LIMIT 1



