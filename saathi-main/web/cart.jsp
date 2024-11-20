<%@ page import="java.util.Random" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="java.util.logging.Level" %>

<%
    if (session != null && session.getAttribute("cart") == null) {
        session.setAttribute("cart", "FD" + new Random().nextInt());
    }
     String source = request.getParameter("source");
    if (source != null) {
        out.print("<script>alert('Selected source: ' + source);</script>");
    } else {
        out.print("<script>alert('Source is NULL');</script>");
    }
    String product_name = request.getParameter("product_name");
    String product_price = request.getParameter("product_price");
    String rentprice = request.getParameter("rentprice");
    String productid = request.getParameter("productid");
    String img = request.getParameter("img");
    String qty = request.getParameter("qty");

    if (product_name == null || product_name.isEmpty()) {
        throw new IllegalArgumentException("Product name is missing.");
    }
    if (product_price == null || product_price.isEmpty()) {
        throw new IllegalArgumentException("Product price is missing.");
    }

    double price = 0;
    if ("rent".equalsIgnoreCase(request.getParameter("productType"))) {
        price = (rentprice != null && !rentprice.isEmpty()) ? Double.parseDouble(rentprice) : 0;
    } else {
        price = Double.parseDouble(product_price);
    }

    // Validate and parse quantity
    int quantity = 1; // Default quantity
    try {
        quantity = Integer.parseInt(qty); 
    } catch (NumberFormatException e) {
        quantity = 1; 
    }

    double total = quantity * price;

    String sql = "INSERT INTO tblshopingcart(pid, product_name, rate, img, qty, total, sessionid, dateon) " +
                 "VALUES('" + productid + "', '" + product_name + "', " + price + ", '" + img + "', " + quantity + ", " + total + ", '" + session.getAttribute("cart").toString() + "', NOW());";
    
    int r = food.DataUtility.executeDML(sql); // Execute the query

    response.sendRedirect("checkout.jsp?source="+source); // Redirect to checkout page
%>
