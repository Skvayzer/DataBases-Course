CREATE TABLE IF NOT EXISTS Order
(
    orderId     integer PRIMARY KEY,
    date        text NOT NULL,
    city         text NOT NULL,
    customerId  integer NOT NULL,
    --containerId   integer  NOT NULL,
    FOREIGN KEY (customerId) REFERENCES Customer (customerId),
    --FOREIGN KEY (containerId) REFERENCES Contains (containerId)
);

CREATE TABLE IF NOT EXISTS Item
(
    itemId   integer PRIMARY KEY,
    itemName text NOT NULL,
    price real NOT NULL,
);



CREATE TABLE IF NOT EXISTS Customer
(
    customerId  integer NOT NULL PRIMARY KEY,
    customerName text NOT NULL,
);

CREATE TABLE IF NOT EXISTS Contains
(
    containerId  integer PRIMARY KEY,
    orderId integer NOUT NULL,
    itemId  integer NOT NULL,
    quant integer NOT NULL,
    FOREIGN KEY (itemId) REFERENCES Item (itemId),
    FOREIGN KEY (orderId) REFERENCES Order (orderId),

);

INSERT INTO Order
VALUES (2031, '23/02/2011', '101', 'Prague'),
       (2302, '25/02/2011', '107', 'Madrid'),
       (2303, '27/02/2011', '110', 'Moscow'),

ON CONFLICT DO NOTHING;

INSERT INTO Item
VALUES (3786, 'Net', 35),
       (4011, 'Racket', 65),
       (3896, 'Elmer',10)
ON CONFLICT DO NOTHING;

INSERT INTO Catalog
VALUES (1, 1, 10),
       (1, 2, 20),
       (1, 3, 30),
       (1, 4, 40),
       (1, 5, 50),
       (2, 1, 9),
       (2, 3, 34),
       (2, 5, 48)
ON CONFLICT DO NOTHING;


-- Calculate the total number of items per order and the total amount to pay for the order.
SELECT SUM(quant), SUM(price*quant)
FROM Constains, Item
GROUP BY orderId

-- Obtain the customer whose purchase in terms of money has been greater than the others
SELECT customerId
FROM MAX(
SELECT SUM(price*quant)
FROM Constains, Item, Order
GROUP BY customerId
)


