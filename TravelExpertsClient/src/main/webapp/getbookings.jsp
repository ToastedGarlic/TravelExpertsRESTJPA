<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Booking Maintenance</title>
    <link rel="stylesheet" href="navstyles.css" />
    <jsp:include page="navbar.jsp" />
    <link rel="stylesheet" type="text/css" href="formstyles.css">
    <script src="jquery.js"></script>
    <script>
        // Function to load select options with booking data
        function loadSelectBookings() {
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/booking/getallbookings", function(data) {
                var mySelect = $("#bookingselect").empty();
                mySelect.append('<option value="">Select a booking to see details</option>');
                $.each(data, function(index, booking) {
                    mySelect.append($('<option>').text(booking.bookingNo).val(booking.id));
                });
            }).fail(function() {
                $("#message").html("Failed to load bookings.");
            });
        }

        // Function to load select options with customer data
        function loadSelectCustomers() {
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/customer/getallcustomers", function(data) {
                var mySelect = $("#customerId").empty();
                mySelect.append('<option value="">Select a customer</option>');
                $.each(data, function(index, customer) {
                    var customerName = customer.custLastName + ", " + customer.custFirstName;
                    mySelect.append($('<option>').text(customerName).val(customer.customerId));
                });
            }).fail(function() {
                $("#message").html("Failed to load customers.");
            });
        }

        // Function to retrieve and display booking details
        function getBooking(bookingId) {
            if (!bookingId) {
                refreshAndClearForm();
                return;
            }
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/booking/getbooking/" + bookingId, function(data) {
                $("#bookingNo").val(data.bookingNo);
                $("#bookingDate").val(new Date(data.bookingDate).toISOString().substring(0, 10));
                $("#travelerCount").val(data.travelerCount);
                $("#customerId").val(data.customer ? data.customer.id : "");
                $("#btnInsert").prop('disabled', true).attr('title', 'No inserting allowed when a booking is selected');
            }).fail(function() {
                $("#message").html("Failed to load booking details.");
            });
        }
        function refreshAndClearForm() {
            $('form')[0].reset();
            loadSelectBookings();  // Refresh the booking dropdown list
            loadSelectCustomers(); // Refresh the customer dropdown list
            enableInsertButton();  // Re-enable the create button
        }

        function enableInsertButton() {
            $("#btnInsert").prop('disabled', false).removeAttr('title');
        }

        // Validates required fields before submission
        function validateForm() {
            if ($("#bookingNo").val().trim() === "" || $("#bookingDate").val().trim() === "") {
                alert("Booking Number and Booking Date are required.");
                return false;
            }
            return true;
        }

        // Function to handle CREATE and UPDATE requests
        function saveBooking(method) {
            if (!validateForm()) return;
            var bookingData = {
                'bookingNo': $("#bookingNo").val(),
                'bookingDate': $("#bookingDate").val(),
                'travelerCount': $("#travelerCount").val(),
                'customer': {'id': $("#customerId").val()}
            };
            var url = method === "POST" ?
                "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/booking/postbooking" :
                "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/booking/updatebooking/" + $("#bookingselect").val();

            $.ajax({
                url: url,
                type: method,
                contentType: "application/json",
                data: JSON.stringify(bookingData),
                success: function(response) {
                    alert("Booking operation successful.");
                    refreshAndClearForm();
                },
                error: function(xhr, status, error) {
                    alert("Failed to process booking: " + xhr.responseText);
                }
            });
        }

        // Function to handle DELETE request
        function deleteBooking() {
            var bookingId = $("#bookingselect").val();
            if (!bookingId) {
                alert("Select a booking to delete.");
                return;
            }

            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/booking/deletebooking/" + bookingId,
                type: "DELETE",
                success: function(response) {
                    alert("Booking deleted successfully.");
                    refreshAndClearForm();
                },
                error: function(xhr) {
                    alert("Failed to delete booking: " + xhr.responseText);
                }
            });
        }

        $(document).ready(function() {
            loadSelectBookings();
            loadSelectCustomers();
            $("#bookingselect").change(function() {
                var bookingId = $(this).val();
                getBooking(bookingId);
            });

            $("#btnInsert").click(function(event) {
                event.preventDefault();
                saveBooking("POST");
            });

            $("#btnUpdate").click(function(event) {
                event.preventDefault();
                saveBooking("PUT");
            });

            $("#btnDelete").click(function(event) {
                event.preventDefault();
                deleteBooking();
            });

            $("#btnClear").click(function(event) {
                event.preventDefault();
                refreshAndClearForm();
            });
        });
    </script>
</head>
<body>
<form>
    <select id="bookingselect" onchange="getBooking(this.value)">
        <option value="">Select a booking to see details</option>
    </select>
    <label for="bookingNo">Booking No:</label>
    <input id="bookingNo" type="text" /><br />
    <label for="bookingDate">Booking Date:</label>
    <input id="bookingDate" type="date" /><br />
    <label for="travelerCount">Traveler Count:</label>
    <input id="travelerCount" type="number" /><br />
    <label for="customerId">Customer:</label>
    <select id="customerId">
        <option value="">Select a customer</option>
    </select><br />
    <div class="button-container">
        <button type="button" id="btnInsert">Insert</button>
        <button type="button" id="btnDelete">Delete</button>
        <button type="button" id="btnClear">Clear</button>
    </div>
</form>
</body>
</html>
