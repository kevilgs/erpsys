package controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.ProductPojo;
import operations.Browse_operation.Homepage_Implementation;
import operations.Browse_operation.Homepage_Interface;

/**
 * Servlet implementation class HomePage
 */
@WebServlet("/HomePage")
public class HomePage extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private final Homepage_Interface homepage_Interface = new Homepage_Implementation();
       
   
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    // Get error parameter if any
	    String error = request.getParameter("error");
	    if (error != null && error.equals("outofstock")) {
	        request.setAttribute("errorMessage", "Sorry, this item is out of stock!");
	    }

	    List<String> categories = homepage_Interface.getAllCategories();
	    request.setAttribute("categories", categories);

	    // Get the category parameter from the request (if any)
	    String category = request.getParameter("Category");

	    // Fetch products, optionally filtered by category
	    List<ProductPojo> products;
	    if (category != null && !category.isEmpty()) {
	        products = homepage_Interface.getProductsByCategory(category);
	    } else {
	        products = homepage_Interface.getAllProducts();
	    }
	    request.setAttribute("products", products);

	    // Forward the request to the JSP
	    RequestDispatcher dispatcher = request.getRequestDispatcher("Home.jsp");
	    dispatcher.forward(request, response);
	}
}
