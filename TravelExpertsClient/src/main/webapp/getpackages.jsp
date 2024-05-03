<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="navstyles.css" />
    <!-- Including navbar -->
    <jsp:include page="navbar.jsp" />
    <link rel="stylesheet" type="text/css" href="formstyles.css">
    <title>Package Maintenance</title>
    <!-- Including jQuery library -->
    <script src="jquery.js"></script>
    <script>
        // Function to load select options with package data
        var loadSelectPackages = function() {
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/package/getallpackages",
                function(data) {
                    var mySelect = $("#packageselect");
                    for (var i = 0; i < data.length; i++) {
                        var pack = data[i];
                        var myOption = document.createElement("option");
                        myOption.setAttribute("value", pack.id);
                        myOption.appendChild(document.createTextNode(pack.pkgName));
                        mySelect[0].appendChild(myOption);
                    }
                });
        }

        // Function to retrieve package details
        var getPackage = function(packageId) {
            $.get("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/package/getpackage/" + packageId,
                function(data) {
                    // Convert the timestamp to ISO string and then extract the date part
                    var pkgStartDate = data.pkgStartDate ? new Date(data.pkgStartDate).toISOString().substring(0, 10) : '';
                    var pkgEndDate = data.pkgEndDate ? new Date(data.pkgEndDate).toISOString().substring(0, 10) : '';

                    $("#packageId").val(data.id);
                    $("#pkgName").val(data.pkgName);
                    $("#pkgStartDate").val(pkgStartDate);
                    $("#pkgEndDate").val(pkgEndDate);
                    $("#pkgDesc").val(data.pkgDesc);
                    $("#pkgBasePrice").val(data.pkgBasePrice);
                    $("#pkgAgencyCommission").val(data.pkgAgencyCommission);
                }
            );
        };

        // Function to build JSON data for POST and PUT requests
        var buildPackageJSON = function(mode) {
            var packageId = 0;
            if (mode === "update") {
                packageId = $("#packageId").val();
            }
            var data = {
                'id': packageId,
                'pkgName': $("#pkgName").val(),
                'pkgStartDate': $("#pkgStartDate").val(),
                'pkgEndDate': $("#pkgEndDate").val(),
                'pkgDesc': $("#pkgDesc").val(),
                'pkgBasePrice': $("#pkgBasePrice").val(),
                'pkgAgencyCommission': $("#pkgAgencyCommission").val()
            };
            return JSON.stringify(data);
        }

        // Function to handle POST request
        var postPackage = function() {
            var jsonString = buildPackageJSON("update");

            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/package/postpackage",
                method: "POST",
                data: jsonString,
                accept: "application/json",
                dataType: "json",
                contentType: "application/json"
            }).done(function(data) {
                $("#message").html(data.message);
            }).fail(function(xhr, text, error){
                $("#message").html(text + " | " + error);
            });
        }

        // Function to handle PUT request
        var putPackage = function() {
            var jsonString = buildPackageJSON("insert");

            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/package/putpackage",
                method: "PUT",
                data: jsonString,
                accept: "application/json",
                dataType: "json",
                contentType: "application/json"
            }).done(function(data) {
                $("#message").html(data.message);
            }).fail(function(xhr, text, error){
                $("#message").html(text + " | " + error);
            });
        }

        // Function to handle DELETE request
        var deletePackage = function() {
            var packageId = $("#packageId").val();
            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/package/deletepackage/" + packageId,
                method: "DELETE",
                accept: "application/json",
                dataType: "json",
                contentType: "application/json"
            }).done(function(data) {
                $("#message").html(data.message);
            }).fail(function(xhr, text, error){
                $("#message").html(text + " | " + error);
            });
        }
    </script>
</head>
<body>

<form>
    <select id="packageselect" onchange="getPackage(this.value)">
        <option value="">Select a package to see details</option>
    </select>
    <label for="packageId">Id:</label>
    <input id="packageId" type="text" disabled="disabled" /><br />

    <label for="pkgName">Name:</label>
    <input id="pkgName" type="text" /><br />

    <label for="pkgStartDate">Start Date:</label>
    <input id="pkgStartDate" type="date" /><br />

    <label for="pkgEndDate">End Date:</label>
    <input id="pkgEndDate" type="date" /><br />

    <label for="pkgDesc">Description:</label>
    <input id="pkgDesc" type="text" /><br />

    <label for="pkgBasePrice">Base Price:</label>
    <input id="pkgBasePrice" type="text" /><br />

    <label for="pkgAgencyCommission">Agency Commission:</label>
    <input id="pkgAgencyCommission" type="text" /><br />

    <!-- Buttons for CRUD operations -->
    <button type="button" id="btnUpdate">Update</button>
    <button type="button" id="btnInsert">Insert</button>
    <button type="button" id="btnDelete">Delete</button>
</form>

<!-- Script to load packages, handle CRUD operations -->
<script>
    $(document).ready(loadSelectPackages);
    $("#btnUpdate").click(postPackage);
    $("#btnInsert").click(putPackage);
    $("#btnDelete").click(deletePackage);
</script>
</body>
</html>
