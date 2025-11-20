create database demo_erp;
use demo_erp;

-- CREATING ALL THE TABLES

    -- Users Table
    CREATE TABLE IF NOT EXISTS Users (
        UserID INT AUTO_INCREMENT PRIMARY KEY,
        MailID VARCHAR(100) NOT NULL,
        Name VARCHAR(100) NOT NULL,
        Password VARCHAR(100) NOT NULL,
        Role VARCHAR(50) NOT NULL
    );

    -- Products Table
    CREATE TABLE IF NOT EXISTS Products (
        ProductID INT AUTO_INCREMENT PRIMARY KEY,
        Name VARCHAR(100) NOT NULL,
        Category VARCHAR(100) NOT NULL,
        Cost DECIMAL(10, 2) NOT NULL,
        SellingPrice DECIMAL(10, 2) NOT NULL,
        Stock INT NOT NULL,
        SalesData JSON DEFAULT NULL,
        ReorderLevel INT NOT NULL,
        SupplierInfo VARCHAR(100) DEFAULT NULL,
        ExpiryDate DATE DEFAULT NULL
    );

    -- Customers Table
    CREATE TABLE IF NOT EXISTS Customers (
        CustomerID INT AUTO_INCREMENT PRIMARY KEY,
        Name VARCHAR(100) NOT NULL,
        Email VARCHAR(100) NOT NULL,
        Phone VARCHAR(15) ,
        Address TEXT ,
        PurchaseHistory JSON DEFAULT NULL,
        LoyaltyPoints INT DEFAULT 0
    );

    -- Sales Table
    CREATE TABLE IF NOT EXISTS Sales (
        SaleID INT AUTO_INCREMENT PRIMARY KEY,
        ProductID INT NOT NULL,
        CustomerID INT NOT NULL,
        Date DATETIME NOT NULL,
        Quantity INT NOT NULL,
        TotalAmount DECIMAL(10, 2) NOT NULL,
        PaymentMethod VARCHAR(50) NOT NULL,
        FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    );

    -- Feedback Table
    CREATE TABLE IF NOT EXISTS Feedback (
        FeedbackID INT AUTO_INCREMENT PRIMARY KEY,
        ProductID INT NOT NULL,
        CustomerID INT NOT NULL,
        Comments TEXT DEFAULT NULL,
        Ratings INT CHECK (Ratings BETWEEN 1 AND 5),
        Timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    );

    -- Logs Table
    CREATE TABLE IF NOT EXISTS Logs (
        LogID INT AUTO_INCREMENT PRIMARY KEY,
        AlgorithmName VARCHAR(100) NOT NULL,
        Timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        Results JSON DEFAULT NULL
    );


