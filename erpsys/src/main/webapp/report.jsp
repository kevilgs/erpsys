<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Admin Dashboard</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet"
      integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
      crossorigin="anonymous"
    />
    <link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
	rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.31/jspdf.plugin.autotable.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>

    <style>
body {
    font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
    background-color: #f5f7fa;
}

.sidebar {
    background-color: #3B1E54;
    color: white;
    height: 100vh;
    position: sticky;
    top: 0;
    overflow-y: auto;
    position: fixed;
}

.sidebar .nav-link {
    color: white;
    font-size: 16px;
    margin-bottom: 10px;
    transition: background 0.3s ease;
}

.sidebar .nav-link:hover, .sidebar .nav-link.active {
    background-color: #D4BEE4;
    border-radius: 5px;
    color: #EEEEEE;
}

.content-header {
    background-color: #ecf0f1;
    padding: 15px 20px;
    border-bottom: 1px solid #bdc3c7;
}

.main-content {
    padding: 20px;
    background-color: #f9f9f9;
    min-height: calc(100vh - 61px);
    margin-left: 235px;
}



.chart-container {
    width: 600px;
    margin: 40px auto;
    background: #ffffff;
    border-radius: 12px;
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
    padding: 30px;
}

/* Enhanced Form Controls */
select {
    width: 100%;
    padding: 12px;
    border: 1px solid #dde2e8;
    border-radius: 8px;
    background-color: #fff;
    font-size: 15px;
    color: #2c3e50;
    transition: all 0.3s ease;
    margin-bottom: 20px;
    appearance: none;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%23555' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
    background-repeat: no-repeat;
    background-position: calc(100% - 12px) center;
    padding-right: 35px;
}

select:focus {
    outline: none;
    border-color: #3B1E54;
    box-shadow: 0 0 0 3px rgba(59, 30, 84, 0.1);
}

label {
    display: block;
    margin-bottom: 8px;
    font-weight: 500;
    color: #2c3e50;
    font-size: 15px;
}

button {
    background-color: #3B1E54 !important;
    color: white !important;
    padding: 12px 24px;
    border: none;
    border-radius: 8px;
    font-size: 15px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s ease;
    width: 100%;
}

button:hover {
    background-color: #4f2870 !important;
    transform: translateY(-1px);
    box-shadow: 0 4px 8px rgba(59, 30, 84, 0.2);
}

button:active {
    transform: translateY(0);
}

