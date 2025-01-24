package controller.admin;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.admin.FeedbackPojo;
@WebServlet("/FeedbackServlet")
public class FeedbackServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<FeedbackPojo> feedbackList = FeedbackPojo.getAllFeedback();
        req.setAttribute("feedbackList", feedbackList);
        req.getRequestDispatcher("feedback2.jsp").forward(req, resp);
    }
}