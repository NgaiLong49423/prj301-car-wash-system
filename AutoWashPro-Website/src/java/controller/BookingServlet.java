package controller;

import dao.BookingDAO;
import dao.MembershipTierDAO;
import dao.ServiceDAO;
import dao.VehicleDAO;
import dto.BookingResultDTO;
import dto.MembershipTierDTO;
import dto.ServiceDTO;
import dto.User;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mylib.AppKeys;

@WebServlet(name = "BookingServlet", urlPatterns = {"/booking"})
public class BookingServlet extends HttpServlet {

    private final VehicleDAO vehicleDAO = new VehicleDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();
    private final MembershipTierDAO tierDAO = new MembershipTierDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User account = getAccount(request);
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
            return;
        }

        loadBookingPageData(request, account.getId());
        request.getRequestDispatcher("/booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        User account = getAccount(request);
        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/MainController?action=Login");
            return;
        }

        try {
            int vehicleId = parseInt(request.getParameter("vehicleId"));
            Date bookingDate = Date.valueOf(request.getParameter("bookingDate"));
            Time bookingTime = Time.valueOf(normalizeTime(request.getParameter("bookingTime")));
            int[] serviceIds = parseServiceIds(request.getParameterValues("serviceIds"));
            if (serviceIds.length == 0) {
                forwardWithError(request, response, account.getId(), "Vui long chon it nhat mot dich vu.");
                return;
            }

            if (bookingDate.toLocalDate().isBefore(LocalDate.now())) {
                forwardWithError(request, response, account.getId(), "Vui long chon ngay dat lich tu hom nay tro di.");
                return;
            }

            if (bookingDate.toLocalDate().equals(LocalDate.now())
                    && bookingTime.toLocalTime().isBefore(LocalTime.now().plusMinutes(30))) {
                forwardWithError(request, response, account.getId(), "Vui long dat lich truoc thoi gian hien tai it nhat 30 phut.");
                return;
            }

            List<ServiceDTO> selectedServices = serviceDAO.getServicesByIds(serviceIds);
            if (selectedServices.size() != serviceIds.length) {
                forwardWithError(request, response, account.getId(), "Danh sach dich vu khong hop le.");
                return;
            }

            MembershipTierDTO tier = tierDAO.getTierByCustomerId(account.getId());
            BookingResultDTO result = bookingDAO.createPriorityBooking(
                    account.getId(), vehicleId, bookingDate, bookingTime, selectedServices, tier);

            request.setAttribute("BOOKING_RESULT", result);
            request.setAttribute("MEMBER_TIER_DETAIL", tier);
            request.getRequestDispatcher("/booking-result.jsp").forward(request, response);
        } catch (Exception e) {
            log("Booking submission failed", e);
            forwardWithError(request, response, account.getId(), "Loi dat lich: " + (e.getMessage() != null ? e.getMessage() : "Du lieu khong hop le. Vui long kiem tra lai."));
        }
    }

    private void loadBookingPageData(HttpServletRequest request, int customerId) {
        List<?> vehicles = vehicleDAO.getCars(customerId);
        request.setAttribute("VEHICLE_LIST", vehicles);
        request.setAttribute("listVehicles", vehicles);
        request.setAttribute("SERVICE_LIST", serviceDAO.getAllServices());
        request.setAttribute("MEMBER_TIER_DETAIL", tierDAO.getTierByCustomerId(customerId));
        request.setAttribute("RECENT_BOOKINGS", bookingDAO.getRecentBookingsByCustomer(customerId));
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, int customerId, String message)
            throws ServletException, IOException {
        request.setAttribute(AppKeys.REQ_ERROR, message);
        loadBookingPageData(request, customerId);
        request.getRequestDispatcher("/booking.jsp").forward(request, response);
    }

    private User getAccount(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object account = session != null ? session.getAttribute(AppKeys.SESSION_ACCOUNT) : null;
        return account instanceof User ? (User) account : null;
    }

    private int parseInt(String value) {
        return Integer.parseInt(value);
    }

    private int[] parseServiceIds(String[] values) {
        if (values == null || values.length == 0) {
            return new int[0];
        }
        List<Integer> ids = new ArrayList<>();
        for (String value : values) {
            ids.add(Integer.parseInt(value));
        }
        int[] result = new int[ids.size()];
        for (int i = 0; i < ids.size(); i++) {
            result[i] = ids.get(i);
        }
        return result;
    }

    private String normalizeTime(String value) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException("Missing time");
        }
        String normalized = value.trim();
        if (normalized.length() == 5) {
            return normalized + ":00";
        }
        return normalized;
    }
}
