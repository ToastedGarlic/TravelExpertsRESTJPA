<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <!-- Including CSS files -->
    <link rel="stylesheet" href="navstyles.css" />
    <jsp:include page="navbar.jsp" />
    <link rel="stylesheet" type="text/css" href="formstyles.css">
    <title>Booking Detail Maintenance</title>
    <!-- Including jQuery library -->
    <script src="jquery.js"></script>
    <script>
        // Function to load select options with booking detail data
        var loadSelectBookingDetails = function() {
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/bookingdetail/getallbookingdetails",
                function(data) {
                    var mySelect = $("#bookingdetailselect");
                    for (var i = 0; i < data.length; i++) {
                        var detail = data[i];
                        var myOption = document.createElement("option");
                        myOption.setAttribute("value", detail.id);
                        myOption.appendChild(document.createTextNode(detail.description + " - " + detail.destination));
                        mySelect[0].appendChild(myOption);
                    }
                });
        };

        // Function to retrieve booking detail
        var getBookingDetail = function(bookingDetailId) {
            $.get("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/bookingdetail/getbookingdetail/" + bookingDetailId,
                function(data) {
                    var tripStart = new Date(data.tripStart).toISOString().substring(0, 10);
                    var tripEnd = new Date(data.tripEnd).toISOString().substring(0, 10);
                    $("#bookingDetailId").val(data.id);
                    $("#itineraryNo").val(data.itineraryNo);
                    $("#tripStart").val(tripStart);
                    $("#tripEnd").val(tripEnd);
                    $("#description").val(data.description);
                    $("#destination").val(data.destination);
                    $("#basePrice").val(data.basePrice);
                    $("#agencyCommission").val(data.agencyCommission);
                    $("#bookingId").val(data.booking ? data.booking.id : "");
                }
            );
        };

        // Function to build JSON data for POST and PUT requests
        var buildJSON = function(mode) {
            var detailId = 0;
            if (mode == "update") {
                detailId = $("#bookingDetailId").val();
            }
            var data = {
                'id': detailId,
                'itineraryNo': $("#itineraryNo").val(),
                'tripStart': $("#tripStart").val(),
                'tripEnd': $("#tripEnd").val(),
                'description': $("#description").val(),
                'destination': $("#destination").val(),
                'basePrice': $("#basePrice").val(),
                'agencyCommission': $("#agencyCommission").val(),
                'booking': {'id': $("#bookingId").val()}
            };
            return JSON.stringify(data);
        };

        // Function to handle POST request
        var postBookingDetail = function() {
            var jsonString = buildJSON("update");
            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/bookingdetail/postbookingdetail",
                method: "POST",
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

        // Function to handle PUT request
        var putBookingDetail = function() {
            var jsonString = buildJSON("insert");
            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/bookingdetail/putbookingdetail",
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
        var deleteBookingDetail = function() {
            var bookingDetailId = $("#bookingDetailId").val();
            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/bookingdetail/deletebookingdetail/" + bookingDetailId,
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

<!-- Form for booking detail maintenance -->
<form>
    <select id="bookingdetailselect" onchange="getBookingDetail(this.value)">
        <option value="">Select a booking detail to see information</option>
    </select>
    <label for="bookingDetailId">Id:</label>
    <input id="bookingDetailId" type="text" disabled="disabled" /><br />

    <label for="itineraryNo">Itinerary No:</label>
    <input id="itineraryNo" type="number" /><br />

    <label for="tripStart">Trip Start:</label>
    <input id="tripStart" type="date" /><br />

    <label for="tripEnd">Trip End:</label>
    <input id="tripEnd" type="date" /><br />

    <label for="description">Description:</label>
    <input id="description" type="text" /><br />

    <label for="destination">Destination:</label>
    <input id="destination" type="text" /><br />

    <label for="basePrice">Base Price:</label>
    <input id="basePrice" type="text" /><br />

    <label for="agencyCommission">Agency Commission:</label>
    <input id="agencyCommission" type="text" /><br />

    <label for="bookingId">Booking Id:</label>
    <input id="bookingId" type="number" /><br />

    <!-- Buttons for CRUD operations -->
    <button type="button" id="btnUpdate">Update</button>
    <button type="button" id="btnInsert">Insert</button>
    <button type="button" id="btnDelete">Delete</button>
</form>

<!-- Script to load booking details, handle CRUD operations -->
<script>
    $(document).ready(loadSelectBookingDetails);
    $("#btnUpdate").click(postBookingDetail);
    $("#btnInsert").click(putBookingDetail);
    $("#btnDelete").click(deleteBookingDetail);
</script>
</body>
</html>
