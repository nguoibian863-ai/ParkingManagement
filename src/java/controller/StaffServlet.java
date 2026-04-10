package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import dal.ParkingLotDao;
import dal.ParkingSlotDao;
import model.ParkingLot;
import model.ParkingSlot;
import model.User;

public class StaffServlet extends HttpServlet {

    private final ParkingSlotDao slotDao = new ParkingSlotDao();
    private final ParkingLotDao lotDao = new ParkingLotDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User acc = (User) request.getSession().getAttribute("account");
        List<ParkingSlot> slotList;
        ParkingLot currentLot = null;
        if (acc != null && "STAFF".equalsIgnoreCase(acc.getRole()) && acc.getLotId() != null) {
            slotList = slotDao.getByLotId(acc.getLotId());
            currentLot = lotDao.getById(acc.getLotId());
        } else {
            slotList = slotDao.getAll();
        }
        request.setAttribute("slotList", slotList);
        request.setAttribute("lotList", lotDao.getAll());
        request.setAttribute("lotDao", lotDao);
        request.setAttribute("currentLot", currentLot);
        request.getRequestDispatcher("view/staff.jsp").forward(request, response);
    }
}