/* Responsive Adjustments */
@media (max-width: 768px) {
    .chart-container {
        width: 90%;
        margin: 20px auto;
        padding: 20px;
    }
    
    .main-content {
        margin-left: 0;
        padding: 15px;
    }
}
</style>

    <script>
        function jsonToExcel(jsonArray, filename = "data.xlsx") {
            if (!jsonArray || jsonArray.length === 0) return;
            try {
                const worksheet = XLSX.utils.json_to_sheet(jsonArray);
                const workbook = XLSX.utils.book_new();
                XLSX.utils.book_append_sheet(workbook, worksheet, "Sheet1");
                XLSX.writeFile(workbook, filename);
            } catch (error) {
                console.error("Excel Error:", error);
                alert("Error generating Excel. Check the console.");
            }
        }

        function jsonToPDFMake(jsonArray, algorithm, filename = "data.pdf") {
            if (!jsonArray || jsonArray.length === 0) return;

            try {
                let tableBody = [];
                let contentHeader = "Data Report";

                // Customize based on algorithm
                switch (algorithm) {
                    case "abc":
                        contentHeader = "ABC Classification Report";
                        tableBody = [
                            ["Category", "Item", "Value"], // Table header
                            ...jsonArray.map(obj => [obj.category, obj.item, obj.value])
                        ];
                        break;

                    case "salesTrend":
                        contentHeader = "Sales Trend Report";
                        tableBody = [
                            ["Month", "Sales"], // Table header
                            ...jsonArray.map(obj => [obj.month, obj.sales])
                        ];
                        break;

                    case "productProfitability":
                        contentHeader = "Product Profitability Report";
                        tableBody = [
                            ["Product ID", "Product Name", "Profit ($)", "Profit Margin (%)"], // Table header
                            ...jsonArray.map(obj => [
                                obj.ProductID,
                                obj.ProductName,
                                obj.Profit.toFixed(2),
                                obj.ProfitMargin.toFixed(2)
                            ])
                        ];
                        break;

                    default:
                        tableBody = [
                            Object.keys(jsonArray[0]),
                            ...jsonArray.map(obj => Object.values(obj))
                        ];
                }

                const documentDefinition = {
                    content: [
                        { text: contentHeader, style: 'header' },
                        {
                            table: { body: tableBody }
                        }
                    ],
                    styles: {
                        header: {
                            fontSize: 18,
                            bold: true,
                            margin: [0, 0, 0, 20]
                        }
                    }
                };

                pdfMake.createPdf(documentDefinition).download(filename);
            } catch (error) {
                console.error("pdfMake Error:", error);
                alert("Error generating PDF. Check the console.");
            }
        }

        function generateReport() {
            const algorithm = document.getElementById("algorithmSelect").value;
            const format = document.getElementById("formatSelect").value;
            const allData = {
                abc: <%= request.getAttribute("abc_classificationData") %>,
                salesTrend: <%= request.getAttribute("salesTrendData") %>,
                turnover: <%= request.getAttribute("inventoryratio") %>,
                productProfitability: <%= request.getAttribute("profitability") %>,
                demandForecast: <%= request.getAttribute("demandForecast") %>
            };

            let dataToUse;
            let filenameBase;

            switch (algorithm) {
                case "abc": dataToUse = allData.abc; filenameBase = "abc"; break;
                case "salesTrend": dataToUse = allData.salesTrend; filenameBase = "sales_trend"; break;
                case "turnover": dataToUse = allData.turnover; filenameBase = "turnover"; break;
                case "productProfitability":
                    dataToUse = allData.productProfitability.AllProfitProducts || [];
                    filenameBase = "product_profitability";
                    break;
                case "demandForecast": dataToUse = allData.demandForecast; filenameBase = "demand_forecast"; break;
                default: alert("Please select an algorithm."); return;
            }

            if (!dataToUse || dataToUse.length === 0) {
                alert("No data available for the selected algorithm.");
                return;
            }

            switch (format) {
                case "excel": jsonToExcel(dataToUse, filenameBase + ".xlsx"); break;
                case "pdf": jsonToPDFMake(dataToUse, filenameBase + "_pdfmake.pdf"); break;
                default: alert("Please select a format."); return;
            }
        }
    </script>
  </head>
  <body>
    <div class="container-fluid">
     <div class="row">
			<!-- Sidebar -->
			<nav class="col-md-3 col-lg-2 sidebar d-flex flex-column p-3">
				<h4 class="text-center mb-4">Admin Panel</h4>
				<ul class="nav flex-column">
					<li class="nav-item"><a class="nav-link"
						href="Admin_Dashboard"> <i class="bi bi-speedometer2 me-2"></i>Dashboard
					</a></li>
					<li class="nav-item"><a class="nav-link"
						href="UserManagement.jsp"> <i class="bi bi-people me-2"></i>User
							Management
					</a></li>
					<li class="nav-item"><a class="nav-link"
						href="product_management.jsp"> <i class="bi bi-box-seam me-2"></i>Product
							Management
					</a></li>
					<li class="nav-item"><a class="nav-link"
						href="algorithm_monitoring.jsp"> <i class="bi bi-cpu me-2"></i>Algorithm
							Management
					</a></li>
					<li class="nav-item"><a class="nav-link" href="FeedbackServlet">
							<i class="bi bi-chat-dots me-2"></i>Feedback Management
					</a></li>
					<li class="nav-item"><a class="nav-link active"
						href="Report_Generation"> <i
							class="bi bi-file-earmark-text me-2"></i>Report Management
					</a></li>
				</ul>
			</nav>
			 <div class="mt-auto">
       


					
				
        <!-- Main Content -->
        <div class="col-12">
        
          

          <!-- Report Generation Section -->
          <div class="main-content" id="main-content">
          
           <div class="chart-container">
            <label for="algorithmSelect">Select Algorithm:</label>
            <select id="algorithmSelect">
                <option value="">-- Select --</option>
                <option value="abc">ABC Classification</option>
                <option value="salesTrend">Sales Trend Analysis</option>
                <option value="turnover">Inventory Turnover Ratio</option>
                <option value="productProfitability">Product Profitability</option>
                <option value="demandForecast">Demand Forecast</option>
            </select><br><br>

            <label for="formatSelect">Select Format:</label>
            <select id="formatSelect">
                <option value="">-- Select --</option>
                <option value="excel">Excel</option>
                <option value="pdf">PDF</option>
            </select><br><br>

            <button onclick="generateReport()" style="color:blue">Generate Report</button>
            </div>
            
          </div>
        </div>
      </div>
    </div>
  </body>
</html>