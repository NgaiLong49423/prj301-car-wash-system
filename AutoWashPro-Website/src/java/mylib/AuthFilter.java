package mylib;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // no-op
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        Object account = session != null ? session.getAttribute(AppKeys.SESSION_ACCOUNT) : null;

        if (account == null) {
            res.sendRedirect(req.getContextPath() + "/MainController?action=Login");
            return;
        }

        // Kiểm tra phân quyền (Authorization)
        String uri = req.getRequestURI();
        if (uri.startsWith(req.getContextPath() + "/admin/")) {
            String role = (String) session.getAttribute(AppKeys.SESSION_USER_ROLE);
            if (!"ADMIN".equalsIgnoreCase(role)) {
                // Khách hàng hoặc ai đó không phải ADMIN cố tình vào
                req.setAttribute(AppKeys.REQ_ERROR_AUTH, "Bạn không có quyền truy cập trang quản trị!");
                req.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // no-op
    }
}
