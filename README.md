# ERP System - E-Commerce & Inventory Management

A comprehensive web-based Enterprise Resource Planning system built with Java EE, designed for retail businesses to manage their e-commerce operations and inventory efficiently.

## Project Overview

This application provides:

- **E-Commerce Functionality**: Product browsing, shopping cart, user authentication, and order processing
- **Inventory Management**: Real-time stock tracking, reorder level monitoring, and expiry date management
- **Analytics Dashboard**: Sales trend analysis, ABC classification, demand forecasting, and profitability metrics
- **Admin Controls**: Product management, user management, report generation, and feedback monitoring
- **Algorithm Integration**: Inventory optimization algorithms for better stock management

## Technology Stack

- **Backend**: Java (Jakarta EE / Servlet 5.0)
- **Frontend**: JSP, HTML, CSS, JavaScript
- **Database**: MySQL
- **Server**: Apache Tomcat (or any Jakarta EE 9+ compatible server)
- **Build Tool**: Eclipse IDE project structure

## Prerequisites

Before running this project, ensure you have the following installed:

- **JDK 11 or higher** (Jakarta EE 9+ requires Java 11+)
- **MySQL Server** (5.7 or higher)
- **Apache Tomcat 10.x** (for Jakarta EE 9+) or compatible servlet container
- **MySQL JDBC Driver** (`mysql-connector-j` or `mysql-connector-java`)

## Database Setup

1. Start your MySQL server

2. Create the database and tables by running the SQL script:
   ```bash
   mysql -u root -p < database.sql
   ```
   Or manually execute the SQL commands from `database.sql` in your MySQL client

3. Update database credentials in `src/main/java/db/GetConnection.java`:
   ```java
   connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/demo_erp","root","YOUR_PASSWORD");
   ```

## Project Setup

### Option 1: Using Eclipse IDE

1. Clone or download this repository

2. Import the project in Eclipse:
   - File → Import → Existing Projects into Workspace
   - Select the `erpsys` folder
   - Click Finish

3. Add required libraries to the project:
   - **Jakarta Servlet API**: Right-click project → Build Path → Add External JARs
     - Add `jakarta.servlet-api-5.0.0.jar` (or download from Maven Central)
   - **MySQL JDBC Driver**: Add `mysql-connector-j-8.x.x.jar`

4. Configure Tomcat server in Eclipse:
   - Window → Preferences → Server → Runtime Environments
   - Add your Tomcat 10.x installation
   - Right-click project → Properties → Targeted Runtimes → Select Tomcat

5. Run the project:
   - Right-click project → Run As → Run on Server
   - Select your configured Tomcat server
   - The application will open in the browser

### Option 2: Manual Deployment

1. Ensure all dependencies are in `WEB-INF/lib/`:
   - `jakarta.servlet-api-5.0.0.jar`
   - `mysql-connector-j-8.x.x.jar`

2. Compile the Java source files:
   ```bash
   javac -cp "WEB-INF/lib/*" -d build/classes src/main/java/**/*.java
   ```

3. Create a WAR file or deploy the `webapp` folder directly to Tomcat's `webapps` directory

4. Start Tomcat server:
   ```bash
   # Windows
   catalina.bat start
   
   # Linux/Mac
   ./catalina.sh start
   ```

5. Access the application at `http://localhost:8080/erpsys/`

## Application URLs

- **Home Page**: `http://localhost:8080/erpsys/HomePage`
- **Login**: `http://localhost:8080/erpsys/login.jsp`
- **Register**: `http://localhost:8080/erpsys/Register.jsp`
- **Admin Dashboard**: `http://localhost:8080/erpsys/Admin_Dashboard` 

## Default Database Configuration

- **Host**: localhost
- **Port**: 3306
- **Database Name**: demo_erp
- **Username**: root
- **Password**: 1234 (change this in `GetConnection.java`)
