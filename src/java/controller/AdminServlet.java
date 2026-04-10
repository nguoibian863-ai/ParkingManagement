package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import dal.ParkingLotDao;
import dal.ParkingSlotDao;
import model.ParkingLot;
import model.ParkingSlot;

public class AdminServlet extends HttpServlet {

    private final ParkingSlotDao slotDao = new ParkingSlotDao();
    private final ParkingLotDao lotDao = new ParkingLotDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<ParkingSlot> slotList = slotDao.getAll();
        List<ParkingLot> lotList = lotDao.getAll();
        request.setAttribute("slotList", slotList);
        request.setAttribute("lotList", lotList);
        request.setAttribute("lotDao", lotDao);
        request.getRequestDispatcher("view/admin.jsp").forward(request, response);
    }
}
