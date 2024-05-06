<!--created by Mohsen!-->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <!-- Title of the page -->
    <title>Booking Detail Maintenance</title>
    <!-- Include stylesheets and scripts -->
    <link rel="stylesheet" href="navstyles.css" />
    <jsp:include page="navbar.jsp" />
    <link rel="stylesheet" type="text/css" href="formstyles.css">
    <script src="jquery.js"></script>
    <!-- JavaScript functions for form interaction -->
    <script>
        // Function to load select options with booking detail data
        function loadSelectBookingDetails() {
            // AJAX call to get all booking details
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/bookingdetail/getallbookingdetails", function(data) {
                var mySelect = $("#bookingdetailselect").empty();
                mySelect.append('<option value="">Select a booking detail to see information</option>');
                // Populate dropdown list with booking details
                $.each(data, function(index, detail) {
                    mySelect.append($('<option>').text(detail.description + " - " + detail.destination).val(detail.id));
                });
            }).fail(function() {
                $("#message").html("Failed to load booking details.");
            });
        }

        // Function to retrieve and display booking detail
        function getBookingDetail(bookingDetailId) {
            // Exit if no booking detail ID is selected
            if (!bookingDetailId) {
                refreshAndClearForm();
                return;
            }
            // AJAX call to get booking detail by ID
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/bookingdetail/getbookingdetail/" + bookingDetailId, function(data) {
                // Populate form fields with booking detail information
                $("#itineraryNo").val(data.itineraryNo);
                $("#tripStart").val(new Date(data.tripStart).toISOString().substring(0, 10));
                $("#tripEnd").val(new Date(data.tripEnd).toISOString().substring(0, 10));
                $("#description").val(data.description);
                $("#destination").val(data.destination);
                $("#basePrice").val(data.basePrice);
                $("#agencyCommission").val(data.agencyCommission);
                $("#bookingId").val(data.bookingId);
            }).fail(function() {
                $("#message").html("Failed to load booking detail.");
            });
        }

        // Clears the form and reloads the booking details list
        function refreshAndClearForm() {
            $('form')[0].reset();
            loadSelectBookingDetails();  // Refresh the dropdown list
        }

        // AJAX call to delete a booking detail
        function deleteBookingDetail() {
            var bookingDetailId = $("#bookingdetailselect").val();
            // Show error message if no booking detail ID is selected
            if (!bookingDetailId) {
                $("#message").html("Select a booking detail to delete.");
                return;
            }

            // AJAX call to delete booking detail by ID
            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/bookingdetail/deletebookingdetail/" + bookingDetailId,
                type: "DELETE",
                success: function(response) {
                    alert("Booking detail deleted successfully.");
                    $("#message").html("Booking detail deleted successfully.");
                    refreshAndClearForm();  // Ensure this is called to clear the form and refresh the dropdown
                },
                error: function() {
                    $("#message").html("Failed to delete booking detail.");
                }
            });
        }

        $(document).ready(function() {
            loadSelectBookingDetails();
            // Event handler for delete button click
            $("#btnDelete").click(function(event) {
                event.preventDefault();
                deleteBookingDetail();
            });
            // Calls the function to clear all form fields and refresh the agent dropdown
            $(document).ready(function() {

                $("#btnClear").click(function(event) {
                    event.preventDefault();
                    refreshAndClearForm();
                });
            });
        });
    </script>
</head>
<body>
<!-- Booking detail maintenance form -->
<form>
    <!-- Dropdown list for booking details -->
    <select id="bookingdetailselect" onchange="getBookingDetail(this.value)">
        <option value="">Select a booking detail to see information</option>
    </select>
    <!-- Form fields for booking detail information -->
    <label for="itineraryNo">Itinerary No:</label>
    <input id="itineraryNo" type="number" disabled /><br />
    <label for="tripStart">Trip Start:</label>
    <input id="tripStart" type="date" disabled /><br />
    <label for="tripEnd">Trip End:</label>
    <input id="tripEnd" type="date" disabled /><br />
    <label for="description">Description:</label>
    <input id="description" type="text" disabled /><br />
    <label for="destination">Destination:</label>
    <input id="destination" type="text" disabled /><br />
    <label for="basePrice">Base Price:</label>
    <input id="basePrice" type="text" disabled /><br />
    <label for="agencyCommission">Agency Commission:</label>
    <input id="agencyCommission" type="text" disabled /><br />

    <!-- Button to delete booking detail -->
    <div class="button-container">
        <button type="button" id="btnDelete">Delete</button>
        <button type="button" id="btnClear">Clear</button>
    </div>
</form>
</body>
</html>