--registration
DELIMITER //
CREATE  FUNCTION Registration(
    p_MailID VARCHAR(255),
    p_Name VARCHAR(255),
    p_Password VARCHAR(255),
    p_Role VARCHAR(50)
) RETURNS varchar(255) CHARSET utf8mb4
    MODIFIES SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_HashedPassword VARCHAR(255);
    DECLARE v_Message VARCHAR(255);

    -- Validate email inline using regex
    IF NOT (p_MailID REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
        RETURN 'Invalid email format. Please provide a valid email address.';
    END IF;

    -- Validate name
    IF p_Name IS NULL OR LENGTH(TRIM(p_Name)) = 0 THEN
        RETURN 'Name cannot be empty.';
    END IF;

    -- Validate password
    IF p_Password IS NULL OR LENGTH(p_Password) < 6 THEN
        RETURN 'Password must be at least 6 characters long.';
    END IF;

    -- Validate role
    IF p_Role IS NULL OR LENGTH(TRIM(p_Role)) = 0 THEN
        RETURN 'Role cannot be empty.';
    END IF;

    -- Hash the password using SHA-256
    SET v_HashedPassword = SHA2(p_Password, 256);

    -- Insert user details into the USERS table
    INSERT INTO USERS (MailID, Name, Password, Role)
    VALUES (p_MailID, p_Name, v_HashedPassword, p_Role);

    -- Set success message
    SET v_Message = 'Successfully Registered!!';

    RETURN v_Message;
END;
//

DELIMITER ;


-- Triger to store the regular user data to Customer table 
DELIMITER //

CREATE TRIGGER after_user_insert
AFTER INSERT ON Users
FOR EACH ROW
BEGIN
    -- Check if the Role of the newly inserted user is 'Regular'
    IF NEW.Role = 'Regular' THEN
        -- Insert the corresponding customer data into the Customers table
        INSERT INTO Customers (Name, Email, Phone, Address, PurchaseHistory, LoyaltyPoints)
        VALUES (NEW.Name, NEW.MailID, NULL, NULL, NULL, 0);
    END IF;
END;
//






-- Authentication


DELIMITER //

CREATE FUNCTION Authentication(
    p_MailID VARCHAR(255),
    p_Password VARCHAR(255)
)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE v_HashedPassword VARCHAR(255);
    DECLARE v_StoredPassword VARCHAR(255);
    DECLARE v_Result VARCHAR(50) DEFAULT 'Authentication Unsuccessful!';

    -- Hash the input password using SHA-256
    SET v_HashedPassword = SHA2(p_Password, 256);

    -- Retrieve the stored hashed password for the given email and active role
    BEGIN
        -- Use a handler to gracefully manage cases where no rows are found
        DECLARE EXIT HANDLER FOR NOT FOUND 
        BEGIN
            -- No matching record found; leave v_Result as 'Authentication Unsuccessful!'
            SET v_Result = 'Authentication Unsuccessful!';
        END;

        -- Attempt to fetch the stored password for active users
        SELECT Password INTO v_StoredPassword
        FROM Users
        WHERE MailID = p_MailID AND Role NOT LIKE 'Inactive_%';
    END;

    -- If the hashed password matches the stored password, update the result
    IF v_HashedPassword = v_StoredPassword THEN
        SET v_Result = 'Authentication Successful!';
    END IF;

    -- Return the authentication result message
    RETURN v_Result;
END;
//

DELIMITER ;

-- AdminAuthentication

DELIMITER //

CREATE FUNCTION AdminAuthentication(
    p_MailID VARCHAR(255),
    p_Password VARCHAR(255)
)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE v_HashedPassword VARCHAR(255);
    DECLARE v_StoredPassword VARCHAR(255);
    DECLARE v_Result VARCHAR(50) DEFAULT 'Authentication Unsuccessful!';

    -- Hash the input password using SHA-256
    SET v_HashedPassword = SHA2(p_Password, 256);

    -- Retrieve the stored hashed password for the given email and active role
    BEGIN
        -- Use a handler to gracefully manage cases where no rows are found
        DECLARE EXIT HANDLER FOR NOT FOUND 
        BEGIN
            -- No matching record found; leave v_Result as 'Authentication Unsuccessful!'
            SET v_Result = 'Authentication Unsuccessful!';
        END;

        -- Attempt to fetch the stored password for active users
        SELECT Password INTO v_StoredPassword
        FROM Users
        WHERE MailID = p_MailID AND Role NOT LIKE 'Inactive_%'AND Role = 'Admin';
    END;

    -- If the hashed password matches the stored password, update the result
    IF v_HashedPassword = v_StoredPassword THEN
        SET v_Result = 'Authentication Successful!';
    END IF;

    -- Return the authentication result message
    RETURN v_Result;
END;
//

DELIMITER ;

-- Function to fetch the total price 

DELIMITER //

CREATE FUNCTION FetchTotalCost(
    p_ProductID INT,
    p_Quantity INT
)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE v_SellingPrice DECIMAL(10, 2);
    DECLARE v_TotalCost DECIMAL(10, 2);

    -- Retrieve the selling price of the product
    SELECT SellingPrice INTO v_SellingPrice
    FROM Products
    WHERE ProductID = p_ProductID;

    -- Calculate the total cost
    SET v_TotalCost = v_SellingPrice * p_Quantity;

    -- Return the calculated total cost
    RETURN v_TotalCost;
END;
//

DELIMITER ;


-- Procedure to Purchase a product

DELIMITER //
CREATE PROCEDURE PurchaseProduct(
    IN p_ProductID INT,
    IN p_CustomerID INT,
    IN p_Quantity INT,
    IN p_PaymentMethod VARCHAR(50)
)
BEGIN
    DECLARE v_Stock INT;
    DECLARE v_SellingPrice DECIMAL(10, 2);
    DECLARE v_TotalCost DECIMAL(10, 2);
    DECLARE v_CurrentSalesData JSON;
    DECLARE v_CurrentPurchaseHistory JSON;
    DECLARE v_ProductName VARCHAR(100);
    
    -- Retrieve current stock, selling price, and product name
    SELECT Stock, SellingPrice, Name, SalesData 
    INTO v_Stock, v_SellingPrice, v_ProductName, v_CurrentSalesData
    FROM Products
    WHERE ProductID = p_ProductID;
    
    -- Retrieve current purchase history
    SELECT PurchaseHistory INTO v_CurrentPurchaseHistory
    FROM Customers
    WHERE CustomerID = p_CustomerID;
    
    -- Calculate the total cost of the purchase
    SET v_TotalCost = p_Quantity * v_SellingPrice;
    
    -- Update the product stock
    UPDATE Products
    SET Stock = Stock - p_Quantity
    WHERE ProductID = p_ProductID;
    
    -- Record the sale in the Sales table
    INSERT INTO Sales (ProductID, CustomerID, Date, Quantity, TotalAmount, PaymentMethod)
    VALUES (p_ProductID, p_CustomerID, NOW(), p_Quantity, v_TotalCost, p_PaymentMethod);
    
    -- Update Products SalesData JSON column
    -- If SalesData is NULL, initialize it as a new JSON object
    IF v_CurrentSalesData IS NULL THEN
        UPDATE Products
        SET SalesData = JSON_OBJECT(
            'totalSales', p_Quantity,
            'lastSaleDate', CURRENT_DATE(),
            'lastSaleQuantity', p_Quantity,
            'lastSaleAmount', v_TotalCost,
            'salesHistory', JSON_ARRAY(
                JSON_OBJECT(
                    'date', CURRENT_DATE(),
                    'quantity', p_Quantity,
                    'amount', v_TotalCost
                )
            )
        )
        WHERE ProductID = p_ProductID;
    ELSE
        -- Update existing SalesData
        UPDATE Products
        SET SalesData = JSON_MERGE_PATCH(
            SalesData,
            JSON_OBJECT(
                'totalSales', p_Quantity + JSON_EXTRACT(SalesData, '$.totalSales'),
                'lastSaleDate', CURRENT_DATE(),
                'lastSaleQuantity', p_Quantity,
                'lastSaleAmount', v_TotalCost,
                'salesHistory', JSON_ARRAY_APPEND(
                    COALESCE(JSON_EXTRACT(SalesData, '$.salesHistory'), JSON_ARRAY()),
                    '$',
                    JSON_OBJECT(
                        'date', CURRENT_DATE(),
                        'quantity', p_Quantity,
                        'amount', v_TotalCost
                    )
                )
            )
        )
        WHERE ProductID = p_ProductID;
    END IF;
    
    -- Update Customers PurchaseHistory JSON column
    -- If PurchaseHistory is NULL, initialize it as a new JSON object
    IF v_CurrentPurchaseHistory IS NULL THEN
        UPDATE Customers
        SET PurchaseHistory = JSON_OBJECT(
            'totalPurchases', 1,
            'totalSpent', v_TotalCost,
            'lastPurchaseDate', CURRENT_DATE(),
            'purchases', JSON_ARRAY(
                JSON_OBJECT(
                    'date', CURRENT_DATE(),
                    'productId', p_ProductID,
                    'productName', v_ProductName,
                    'quantity', p_Quantity,
                    'amount', v_TotalCost,
                    'paymentMethod', p_PaymentMethod
                )
            )
        )
        WHERE CustomerID = p_CustomerID;
    ELSE
        -- Update existing PurchaseHistory
        UPDATE Customers
        SET PurchaseHistory = JSON_MERGE_PATCH(
            PurchaseHistory,
            JSON_OBJECT(
                'totalPurchases', 1 + COALESCE(JSON_EXTRACT(PurchaseHistory, '$.totalPurchases'), 0),
                'totalSpent', v_TotalCost + COALESCE(JSON_EXTRACT(PurchaseHistory, '$.totalSpent'), 0),
                'lastPurchaseDate', CURRENT_DATE(),
                'purchases', JSON_ARRAY_APPEND(
                    COALESCE(JSON_EXTRACT(PurchaseHistory, '$.purchases'), JSON_ARRAY()),
                    '$',
                    JSON_OBJECT(
                        'date', CURRENT_DATE(),
                        'productId', p_ProductID,
                        'productName', v_ProductName,
                        'quantity', p_Quantity,
                        'amount', v_TotalCost,
                        'paymentMethod', p_PaymentMethod
                    )
                )
            )
        )
        WHERE CustomerID = p_CustomerID;
    END IF;
    
    SELECT 'Successfully Purchased a product!!' AS Message;
     
    -- Set session variables
    SET @LastProductID = p_ProductID;
    SET @LastCustomerID = p_CustomerID;
END;
//
DELIMITER ;

  

  


-- Procedure to submit the feedback

DELIMITER //

CREATE PROCEDURE SubmitFeedback(
    IN p_Comments TEXT,      -- Feedback Comments
    IN p_Ratings INT         -- Feedback Ratings
)
BEGIN
    DECLARE v_ProductID INT;
    DECLARE v_CustomerID INT;

    -- Retrieve the ProductID and CustomerID from session variables
    SET v_ProductID = @LastProductID;
    SET v_CustomerID = @LastCustomerID;

    -- If no recent purchase exists, raise an error
    IF v_ProductID IS NULL OR v_CustomerID IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No recent purchase found for the user.';
    END IF;

    -- Insert the feedback into the Feedback table
    INSERT INTO Feedback (ProductID, CustomerID, Comments, Ratings, Timestamp)
    VALUES (v_ProductID, v_CustomerID, p_Comments, p_Ratings, NOW());
END;
//

DELIMITER ;



-- User can view their feedbacks


DELIMITER //

CREATE FUNCTION UserFeedbacks(
    p_customerID INT
)
RETURNS JSON
DETERMINISTIC
BEGIN
    DECLARE result JSON;

    SELECT CONCAT('[', GROUP_CONCAT(
        CONCAT(
            '{"ProductID":', ProductID,
            ',"Comments":"', Comments,
            '","Ratings":', Ratings,
            ',"Timestamp":"', Timestamp, '"}'
        )
    ), ']')
    INTO result
    FROM Feedback
    WHERE CustomerID = p_customerID;

    RETURN result;
END;
//

DELIMITER ;





-- USER MANAGEMENTS
-- View Regular Users
use demo_erp;
DELIMITER //

CREATE PROCEDURE ViewRegularUsers()
BEGIN
    -- Select all details of users with the role 'Regular'
    SELECT UserID, MailID, Name, Role
    FROM Users
    WHERE Role = 'Regular' or Role LIKE 'Inactive_%';
END;
//

DELIMITER ;

-- Activate or Deactivate the users


DELIMITER //

CREATE PROCEDURE ActivateUser(IN userEmail VARCHAR(100))
BEGIN
    -- Update the user role to remove the 'Inactive_' prefix
    UPDATE Users
    SET Role = SUBSTRING(Role, 10)
    WHERE MailID = userEmail AND Role LIKE 'Inactive_%';

    -- Print the success message after activation
    SELECT 'Activated Successfully' AS Message;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE DeactivateUser(IN userEmail VARCHAR(100))
BEGIN
    -- Update the user role to add the 'Inactive_' prefix
    UPDATE Users
    SET Role = CONCAT('Inactive_', Role)
    WHERE MailID = userEmail AND Role NOT LIKE 'Inactive_%';

    -- Print the success message after deactivation
    SELECT 'Deactivated Successfully' AS Message;
END //

DELIMITER ;

-- Product Management

-- Add the Products

DELIMITER //

CREATE  PROCEDURE AddProduct(
    IN p_Name VARCHAR(255),
    IN p_Category VARCHAR(100),
    IN p_Cost DECIMAL(10, 2),
    IN p_SellingPrice DECIMAL(10, 2),
    IN p_Stock INT,
    IN p_ReorderLevel INT,
    IN p_SupplierInfo VARCHAR(255),
    IN p_ExpiryDate DATE
)
BEGIN
    -- Insert the product details into the Products table
    INSERT INTO Products (Name, Category, Cost, SellingPrice, Stock, ReorderLevel, SupplierInfo, ExpiryDate)
    VALUES (p_Name, p_Category, p_Cost, p_SellingPrice, p_Stock, p_ReorderLevel, p_SupplierInfo, p_ExpiryDate);
	
    SELECT 'Successfully Added the Product' AS Message;
    
END;
//

DELIMITER ;

-- Update a Product
DELIMITER //

CREATE PROCEDURE EditProduct(
    IN p_ProductID INT,
    IN p_Name VARCHAR(255),
    IN p_Category VARCHAR(100),
    IN p_Cost DECIMAL(10, 2),
    IN p_SellingPrice DECIMAL(10, 2),
    IN p_Stock INT,
    IN p_ReorderLevel INT,
    IN p_SupplierInfo VARCHAR(255),
    IN p_ExpiryDate DATE
)
BEGIN
    -- Update the product details based on ProductID
    UPDATE Products
    SET 
        Name = IFNULL(p_Name, Name),                -- Only update if new value is provided
        Category = IFNULL(p_Category, Category),    -- Only update if new value is provided
        Cost = IFNULL(p_Cost, Cost),                -- Only update if new value is provided
        SellingPrice = IFNULL(p_SellingPrice, SellingPrice), -- Only update if new value is provided
        Stock = IFNULL(p_Stock, Stock),             -- Only update if new value is provided
        ReorderLevel = IFNULL(p_ReorderLevel, ReorderLevel), -- Only update if new value is provided
        SupplierInfo = IFNULL(p_SupplierInfo, SupplierInfo), -- Only update if new value is provided
        ExpiryDate = IFNULL(p_ExpiryDate, ExpiryDate) -- Only update if new value is provided
    WHERE ProductID = p_ProductID;

    -- Check if any rows were updated
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product not found.';
	ELSE
		SELECT 'Edited Successfully' AS Message;
    END IF;
END;
//

DELIMITER ;



-- Delete a Product
DELIMITER //
CREATE PROCEDURE DeleteProduct(
    IN p_ProductID INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error occurred while deleting product';
    END;

    START TRANSACTION;
        -- Delete feedback records
        DELETE FROM Feedback WHERE ProductID = p_ProductID;
        
        -- Delete sales records
        DELETE FROM Sales WHERE ProductID = p_ProductID;
        
        -- Delete the product
        DELETE FROM Products WHERE ProductID = p_ProductID;
        
        IF ROW_COUNT() = 0 THEN
            ROLLBACK;
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Product not found.';
        ELSE
            COMMIT;
            SELECT 'Deleted Successfully' AS Message;
        END IF;
END;
//
DELIMITER ;
-- Feedback Management


-- View the Feedback

DELIMITER //

CREATE FUNCTION ViewFeedbacks(
    p_ProductID INT
)
RETURNS JSON
DETERMINISTIC
BEGIN
    DECLARE result JSON;

    SELECT CONCAT('[', GROUP_CONCAT(
        CONCAT(
            '{"FeedbackID":', FeedbackID,
            ',"ProductID":', ProductID,
            ',"CustomerID":', CustomerID,
            ',"Comments":"', Comments,
            '","Ratings":', Ratings,
            ',"Timestamp":"', Timestamp, '"}'
        )
    ), ']')
    INTO result
    FROM Feedback
    WHERE ProductID = IFNULL(p_ProductID, ProductID);

    RETURN result;
END;
//

DELIMITER ;


-- Responding to the feedback
DELIMITER //

CREATE TRIGGER RespondToFeedback
AFTER INSERT ON Feedback
FOR EACH ROW
BEGIN
    -- Signal a custom message as feedback response
    SIGNAL SQLSTATE '01000'
SET MESSAGE_TEXT = 'Your feedback has been successfully submitted. Thank you!';

END;
//

DELIMITER ;


DELIMITER //
CREATE PROCEDURE EditCustomerDetails(
    IN p_CustomerID INT,
    IN p_Name VARCHAR(100),
    IN p_Email VARCHAR(100),
    IN p_Phone VARCHAR(15),
    IN p_Address TEXT
)
BEGIN
    DECLARE v_CustomerID INT ; -- Variable to store the CustomerID

    -- Store the input CustomerID into the variable
    SET v_CustomerID = p_CustomerID;

    -- Update the customer details in the Customers table
    UPDATE Customers
    SET 
        Name = IFNULL(p_Name, Name),         -- Only update if new value is provided
        Email = IFNULL(p_Email, Email),     -- Only update if new value is provided
        Phone = IFNULL(p_Phone, Phone),     -- Only update if new value is provided
        Address = IFNULL(p_Address, Address) -- Only update if new value is provided
    WHERE CustomerID = v_CustomerID;

    -- Check if any rows were updated in the Customers table
    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Customer not found.';
    ELSE
        -- Reflect changes to Name and Email in the Users table
        UPDATE Users
        SET 
            Name = IFNULL(p_Name, Name),      -- Only update if new value is provided
            MailID = IFNULL(p_Email, MailID)  -- Only update if new value is provided
        WHERE UserID = v_CustomerID;

        -- If rows in Users table are not updated, give a warning
        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45001'
            SET MESSAGE_TEXT = 'User not found for corresponding Customer.';
        END IF;

        -- Print a success message
        SELECT 'Edited Successfully in both Customers and Users tables' AS Message;
    END IF;

END;
//

Delimiter ;

-- Sales Trend Algorithm
DELIMITER $$

CREATE FUNCTION SalesTrend()
RETURNS JSON
DETERMINISTIC
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_month VARCHAR(20);
    DECLARE v_month_sales DECIMAL(10, 2);
    DECLARE v_previous_sales DECIMAL(10, 2) DEFAULT 0;
    DECLARE v_percentage_change DECIMAL(10, 2);
    DECLARE v_result JSON DEFAULT JSON_ARRAY();

    -- Declare cursor for fetching monthly sales data
     DECLARE sales_cursor CURSOR FOR 
        SELECT DATE_FORMAT(Date, '%Y-%m') AS month, SUM(TotalAmount) AS total_sales
        FROM Sales
        GROUP BY DATE_FORMAT(Date, '%Y-%m')
        ORDER BY month;

    -- Handler for cursor loop
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN sales_cursor;

    -- Loop through the cursor
    read_loop: LOOP
        FETCH sales_cursor INTO v_month, v_month_sales;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Calculate percentage change
        IF v_previous_sales > 0 THEN
            SET v_percentage_change = ((v_month_sales - v_previous_sales) * 100) / v_month_sales;
        ELSE
            SET v_percentage_change = NULL; -- No percentage change for the first month
        END IF;

        -- Append the result to JSON array
        SET v_result = JSON_ARRAY_APPEND(v_result, '$', JSON_OBJECT('month', v_month, 'percentage_change', v_percentage_change));

        -- Update previous month's sales
        SET v_previous_sales = v_month_sales;
    END LOOP;

    CLOSE sales_cursor;

    -- Check if the algorithm entry exists in the Logs table
    IF EXISTS (SELECT 1 FROM Logs WHERE AlgorithmName = 'SalesTrend') THEN
        -- Update the existing entry
        UPDATE Logs 
        SET Timestamp = CURRENT_TIMESTAMP, Results = v_result 
        WHERE AlgorithmName = 'SalesTrend';
    ELSE
        -- Insert a new entry
        INSERT INTO Logs (AlgorithmName, Timestamp, Results) 
        VALUES ('SalesTrend', CURRENT_TIMESTAMP, v_result);
    END IF;

    -- Return the result as JSON
    RETURN v_result;

END$$

DELIMITER ;


-- ABC Classification 
DELIMITER $$

CREATE FUNCTION ABC_Classification()
RETURNS JSON
DETERMINISTIC
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_product_id INT;
    DECLARE v_product_name VARCHAR(100);
    DECLARE v_acv DECIMAL(10, 2);
    DECLARE v_total_acv DECIMAL(10, 2);
    DECLARE v_cumulative_acv DECIMAL(10, 2) DEFAULT 0;
    DECLARE v_percentage DECIMAL(5, 2);
    DECLARE v_class VARCHAR(1);
    DECLARE v_result JSON DEFAULT JSON_ARRAY();
    
    -- Declare a cursor to select products, their names, and ACV in descending order
    DECLARE product_cursor CURSOR FOR 
        SELECT S.ProductID, P.Name, SUM(S.TotalAmount) AS ACV
        FROM Sales S
        JOIN Products P ON S.ProductID = P.ProductID
        GROUP BY S.ProductID, P.Name
        ORDER BY ACV DESC;

    -- Handler to manage the end of the cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Calculate total ACV of all products
    SELECT SUM(TotalAmount) INTO v_total_acv FROM Sales;
    
    OPEN product_cursor;

    -- Loop through the products
    read_loop: LOOP
        FETCH product_cursor INTO v_product_id, v_product_name, v_acv;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Calculate cumulative ACV
        SET v_cumulative_acv = v_cumulative_acv + v_acv;
        
        -- Calculate the percentage of cumulative ACV
        SET v_percentage = (v_cumulative_acv / v_total_acv) * 100;

        -- Classify product based on cumulative percentage
        IF v_percentage <= 75 THEN
            SET v_class = 'A';
        ELSEIF v_percentage <= 90 THEN
            SET v_class = 'B';
        ELSE
            SET v_class = 'C';
        END IF;

        -- Append product, name, and class to the result JSON
        SET v_result = JSON_ARRAY_APPEND(v_result, '$', JSON_OBJECT('product', v_product_id, 'name', v_product_name, 'class', v_class));
    END LOOP;

    CLOSE product_cursor;

    -- Insert results into the Logs table
     IF EXISTS (SELECT 1 FROM Logs WHERE AlgorithmName = 'ABC Classification') THEN
        -- Update the existing entry
        UPDATE Logs 
        SET Timestamp = CURRENT_TIMESTAMP, Results = v_result 
        WHERE AlgorithmName = 'ABC Classification';
    ELSE
        -- Insert a new entry
        INSERT INTO Logs (AlgorithmName, Timestamp, Results) 
        VALUES ('ABC Classification', CURRENT_TIMESTAMP, v_result);
    END IF;

    -- Return the final result as JSON
    RETURN v_result;
END$$

DELIMITER ;


-- Demand Forcasting Algorithm
DELIMITER $$

CREATE FUNCTION GetSalesData(productID INT) RETURNS JSON DETERMINISTIC
BEGIN
    DECLARE salesData JSON DEFAULT JSON_ARRAY();
    DECLARE done INT DEFAULT FALSE;
    DECLARE curr_date DATE;
    DECLARE curr_quantity INT;
    
    -- Updated cursor to match your Sales table structure
    DECLARE sales_cursor CURSOR FOR 
        SELECT 
            DATE_FORMAT(s.Date, '%Y-%m-01') as SaleDate,  -- Group by the first day of the month
            SUM(s.Quantity) as TotalQuantity
        FROM Sales s
        WHERE s.ProductID = productID
        GROUP BY DATE_FORMAT(s.Date, '%Y-%m-01')  -- Group by the first day of the month
        ORDER BY SaleDate;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN sales_cursor;
    
    read_loop: LOOP
        FETCH sales_cursor INTO curr_date, curr_quantity;
        
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SET salesData = JSON_ARRAY_APPEND(salesData, '$', 
            JSON_OBJECT(
                'Month', EXTRACT(MONTH FROM curr_date),
                'TotalQuantity', curr_quantity
            ));
            
    END LOOP;
    
    CLOSE sales_cursor;
    
    RETURN salesData;
END$$

DELIMITER ;

DELIMITER $$

 
use demo_erp;  
DELIMITER $$

CREATE FUNCTION ForecastDemand() RETURNS JSON DETERMINISTIC
BEGIN
    -- Variable Declarations
    DECLARE pid INT;
    DECLARE pname VARCHAR(100);
    DECLARE currDemand DECIMAL(10, 2);
    DECLARE salesData JSON;
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE demandArray JSON DEFAULT JSON_ARRAY();

    -- Cursor Declaration
    DECLARE productCursor CURSOR FOR 
        SELECT ProductID, Name FROM Products;

    -- Handler Declaration
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Create a temporary table to store demand predictions
    DROP TEMPORARY TABLE IF EXISTS temp_demand_predictions;
    CREATE TEMPORARY TABLE temp_demand_predictions (
        ProductID INT,
        ProductName VARCHAR(100),
        PredictedDemand DECIMAL(10, 2)
    );

    -- Open the cursor
    OPEN productCursor;

    -- Loop through each product
    productLoop: LOOP
        FETCH productCursor INTO pid, pname;
        IF done THEN LEAVE productLoop; END IF;
        
        -- Get sales data and calculate demand
        SET salesData = GetSalesData(pid);
        SET currDemand = CalculateDemand(salesData);
        
        -- Insert the demand data into the temporary table
        INSERT INTO temp_demand_predictions (ProductID, ProductName, PredictedDemand)
        VALUES (pid, pname, ROUND(currDemand, 2));
    END LOOP;

    -- Close the cursor
    CLOSE productCursor;

    -- Select the top 5 products with the highest predicted demand
    SELECT JSON_ARRAYAGG(
        JSON_OBJECT(
            'ProductID', ProductID,
            'ProductName', ProductName,
            'PredictedDemand', PredictedDemand
        )
    ) INTO demandArray
    FROM (
        SELECT ProductID, ProductName, PredictedDemand
        FROM temp_demand_predictions
        ORDER BY PredictedDemand DESC
        LIMIT 5
    ) AS top_products;

    -- Drop the temporary table
    DROP TEMPORARY TABLE temp_demand_predictions;

    -- Log the results before returning
    
    IF EXISTS (SELECT 1 FROM Logs WHERE AlgorithmName = 'Demand Forecast') THEN
        -- Update the existing entry
        UPDATE Logs 
        SET Timestamp = CURRENT_TIMESTAMP, Results = COALESCE(demandArray, JSON_ARRAY()) 
        WHERE AlgorithmName = 'Demand Forecast';
    ELSE
        -- Insert a new entry
        INSERT INTO Logs (AlgorithmName, Timestamp, Results) 
        VALUES ('Demand Forecast', CURRENT_TIMESTAMP, COALESCE(demandArray, JSON_ARRAY()));
    END IF;
    
    RETURN COALESCE(demandArray, JSON_ARRAY());  
END$$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION CalculateDemand(salesData JSON) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE sumX, sumY, sumXY, sumX2, b0, b1 DECIMAL(10,2) DEFAULT 0;
    DECLARE i, n INT DEFAULT 0;
    DECLARE curr_month DECIMAL(10,2);
    DECLARE demand DECIMAL(10,2);
    
    WHILE i < JSON_LENGTH(salesData) DO
        -- Extract the actual month number from salesData
        SET curr_month = CAST(JSON_UNQUOTE(JSON_EXTRACT(salesData, CONCAT('$[', i, '].Month'))) AS DECIMAL(10,2));
        
        SET sumX = sumX + curr_month;
        SET sumY = sumY + CAST(JSON_UNQUOTE(JSON_EXTRACT(salesData, CONCAT('$[', i, '].TotalQuantity'))) AS DECIMAL(10,2));
        SET sumXY = sumXY + (curr_month * CAST(JSON_UNQUOTE(JSON_EXTRACT(salesData, CONCAT('$[', i, '].TotalQuantity'))) AS DECIMAL(10,2)));
        SET sumX2 = sumX2 + POWER(curr_month, 2);
        SET n = n + 1;
        SET i = i + 1;
    END WHILE;
    
    IF n >= 1 THEN
        SET b1 = (n * sumXY - sumX * sumY) / NULLIF((n * sumX2 - POWER(sumX, 2)), 0);
        IF b1 IS NOT NULL THEN
            SET b0 = (sumY - b1 * sumX) / n;
            -- Predict for next month after the last month in the data
            SET demand = b0 + b1 * (curr_month + 1);
            RETURN demand;
        END IF;
    END IF;
    
    RETURN -1;
END$$

DELIMITER ;

DELIMITER $$
CREATE FUNCTION GetProfitabilityAnalysis() RETURNS json
    DETERMINISTIC
BEGIN
    DECLARE allProfitProducts JSON;
    DECLARE result JSON;

    -- Create a temporary table to store all profitability data
    DROP TEMPORARY TABLE IF EXISTS temp_all_profit_products;
    CREATE TEMPORARY TABLE temp_all_profit_products (
        ProductID INT,
        ProductName VARCHAR(100),
        Profit DECIMAL(10, 2),
        ProfitMargin DECIMAL(10, 2)
    );

    -- Insert profitability data for all products into the temporary table
    INSERT INTO temp_all_profit_products (ProductID, ProductName, Profit, ProfitMargin)
    SELECT 
        p.ProductID,
        p.Name,
        (p.SellingPrice * SUM(s.Quantity) - p.Cost * SUM(s.Quantity)) AS Profit,
        ((p.SellingPrice * SUM(s.Quantity) - p.Cost * SUM(s.Quantity)) / 
         (p.SellingPrice * SUM(s.Quantity))) * 100 AS ProfitMargin
    FROM 
        Products p
    JOIN 
        Sales s ON p.ProductID = s.ProductID
    GROUP BY 
        p.ProductID
    ORDER BY 
        Profit DESC;

    -- Aggregate all profitability data into a JSON array
    SELECT JSON_ARRAYAGG(
        JSON_OBJECT(
            'ProductID', ProductID,
            'ProductName', ProductName,
            'Profit', Profit,
            'ProfitMargin', ProfitMargin
        )
    ) INTO allProfitProducts
    FROM temp_all_profit_products;

    -- Prepare the result JSON
    SET result = JSON_OBJECT(
        'AllProfitProducts', allProfitProducts
    );

    -- Insert the results into the Logs table
    IF EXISTS (SELECT 1 FROM Logs WHERE AlgorithmName = 'ProfitabilityAnalysis') THEN
        -- Update the existing entry
        UPDATE Logs 
        SET Timestamp = CURRENT_TIMESTAMP, Results = result 
        WHERE AlgorithmName = 'ProfitabilityAnalysis';
    ELSE
        -- Insert a new entry
        INSERT INTO Logs (AlgorithmName, Timestamp, Results) 
        VALUES ('ProfitabilityAnalysis', CURRENT_TIMESTAMP, result);
    END IF;

    -- Return the results as JSON
    RETURN result;
END$$
DELIMITER ;

DELIMITER $$
CREATE  FUNCTION GetProfitabilityAnalysis3() RETURNS json
    DETERMINISTIC
BEGIN
    DECLARE result JSON;

    -- Create a temporary table to store all profitability data
    DROP TEMPORARY TABLE IF EXISTS temp_all_profit_products;
    CREATE TEMPORARY TABLE temp_all_profit_products (
        ProductID INT,
        ProductName VARCHAR(100),
        Profit DECIMAL(10, 2),
        ProfitMargin DECIMAL(10, 2)
    );

    -- Insert profitability data for all products into the temporary table
    INSERT INTO temp_all_profit_products (ProductID, ProductName, Profit, ProfitMargin)
    SELECT 
        p.ProductID,
        p.Name,
        (p.SellingPrice * SUM(s.Quantity) - p.Cost * SUM(s.Quantity)) AS Profit,
        ((p.SellingPrice * SUM(s.Quantity) - p.Cost * SUM(s.Quantity)) / 
         (p.SellingPrice * SUM(s.Quantity))) * 100 AS ProfitMargin
    FROM 
        Products p
    JOIN 
        Sales s ON p.ProductID = s.ProductID
    GROUP BY 
        p.ProductID
    ORDER BY 
        Profit DESC;

    -- Aggregate all profitability data into a JSON array with the correct column order
    SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'ProductID', CAST(ProductID AS UNSIGNED),  -- Ensure ProductID is an integer
                'ProductName', ProductName,
                'Profit', Profit,
                'ProfitMargin', ProfitMargin
            )
    ) INTO result
    FROM temp_all_profit_products;

    -- Insert the results into the Logs table
    IF EXISTS (SELECT 1 FROM Logs WHERE AlgorithmName = 'ProfitabilityAnalysis') THEN
        -- Update the existing entry
        UPDATE Logs 
        SET Timestamp = CURRENT_TIMESTAMP, Results = result 
        WHERE AlgorithmName = 'ProfitabilityAnalysis';
    ELSE
        -- Insert a new entry
        INSERT INTO Logs (AlgorithmName, Timestamp, Results) 
        VALUES ('ProfitabilityAnalysis', CURRENT_TIMESTAMP, result);
    END IF;

    -- Return the results as JSON
    RETURN result;
