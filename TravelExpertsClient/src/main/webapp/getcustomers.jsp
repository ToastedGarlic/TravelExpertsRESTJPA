<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Including navbar -->
    <jsp:include page="navbar.jsp" />
    <!-- Including CSS files -->
    <link rel="stylesheet" href="navstyles.css" />
    <link rel="stylesheet" type="text/css" href="formstyles.css">
    <title>Customer Maintenance</title>
    <!-- Including jQuery library -->
    <script src="jquery.js"></script>
    <script>
        // Function to load select options with customer data
        var loadSelectCustomers = function()
        {
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/customer/getallselectcustomers",
                function(data){
                    var mySelect = $("#customerselect");
                    for (i=0; i<data.length; i++)
                    {
                        var customer = data[i];
                        var myOption = document.createElement("option");
                        myOption.setAttribute("value", customer.customerId);
                        myOption.appendChild(document.createTextNode(customer.custFirstName
                            + " " + customer.custLastName));
                        mySelect[0].appendChild(myOption);
                    }
                });
        }

        // Function to retrieve customer details
        var getCustomer = function(customerId)
        {
            $.get("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/customer/getcustomer/" + customerId,
                function(data){
                    $("#customerId").val(data.customerId);
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
                }
            );
        }

        // Function to build JSON data for POST and PUT requests
        var buildJSON = function(mode)
        {
            var custId = 0;
            if (mode == "update") {
                custId = $("#customerId").val();
            }
            var data = {
                'customerId': custId,
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
                'agentId': $("#agentId").val()
            };
            return JSON.stringify(data);
        }

        // Function to handle POST request
        var postCustomer = function()
        {
            var jsonString = buildJSON("update");

            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/customer/postcustomer",
                method: "POST",
                data: jsonString,
                accept: "application/json",
                dataType: "json",
                contentType: "application/json"
            }).done(function (data, text, xhr) {
                $("#message").html(data.message);
            }).fail(function(xhr, text, error){
                $("#message").html(text + " | " + error);
            });
        }

        // Function to handle PUT request
        var putCustomer = function()
        {
            var jsonString = buildJSON("insert");

            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/customer/putcustomer",
                method: "PUT",
                data: jsonString,
                accept: "application/json",
                dataType: "json",
                contentType: "application/json"
            }).done(function (data, text, xhr) {
                $("#message").html(data.message);
            }).fail(function(xhr, text, error){
                $("#message").html(text + " | " + error);
            });
        }

        // Function to handle DELETE request
        var deleteCustomer = function()
        {
            var customerId = $("#customerId").val();
            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/customer/deletecustomer/" + customerId,
                method: "DELETE",
                accept: "application/json",
                dataType: "json",
                contentType: "application/json"
            }).done(function (data, text, xhr) {
                $("#message").html(data.message);
            }).fail(function(xhr, text, error){
                $("#message").html(text + " | " + error);
            });
        }
    </script>
</head>
<body>

<form>
    <select id="customerselect" onchange="getCustomer(this.value)">
        <option value="">Select a customer to see details</option>
    </select>
    <label for="customerId">Id:</label>
    <input id="customerId" type="text" disabled="disabled" /><br />

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

    <label for="agentId">Agent Id:</label>
    <input id="agentId" type="number" /><br />

    <!-- Buttons for CRUD operations -->
    <button type="button" id="btnUpdate">Update</button>
    <button type="button" id="btnInsert">Insert</button>
    <button type="button" id="btnDelete">Delete</button>
</form>

<!-- Script to load customers, handle CRUD operations -->
<script>
    $(document).ready(loadSelectCustomers);
    $("#btnUpdate").click(postCustomer);
    $("#btnInsert").click(putCustomer);
    $("#btnDelete").click(deleteCustomer);
</script>
</body>
</html>
