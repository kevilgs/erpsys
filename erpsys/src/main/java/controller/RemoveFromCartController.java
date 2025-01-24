package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItem;

@WebServlet("/RemoveFromCart")
public class RemoveFromCartController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Get productId to remove
        int productId = Integer.parseInt(request.getParameter("productId"));
        
        // Get current cart
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        
        if (cart != null) {
            // Remove item with matching productId
            cart.removeIf(item -> item.getProduct().getId() == productId);
            
            // Update cart in session
            session.setAttribute("cart", cart);
            session.setAttribute("cartCount", cart.size());
        }
        
        // Redirect back to cart page
        response.sendRedirect("ViewCart");
    }
}
