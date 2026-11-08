CREATE TABLE PUBLISHER (
    PublisherID   INT           NOT NULL,
    PubName       VARCHAR(100)  NOT NULL,
    Phone         VARCHAR(20),
    Website       VARCHAR(255),
    CONSTRAINT pk_publisher PRIMARY KEY (PublisherID)
);

CREATE TABLE CATEGORY (
    CategoryID    INT           NOT NULL,
    CategoryName  VARCHAR(50)   NOT NULL,
    Description   VARCHAR(255),
    CONSTRAINT pk_category PRIMARY KEY (CategoryID),
    CONSTRAINT uq_category_name UNIQUE (CategoryName)
);

CREATE TABLE ADMIN (
    AdminID       INT           NOT NULL,
    Name          VARCHAR(100)  NOT NULL,
    Email         VARCHAR(100)  NOT NULL,
    Role          VARCHAR(20)   NOT NULL,
    CONSTRAINT pk_admin PRIMARY KEY (AdminID),
    CONSTRAINT uq_admin_email UNIQUE (Email),
    CONSTRAINT chk_admin_role CHECK (Role IN ('Manager', 'Staff'))
);

CREATE TABLE AUTHOR (
    AuthorID      INT           NOT NULL,
    FName         VARCHAR(50)   NOT NULL,
    LName         VARCHAR(50)   NOT NULL,
    Bio           VARCHAR(500),
    CONSTRAINT pk_author PRIMARY KEY (AuthorID)
);

CREATE TABLE CUSTOMER (
    CustomerID    INT           NOT NULL,
    FName         VARCHAR(50)   NOT NULL,
    LName         VARCHAR(50)   NOT NULL,
    Email         VARCHAR(100)  NOT NULL,
    Street        VARCHAR(100),
    City          VARCHAR(50),
    State         CHAR(2),
    Zip           VARCHAR(10),
    CONSTRAINT pk_customer PRIMARY KEY (CustomerID),
    CONSTRAINT uq_customer_email UNIQUE (Email)
);

CREATE TABLE BOOK (
    ISBN          CHAR(13)      NOT NULL,
    Title         VARCHAR(200)  NOT NULL,
    Edition       INT           DEFAULT 1 NOT NULL,
    PubYear       SMALLINT,
    Price         DECIMAL(8,2)  NOT NULL,
    PublisherID   INT           NOT NULL,
    CategoryID    INT           NOT NULL,
    AdminID       INT           NOT NULL,
    CONSTRAINT pk_book PRIMARY KEY (ISBN),
    CONSTRAINT fk_book_publisher FOREIGN KEY (PublisherID) REFERENCES PUBLISHER (PublisherID),
    CONSTRAINT fk_book_category  FOREIGN KEY (CategoryID)  REFERENCES CATEGORY (CategoryID),
    CONSTRAINT fk_book_admin     FOREIGN KEY (AdminID)     REFERENCES ADMIN (AdminID),
    CONSTRAINT chk_book_price    CHECK (Price >= 0),
    CONSTRAINT chk_book_edition  CHECK (Edition >= 1)
);

CREATE TABLE PRINT_BOOK (
    ISBN          CHAR(13)      NOT NULL,
    Format        VARCHAR(20)   NOT NULL,
    Pages         INT,
    StockQty      INT           DEFAULT 0 NOT NULL,
    CONSTRAINT pk_print_book PRIMARY KEY (ISBN),
    CONSTRAINT fk_print_book_book FOREIGN KEY (ISBN) REFERENCES BOOK (ISBN) ON DELETE CASCADE,
    CONSTRAINT chk_print_book_format CHECK (Format IN ('Hardcover', 'Paperback')),
    CONSTRAINT chk_print_book_pages  CHECK (Pages > 0),
    CONSTRAINT chk_print_book_stock  CHECK (StockQty >= 0)
);

CREATE TABLE EBOOK (
    ISBN          CHAR(13)      NOT NULL,
    FileFormat    VARCHAR(10)   NOT NULL,
    FileSizeMB    DECIMAL(6,2),
    CONSTRAINT pk_ebook PRIMARY KEY (ISBN),
    CONSTRAINT fk_ebook_book FOREIGN KEY (ISBN) REFERENCES BOOK (ISBN) ON DELETE CASCADE,
    CONSTRAINT chk_ebook_format CHECK (FileFormat IN ('PDF', 'EPUB', 'MOBI')),
    CONSTRAINT chk_ebook_size   CHECK (FileSizeMB > 0)
);

