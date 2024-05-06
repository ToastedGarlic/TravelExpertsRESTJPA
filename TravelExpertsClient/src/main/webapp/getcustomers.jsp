<!--created by Mohsen!-->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Maintenance</title>
    <link rel="stylesheet" href="navstyles.css" />
    <jsp:include page="navbar.jsp" />
    <link rel="stylesheet" type="text/css" href="formstyles.css">
    <script src="jquery.js"></script>
    <script>
        // Load customer and agent data
        function loadSelectCustomers() {
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/customer/getallcustomers", function(data) {
                var mySelect = $("#customerselect").empty();
                mySelect.append('<option value="">Select a customer</option>');
                $.each(data, function(index, customer) {
                    var customerName = customer.custLastName + ", " + customer.custFirstName;
                    mySelect.append($('<option>').text(customerName).val(customer.customerId));
                });
            }).fail(function() {
                alert("Failed to load customers.");
            });
        }

        function loadSelectAgents() {
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/agent/getallagents", function(data) {
                var mySelect = $("#agentId").empty();
                mySelect.append('<option value="">Select an agent</option>');
                $.each(data, function(index, agent) {
                    var agentName = agent.agtFirstName + " " + agent.agtLastName;
                    mySelect.append($('<option>').text(agentName).val(agent.agentId));
                });
            }).fail(function() {
                alert("Failed to load agents.");
            });
        }

        function getCustomer(customerId) {
            if (!customerId) {
                refreshAndClearForm();
                return;
            }
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/customer/getcustomer/" + customerId, function(data) {
                $("#custFirstName").val(data.custFirstName);
                $("#custLastName").val(data.custLastName);
                $("#custAddress").val(data.custAddress);
                $("#custCity").val(data.custCity);
                $("#custProv").val(data.custProv);
                $("#custPostal").val(data.custPostal);
                $("#custCountry").val(data.custCountry);
                $("#custHomePhone").val(data.custHomePhone);
                $("#custBusPhone").val(data.custBusPhone);
                $("#custEmail").val(data.custEmail);
                $("#agentId").val(data.agentId);
                $("#username").val(data.username);
                $("#password").val(data.password);
            }).fail(function() {
                alert("Failed to load customer details.");
            });
        }

        function refreshAndClearForm() {
            $('form')[0].reset();
            loadSelectCustomers();
            loadSelectAgents();
        }

        function insertCustomer() {
            if (!validateForm()) return;
            var customerData = gatherCustomerData();
            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/customer/postcustomer",
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(customerData),
                success: function(response) {
                    alert("Customer inserted successfully.");
                    refreshAndClearForm();
                },
                error: function(xhr) {
                    alert("Failed to insert customer: " + xhr.responseText);
                }
            });
        }

        function updateCustomer() {
            if (!validateForm()) return;
            var customerData = gatherCustomerData();
            customerData.customerId = $("#customerselect").val();
            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/customer/updatecustomer/" + customerData.customerId,
                type: "PUT",
                contentType: "application/json",
                data: JSON.stringify(customerData),
                success: function(response) {
                    alert("Customer updated successfully.");
                    refreshAndClearForm();
                },
                error: function(xhr) {
                    alert("Failed to update customer: " + xhr.responseText);
                }
            });
        }

        function deleteCustomer() {
            var customerId = $("#customerselect").val();
            if (!customerId) {
                alert("Select a customer to delete.");
                return;
            }
            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/customer/deletecustomer/" + customerId,
                type: "DELETE",
                success: function(response) {
                    alert("Customer deleted successfully.");
                    refreshAndClearForm();
                },
                error: function(xhr) {
                    alert("Failed to delete customer: " + xhr.responseText);
                }
            });
        }

        function validateForm() {
            return $("#custFirstName").val().trim() && $("#custLastName").val().trim();
        }

        function gatherCustomerData() {
            // Gather data from form inputs including the new username and password
            return {
                'custFirstName': $("#custFirstName").val(),
                'custLastName': $("#custLastName").val(),
                'custAddress': $("#custAddress").val(),
                'custCity': $("#custCity").val(),
                'custProv': $("#custProv").val(),
                'custPostal': $("#custPostal").val(),
                'custCountry': $("#custCountry").val(),
                'custHomePhone': $("#custHomePhone").val(),
                'custBusPhone': $("#custBusPhone").val(),
                'custEmail': $("#custEmail").val(),
                'agentId': $("#agentId").val(),
                'username': $("#username").val(),
                'password': $("#password").val()
            };
        }
        $(document).ready(function() {
            loadSelectCustomers();
            loadSelectAgents();
            $("#btnInsert").click(function(event) {
                event.preventDefault();
                insertCustomer();
            });
            $("#btnUpdate").click(function(event) {
                event.preventDefault();
                updateCustomer();
            });
            $("#btnDelete").click(function(event) {
                event.preventDefault();
                deleteCustomer();
            });
        });
    </script>
</head>
<body>
<form>
    <select id="customerselect" onchange="getCustomer(this.value)">
        <option value="">Select a customer</option>
    </select>

    <label for="custFirstName">First Name:</label>
    <input id="custFirstName" type="text" /><br />

    <label for="custLastName">Last Name:</label>
    <input id="custLastName" type="text" /><br />

    <label for="custAddress">Address:</label>
    <input id="custAddress" type="text" /><br />

    <label for="custCity">City:</label>
    <input id="custCity" type="text" /><br />

    <label for="custProv">Province:</label>
    <input id="custProv" type="text" /><br />

    <label for="custPostal">Postal Code:</label>
    <input id="custPostal" type="text" /><br />

    <label for="custCountry">Country:</label>
    <input id="custCountry" type="text" /><br />

    <label for="custHomePhone">Home Phone:</label>
    <input id="custHomePhone" type="text" /><br />

    <label for="custBusPhone">Business Phone:</label>
    <input id="custBusPhone" type="text" /><br />

    <label for="custEmail">Email:</label>
    <input id="custEmail" type="text" /><br />

    <label for="agentId">Agent:</label>
    <select id="agentId">
        <option value="">Select an agent</option>
    </select><br />
    <label for="username">Username:</label>
    <input id="username" type="text" /><br />

    <label for="password">Password:</label>
    <input id="password" type="password" /><br />


    <!-- Buttons for CRUD operations -->
    <button type="button" id="btnUpdate">Update</button>
    <button type="button" id="btnInsert">Insert</button>
    <button type="button" id="btnDelete">Delete</button>
</form>
</body>
</html>
