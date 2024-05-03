<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <!-- Including CSS files -->
    <link rel="stylesheet" href="navstyles.css" />
    <link rel="stylesheet" type="text/css" href="formstyles.css">
    <title>Booking Maintenance</title>
    <!-- Including jQuery library -->
    <script src="jquery.js"></script>
    <script>
        // Function to load select options with booking data
        var loadSelectBookings = function() {
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/booking/getallbookings",
                function(data) {
                    var mySelect = $("#bookingselect");
                    for (var i = 0; i < data.length; i++) {
                        var booking = data[i];
                        var myOption = document.createElement("option");
                        myOption.setAttribute("value", booking.id);
                        myOption.appendChild(document.createTextNode(booking.bookingNo));
                        mySelect[0].appendChild(myOption);
                    }
                });
        };

        // Function to retrieve booking details
        var getBooking = function(bookingId) {
            $.get("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/booking/getbooking/" + bookingId,
                function(data) {
                    var bookingDate = new Date(data.bookingDate).toISOString().substring(0, 10); // Only take the date part
                    $("#bookingId").val(data.id);
                    $("#bookingDate").val(bookingDate);
                    $("#bookingNo").val(data.bookingNo);
                    $("#travelerCount").val(data.travelerCount);
                    $("#customerId").val(data.customer ? data.customer.customerId : "");
                }
            );
        };

        // Function to build JSON data for POST and PUT requests
        var buildJSON = function(mode) {
            var bookingId = 0;
            if (mode == "update") {
                bookingId = $("#bookingId").val();
            }
            var data = {
                'id': bookingId,
                'bookingDate': $("#bookingDate").val(),
                'bookingNo': $("#bookingNo").val(),
                'travelerCount': $("#travelerCount").val(),
                'customer': {'customerId': $("#customerId").val()}
            };
            return JSON.stringify(data);
        };

        // Function to handle POST request
        var postBooking = function() {
            var jsonString = buildJSON("update");
            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/booking/postbooking",
                method: "POST",
                data: jsonString,
                dataType: "json",
                contentType: "application/json"
            }).done(function (data) {
                $("#message").html(data.message);
            }).fail(function(xhr, text, error){
                $("#message").html(text + " | " + error);
            });
        };

        // Function to handle PUT request
        var putBooking = function() {
            var jsonString = buildJSON("insert");
            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/booking/putbooking",
                method: "PUT",
                data: jsonString,
                accept: "application/json",
                dataType: "json",
                contentType: "application/json"
            }).done(function (data) {
                $("#message").html(data.message);
            }).fail(function(xhr, text, error){
                $("#message").html(text + " | " + error);
            });
        };

        // Function to handle DELETE request
        var deleteBooking = function() {
            var bookingId = $("#bookingId").val();
            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/booking/deletebooking/" + bookingId,
                method: "DELETE",
                accept: "application/json",
                dataType: "json",
                contentType: "application/json"
            }).done(function (data) {
                $("#message").html(data.message);
            }).fail(function(xhr, text, error){
                $("#message").html(text + " | " + error);
            });
        };
    </script>
</head>
<body>
<jsp:include page="navbar.jsp" />

<!-- Form for booking maintenance -->
<form>
    <select id="bookingselect" onchange="getBooking(this.value)">
        <option value="">Select a booking to see details</option>
    </select>
    <label for="bookingId">Id:</label>
    <input id="bookingId" type="text" disabled="disabled" /><br />

    <label for="bookingNo">Booking No:</label>
    <input id="bookingNo" type="text" /><br />

    <label for="bookingDate">Booking Date:</label>
    <input id="bookingDate" type="date" /><br />

    <label for="travelerCount">Traveler Count:</label>
    <input id="travelerCount" type="number" /><br />

    <label for="customerId">Customer Id:</label>
    <input id="customerId" type="number" /><br />

    <!-- Buttons for CRUD operations -->
    <button type="button" id="btnUpdate">Update</button>
    <button type="button" id="btnInsert">Insert</button>
    <button type="button" id="btnDelete">Delete</button>
</form>

<!-- Script to load bookings, handle CRUD operations -->
<script>
    $(document).ready(loadSelectBookings);
    $("#btnUpdate").click(postBooking);
    $("#btnInsert").click(putBooking);
    $("#btnDelete").click(deleteBooking);
</script>
</body>
</html>