CREATE TABLE WRITES (
    AuthorID      INT           NOT NULL,
    ISBN          CHAR(13)      NOT NULL,
    CONSTRAINT pk_writes PRIMARY KEY (AuthorID, ISBN),
    CONSTRAINT fk_writes_author FOREIGN KEY (AuthorID) REFERENCES AUTHOR (AuthorID),
    CONSTRAINT fk_writes_book   FOREIGN KEY (ISBN)     REFERENCES BOOK (ISBN)
);

CREATE TABLE CUSTOMER_PHONE (
    CustomerID    INT           NOT NULL,
    Phone         VARCHAR(20)   NOT NULL,
    CONSTRAINT pk_customer_phone PRIMARY KEY (CustomerID, Phone),
    CONSTRAINT fk_customer_phone_customer FOREIGN KEY (CustomerID) REFERENCES CUSTOMER (CustomerID) ON DELETE CASCADE
);

CREATE TABLE ORDERS (
    OrderID       INT           NOT NULL,
    OrderDate     DATE          NOT NULL,
    Status        VARCHAR(20)   DEFAULT 'Pending' NOT NULL,
    CustomerID    INT           NOT NULL,
    CONSTRAINT pk_orders PRIMARY KEY (OrderID),
    CONSTRAINT fk_orders_customer FOREIGN KEY (CustomerID) REFERENCES CUSTOMER (CustomerID),
    CONSTRAINT chk_orders_status CHECK (Status IN ('Pending', 'Paid', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE ORDER_ITEM (
    OrderID       INT           NOT NULL,
    ISBN          CHAR(13)      NOT NULL,
    Quantity      INT           NOT NULL,
    UnitPrice     DECIMAL(8,2)  NOT NULL,
    CONSTRAINT pk_order_item PRIMARY KEY (OrderID, ISBN),
    CONSTRAINT fk_order_item_orders FOREIGN KEY (OrderID) REFERENCES ORDERS (OrderID) ON DELETE CASCADE,
    CONSTRAINT fk_order_item_book   FOREIGN KEY (ISBN)    REFERENCES BOOK (ISBN),
    CONSTRAINT chk_order_item_quantity CHECK (Quantity > 0),
    CONSTRAINT chk_order_item_price    CHECK (UnitPrice >= 0)
);

CREATE TABLE PAYMENT (
    OrderID       INT           NOT NULL,
    PaymentNo     INT           NOT NULL,
    Amount        DECIMAL(10,2) NOT NULL,
    Method        VARCHAR(20)   NOT NULL,
    PayDate       DATE          NOT NULL,
    CONSTRAINT pk_payment PRIMARY KEY (OrderID, PaymentNo),
    CONSTRAINT fk_payment_orders FOREIGN KEY (OrderID) REFERENCES ORDERS (OrderID) ON DELETE CASCADE,
    CONSTRAINT chk_payment_amount CHECK (Amount > 0),
    CONSTRAINT chk_payment_method CHECK (Method IN ('Credit Card', 'Debit Card', 'PayPal', 'Gift Card'))
);

CREATE TABLE REVIEW (
    CustomerID    INT           NOT NULL,
    ISBN          CHAR(13)      NOT NULL,
    Rating        SMALLINT      NOT NULL,
    ReviewComment VARCHAR(500),
    ReviewDate    DATE          NOT NULL,
    CONSTRAINT pk_review PRIMARY KEY (CustomerID, ISBN),
    CONSTRAINT fk_review_customer FOREIGN KEY (CustomerID) REFERENCES CUSTOMER (CustomerID),
    CONSTRAINT fk_review_book     FOREIGN KEY (ISBN)       REFERENCES BOOK (ISBN),
    CONSTRAINT chk_review_rating  CHECK (Rating BETWEEN 1 AND 5)
);

SELECT table_name FROM user_tables ORDER BY table_name;