package controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.admin.Admin_Dashoboard_Pojo;

import java.io.IOException;

/**
 * Servlet implementation class Admin_Dashboard
 */
@WebServlet("/Admin_Dashboard")
public class Admin_Dashboard extends HttpServlet {
	private static final long serialVersionUID = 1L;

    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		Admin_Dashoboard_Pojo pojo = new Admin_Dashoboard_Pojo();
	     
	     
	     
	     String salesTrendData = pojo.getsalestrendata(pojo);
	     request.setAttribute("salesTrendData", salesTrendData);
	     
	     String abc_classificationData = pojo.getabclassificationdata(pojo);
	     System.out.println(abc_classificationData);
	     request.setAttribute("abc_classificationData", abc_classificationData);
	     request.setAttribute("abcData", abc_classificationData);
	     
	     
	     String demandForecast = pojo.getdemandforecastdata(pojo);
	     System.out.println(demandForecast);
	     request.setAttribute("demandForecast", demandForecast);
	     
	     String inventoryratio = pojo.getinventoryratio(pojo);
	     request.setAttribute("inventoryratio", inventoryratio);
	     
	     String profitability = pojo.getproductprofitability(pojo);
	     request.setAttribute("profitability", profitability);
	     
	     int revenue = pojo.gettoalrevenue(pojo);
	     request.setAttribute("totalRevenue", revenue);
	     System.out.println(revenue);
	     
	     int users = pojo.gettoalusers(pojo);
	     request.setAttribute("totalUsers", users);
	     
	     int products = pojo.gettoalproducts(pojo);
	     request.setAttribute("totalProducts", products);
	     
	     request.getRequestDispatcher("admin_dash.jsp").forward(request, response);
	     

	     

	     
	     
	     
	     
	    
	     
	     
	    
	     
	     
	        
		
		
		
		
		
	}

	

}