END$$
DELIMITER ;



DELIMITER $$
CREATE  FUNCTION RatioTurnoverYearly() RETURNS json
    DETERMINISTIC
BEGIN
    -- Declare variables for opening inventory, closing inventory, COGS, and average inventory
    DECLARE v_year INT;
    DECLARE v_opening_inventory INT DEFAULT 0;
    DECLARE v_closing_inventory INT DEFAULT 0;
    DECLARE v_cogs INT DEFAULT 0;
    DECLARE v_average_inventory INT DEFAULT 0;
    DECLARE v_inventory_turnover_ratio DECIMAL(10,2) DEFAULT 0;
    DECLARE v_turnover_status VARCHAR(20);
    DECLARE v_json_result JSON;
    DECLARE v_json_array JSON;
    DECLARE done INT DEFAULT FALSE;
    
    -- Declare a cursor to iterate over each year in the Sales table
    DECLARE cur CURSOR FOR 
        SELECT DISTINCT YEAR(Date) AS SaleYear 
        FROM Sales 
        ORDER BY SaleYear;
        
    -- Declare a handler to set done to TRUE when there are no more rows
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    -- Initialize the JSON array
    SET v_json_array = JSON_ARRAY();
    
    -- Open the cursor
    OPEN cur;
    
    read_loop: LOOP
        -- Fetch the next year
        FETCH cur INTO v_year;
        
        -- Exit the loop if there are no more years
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Step 1: Calculate COGS (Cost of Goods Sold) for the year
        SELECT SUM(p.Cost * s.Quantity) 
        INTO v_cogs
        FROM Sales s
        JOIN Products p ON s.ProductID = p.ProductID
        WHERE YEAR(s.Date) = v_year;
        
        -- Step 2: Calculate Closing Inventory for the year
        SELECT SUM(p.Stock)  
        INTO v_closing_inventory
        FROM Products p;
        
        -- Step 3: Calculate Opening Inventory for the year
        -- Assuming opening inventory is the stock at the start of the year
        SELECT SUM(p.Stock) - IFNULL(SUM(s.Quantity), 0) 
        INTO v_opening_inventory
        FROM Products p
        LEFT JOIN Sales s ON p.ProductID = s.ProductID AND YEAR(s.Date) < v_year;
        
        -- Step 4: Calculate Average Inventory for the year
        SET v_average_inventory = (v_opening_inventory + v_closing_inventory) / 2;
        
        -- Step 5: Calculate Inventory Turnover Ratio for the year
        IF v_average_inventory != 0 THEN
            SET v_inventory_turnover_ratio = v_cogs / v_average_inventory;
        ELSE
            SET v_inventory_turnover_ratio = 0;
        END IF;
        
        -- Step 6: Determine if the turnover is high or low for the year
        IF v_inventory_turnover_ratio > 5 THEN
            SET v_turnover_status = 'High Turnover';
        ELSE
            SET v_turnover_status = 'Low Turnover';
        END IF;
        
        -- Prepare the JSON result for the year
        SET v_json_result = JSON_OBJECT(
            'Year', v_year,
            'Ratio', v_inventory_turnover_ratio,
            'TurnoverStatus', v_turnover_status
        );
        
        -- Add the JSON result to the JSON array
        SET v_json_array = JSON_ARRAY_APPEND(v_json_array, '$', v_json_result);
    END LOOP;
    
    -- Close the cursor
    CLOSE cur;
    
    -- Insert the result into the Logs table
    IF EXISTS (SELECT 1 FROM Logs WHERE AlgorithmName = 'RatioTurnoverYearly') THEN
        -- Update the existing entry
        UPDATE Logs 
        SET Timestamp = CURRENT_TIMESTAMP, Results = v_json_array 
        WHERE AlgorithmName = 'RatioTurnoverYearly';
    ELSE
        -- Insert a new entry
        INSERT INTO Logs (AlgorithmName, Timestamp, Results) 
        VALUES ('RatioTurnoverYearly', CURRENT_TIMESTAMP, v_json_array);
    END IF;
    
    -- Return the JSON array
    RETURN v_json_array;
END
$$
DELIMITER 