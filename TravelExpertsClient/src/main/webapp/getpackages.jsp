<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Package Maintenance</title>
    <link rel="stylesheet" href="navstyles.css" />
    <jsp:include page="navbar.jsp" />
    <link rel="stylesheet" type="text/css" href="formstyles.css">
    <script src="jquery.js"></script>
    <script>
        // Function to load select options with package data
        function loadSelectPackages() {
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/package/getallpackages", function(data) {
                var select = $("#packageselect").empty();
                select.append('<option value="">Select a package</option>');
                $.each(data, function(index, pkg) {
                    select.append($('<option>').text(pkg.pkgName + " - " + pkg.pkgStartDate).val(pkg.packageId));
                });
            }).fail(function() {
                alert("Failed to load packages.");
            });
        }

        // Function to retrieve and display package details
        function getPackage(packageId) {
            if (!packageId) {
                refreshAndClearForm();
                return;
            }
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/package/getpackage/" + packageId, function(data) {
                $("#packageId").val(data.packageId);
                $("#pkgName").val(data.pkgName);
                $("#pkgStartDate").val(data.pkgStartDate ? new Date(data.pkgStartDate).toISOString().substring(0, 10) : '');
                $("#pkgEndDate").val(data.pkgEndDate ? new Date(data.pkgEndDate).toISOString().substring(0, 10) : '');
                $("#pkgDesc").val(data.pkgDesc);
                $("#pkgBasePrice").val(data.pkgBasePrice);
                $("#pkgAgencyCommission").val(data.pkgAgencyCommission);
                $("#btnInsert").prop('disabled', true); // Disable the insert button when a package is selected
            }).fail(function() {
                alert("Failed to load package details.");
            });
        }

        // Function to refresh and clear the form
        function refreshAndClearForm() {
            $('form')[0].reset();
            loadSelectPackages();
            $("#btnInsert").prop('disabled', false); // Re-enable the insert button
        }

        // Validates required fields before submission
        function validateForm() {
            if ($("#pkgName").val().trim() === "" || $("#pkgStartDate").val().trim() === "") {
                alert("Package name and start date are required.");
                return false;
            }
            return true;
        }

        // Function to handle CREATE and UPDATE requests
        function savePackage(method) {
            if (!validateForm()) return;
            var packageData = {
                pkgName: $("#pkgName").val(),
                pkgStartDate: $("#pkgStartDate").val(),
                pkgEndDate: $("#pkgEndDate").val(),
                pkgDesc: $("#pkgDesc").val(),
                pkgBasePrice: $("#pkgBasePrice").val(),
                pkgAgencyCommission: $("#pkgAgencyCommission").val()
            };
            var url = method === "POST" ?
                "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/package/createpackage" :
                "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/package/updatepackage/" + $("#packageId").val();

            $.ajax({
                url: url,
                type: method,
                contentType: "application/json",
                data: JSON.stringify(packageData),
                success: function(response) {
                    alert("Package operation successful.");
                    refreshAndClearForm();
                },
                error: function(xhr) {
                    alert("Failed to process package: " + xhr.responseText);
                }
            });
        }

        // Function to handle DELETE request
        function deletePackage() {
            var packageId = $("#packageselect").val();
            if (!packageId) {
                alert("Select a package to delete.");
                return;
            }

            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/package/deletepackage/" + packageId,
                type: "DELETE",
                success: function(response) {
                    alert("Package deleted successfully.");
                    refreshAndClearForm();
                },
                error: function(xhr) {
                    alert("Failed to delete package: " + xhr.responseText);
                }
            });
        }

        $(document).ready(function() {
            loadSelectPackages();
            $("#packageselect").change(function() {
                var packageId = $(this).val();
                if (packageId) {
                    getPackage(packageId);
                    $("#btnInsert").prop('disabled', true); // Disable the insert button when a package is selected
                } else {
                    refreshAndClearForm();
                    $("#btnInsert").prop('disabled', false);
                }
            });

            $("#btnInsert").click(function(event) {
                event.preventDefault();
                savePackage("POST");
            });

            $("#btnUpdate").click(function(event) {
                event.preventDefault();
                savePackage("PUT");
            });

            $("#btnDelete").click(function(event) {
                event.preventDefault();
                deletePackage();
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
    <input id="pkgBasePrice" type="number" step="0.01" /><br />
    <label for="pkgAgencyCommission">Agency Commission:</label>
    <input id="pkgAgencyCommission" type="number" step="0.01" /><br />
    <div class="button-container">
        <button type="button" id="btnInsert">Create</button>
        <button type="button" id="btnUpdate">Update</button>
        <button type="button" id="btnDelete">Delete</button>
        <button type="button" id="btnClear">Clear</button>
    </div>
</form>
</body>
</html>
