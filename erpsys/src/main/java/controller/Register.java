package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.RegPojo;

@WebServlet("/Register")
public class Register extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String password = request.getParameter("pword");
        	
        
        // Validate password (should not be numbers only)
        if (password != null && password.matches("^\\d+$")) {
            request.setAttribute("error", "Password cannot contain only numbers & minimum character 6");
            request.getRequestDispatcher("Register.jsp").forward(request, response);
            return;
        }
        
       
        
        
        // If validation passes, proceed with registration
        RegPojo pojo = new RegPojo();
        pojo.setMail(request.getParameter("mail"));
        pojo.setName(request.getParameter("name"));
        pojo.setPword(password);
        pojo.setRole(request.getParameter("role"));
        
        String result = pojo.registerUser(pojo);
        
        if ("Successfully Registered!!".equals(result)) {
            response.sendRedirect("login.jsp");
        } else {
            request.getRequestDispatcher("Register.jsp").forward(request, response);
        }
    }
}