<!--created by Mohsen!-->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Agent Maintenance</title>
    <link rel="stylesheet" href="navstyles.css" />
    <jsp:include page="navbar.jsp" />
    <link rel="stylesheet" type="text/css" href="formstyles.css">
    <script src="jquery.js"></script>
    <script>
        // Function to load select options with agent data
        function loadSelectAgents() {
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/agent/getallagents", function(data) {
                var mySelect = $("#agentselect").empty();
                mySelect.append('<option value="">Select an agent to see details</option>');
                $.each(data, function(index, agent) {
                    mySelect.append($('<option>').text(agent.agtFirstName + " " + agent.agtLastName).val(agent.agentId));
                });
            }).fail(function() {
                $("#message").html("Failed to load agents.");
            });
        }

        // Function to retrieve and display agent details
        function getAgent(agentId) {
            if (!agentId) {
                clearForm();
                return; // Exit if no agent ID is selected
            }
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/agent/getagent/" + agentId, function(data) {
                $("#agentId").val(data.agentId);
                $("#agtFirstName").val(data.agtFirstName);
                $("#agtMiddleInitial").val(data.agtMiddleInitial);
                $("#agtLastName").val(data.agtLastName);
                $("#agtBusPhone").val(data.agtBusPhone);
                $("#agtEmail").val(data.agtEmail);
                $("#agtPosition").val(data.agtPosition);
                $("#agencyId").val(data.agencyId);
            }).fail(function() {
                $("#message").html("Failed to load agent details.");
            });
        }

        // Clears the form and reloads the agent list
        function refreshAndClearForm() {
            $('form')[0].reset();
            $("#agentId").val('');
            loadSelectAgents();  // Refresh the dropdown list
            enableCreateButton();  // Re-enable the create button
        }

        // Validates required fields before submission
        function validateForm() {
            if ($("#agtFirstName").val().trim() === "" || $("#agtLastName").val().trim() === "") {
                $("#message").html("First Name and Last Name are required.");
                return false;
            }
            return true;
        }

        // AJAX call to create a new agent
        function createAgent() {
            if (!validateForm()) return;
            var agentData = {
                'agtFirstName': $("#agtFirstName").val(),
                'agtMiddleInitial': $("#agtMiddleInitial").val(),
                'agtLastName': $("#agtLastName").val(),
                'agtBusPhone': $("#agtBusPhone").val(),
                'agtEmail': $("#agtEmail").val(),
                'agtPosition': $("#agtPosition").val(),
                'agencyId': $("#agencyId").val()
            };

            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/agent/createagent",
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify(agentData),
                success: function(response) {
                    alert("Agent created successfully.");
                    refreshAndClearForm();
                },
                error: function() {
                    $("#message").html("Failed to add agent.");
                }
            });
        }

        // AJAX call to update an existing agent
        function updateAgent() {
            if (!validateForm()) return;
            var agentData = {
                'agtFirstName': $("#agtFirstName").val(),
                'agtMiddleInitial': $("#agtMiddleInitial").val(),
                'agtLastName': $("#agtLastName").val(),
                'agtBusPhone': $("#agtBusPhone").val(),
                'agtEmail': $("#agtEmail").val(),
                'agtPosition': $("#agtPosition").val(),
                'agencyId': $("#agencyId").val()
            };

            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/agent/updateagent/" + $("#agentId").val(),
                type: "PUT",
                contentType: "application/json",
                data: JSON.stringify(agentData),
                success: function(response) {
                    alert("Agent updated successfully.");
                    refreshAndClearForm();
                },
                error: function() {
                    $("#message").html("Failed to update agent.");
                }
            });
        }

        // AJAX call to delete an agent
        function deleteAgent() {
            var agentId = $("#agentId").val();
            if (!agentId) {
                $("#message").html("Select an agent to delete.");
                return;
            }

            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/agent/deleteagent/" + agentId,
                type: "DELETE",
                success: function(response) {
                    alert("Agent deleted successfully.");
                    $("#message").html("Agent deleted successfully.");
                    refreshAndClearForm();  // Ensure this is called to clear the form and refresh the dropdown
                },
                error: function() {
                    $("#message").html("Failed to delete agent.");
                }
            });
        }
        $(document).ready(function() {
            loadSelectAgents();

            // Event handler for select dropdown changes
            $("#agentselect").change(function() {
                var agentId = $(this).val();
                if (agentId) {
                    getAgent(agentId);
                    $("#btnCreate").prop('disabled', true).attr('title', 'No inserting allowed when an agent is selected');
                } else {
                    clearForm();
                    $("#btnCreate").prop('disabled', false).removeAttr('title');
                }
            });

            $("#btnCreate").click(function(event) {
                event.preventDefault();
                createAgent();
            });

            $("#btnUpdate").click(function(event) {
                event.preventDefault();
                updateAgent();
            });

            $("#btnDelete").click(function(event) {
                event.preventDefault();
                deleteAgent();
            });


            function clearForm() {
                $('form')[0].reset();
                $("#agentselect").val('');
            }

            function enableCreateButton() {
                $("#btnCreate").prop('disabled', false).removeAttr('title');
            }
        });

    </script>
</head>
<body>
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
    <div class="button-container">
        <button type="button" id="btnCreate">Create</button>
        <button type="button" id="btnUpdate">Update</button>
        <button type="button" id="btnDelete">Delete</button>
        <button type="button" id="btnClear">Clear</button>
    </div>
</form>
</body>
</html>