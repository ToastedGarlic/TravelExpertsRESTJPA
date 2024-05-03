<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <!-- Including CSS files -->
    <link rel="stylesheet" href="navstyles.css" />
    <jsp:include page="navbar.jsp" />
    <link rel="stylesheet" type="text/css" href="formstyles.css">
    <title>Agent Maintenance</title>
    <!-- Including jQuery library -->
    <script src="jquery.js"></script>
    <script>
        // Function to load select options with agent data
        var loadSelectAgents = function() {
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/agent/getallagents",
                function(data) {
                    var mySelect = $("#agentselect");
                    for (var i = 0; i < data.length; i++) {
                        var agent = data[i];
                        var myOption = document.createElement("option");
                        myOption.setAttribute("value", agent.agentId);
                        myOption.appendChild(document.createTextNode(agent.agtFirstName + " " + agent.agtLastName));
                        mySelect[0].appendChild(myOption);
                    }
                });
        };

        // Function to retrieve agent details
        var getAgent = function(agentId) {
            $.get("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/agent/getagent/" + agentId,
                function(data) {
                    $("#agentId").val(data.agentId);
                    $("#agtFirstName").val(data.agtFirstName);
                    $("#agtMiddleInitial").val(data.agtMiddleInitial);
                    $("#agtLastName").val(data.agtLastName);
                    $("#agtBusPhone").val(data.agtBusPhone);
                    $("#agtEmail").val(data.agtEmail);
                    $("#agtPosition").val(data.agtPosition);
                    $("#agencyId").val(data.agencyId);
                    $("#userid").val(data.userid);
                    $("#password").val(data.password);
                }
            );
        };

        // Function to build JSON data for POST and PUT requests
        var buildJSON = function(mode) {
            var agtId = 0;
            if (mode == "update") {
                agtId = $("#agentId").val();
            }
            var data = {
                'agentId': agtId,
                'agtFirstName': $("#agtFirstName").val(),
                'agtMiddleInitial': $("#agtMiddleInitial").val(),
                'agtLastName': $("#agtLastName").val(),
                'agtBusPhone': $("#agtBusPhone").val(),
                'agtEmail': $("#agtEmail").val(),
                'agtPosition': $("#agtPosition").val(),
                'agencyId': $("#agencyId").val(),
                'userid': $("#userid").val(),
                'password': $("#password").val()
            };
            return JSON.stringify(data);
        };

        // Function to handle POST request
        var postAgent = function() {
            var jsonString = buildJSON("update");

            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/agent/postagent",
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
        var putAgent = function() {
            var jsonString = buildJSON("insert");

            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/agent/putagent",
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
        var deleteAgent = function() {
            var agentId = $("#agentId").val();
            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/agent/deleteagent/" + agentId,
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

<!-- Form for agent maintenance -->
<form>
    <select id="agentselect" onchange="getAgent(this.value)">
        <option value="">Select an agent to see details</option>
    </select>
    <label for="agentId">Id:</label>
    <input id="agentId" type="text" disabled="disabled" /><br />

    <label for="agtFirstName">First Name:</label>
    <input id="agtFirstName" type="text" /><br />

    <label for="agtMiddleInitial">Middle Initial:</label>
    <input id="agtMiddleInitial" type="text" /><br />

    <label for="agtLastName">Last Name:</label>
    <input id="agtLastName" type="text" /><br />

    <label for="agtBusPhone">Business Phone:</label>
    <input id="agtBusPhone" type="text" /><br />

    <label for="agtEmail">Email:</label>
    <input id="agtEmail" type="text" /><br />

    <label for="agtPosition">Position:</label>
    <input id="agtPosition" type="text" /><br />

    <label for="agencyId">Agency Id:</label>
    <input id="agencyId" type="number" /><br />

    <label for="userid">User ID:</label>
    <input id="userid" type="text" /><br />

    <label for="password">Password:</label>
    <input id="password" type="text" /><br />

    <!-- Buttons for CRUD operations -->
    <button type="button" id="btnUpdate">Update</button>
    <button type="button" id="btnInsert">Insert</button>
    <button type="button" id="btnDelete">Delete</button>
</form>

<!-- Script to load agents, handle CRUD operations -->
<script>
    $(document).ready(loadSelectAgents);
    $("#btnUpdate").click(postAgent);
    $("#btnInsert").click(putAgent);
    $("#btnDelete").click(deleteAgent);
</script>
</body>
</html>
