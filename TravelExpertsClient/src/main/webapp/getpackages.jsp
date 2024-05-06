<!--created by Mohsen!-->
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
        // Function to validate form inputs
        function validateForm() {
            var pkgName = $("#pkgName").val().trim();
            var pkgStartDate = new Date($("#pkgStartDate").val());
            var pkgEndDate = new Date($("#pkgEndDate").val());
            var pkgDesc = $("#pkgDesc").val().trim();
            var pkgBasePrice = $("#pkgBasePrice").val().trim();
            var pkgAgencyCommission = $("#pkgAgencyCommission").val().trim();

            // Validate Package Name
            if (!pkgName.match(/^[A-Za-z0-9 ]{1,50}$/)) {
                alert("Package Name is invalid. Please use only alphanumeric characters and spaces, up to 50 characters.");
                return false;
            }

            // Validate Package Dates
            if (isNaN(pkgStartDate.getTime()) || isNaN(pkgEndDate.getTime()) || pkgEndDate < pkgStartDate) {
                alert("Invalid Start or End Date. End Date must be after Start Date.");
                return false;
            }

            // Validate Description
            if (!pkgDesc.match(/^[\w\W]{0,50}$/)) {
                alert("Description is too long. Maximum 50 characters allowed.");
                return false;
            }

            // Validate Base Price
            if (!pkgBasePrice.match(/^\d+(\.\d{1,2})?$/)) {
                alert("Invalid Base Price. Please enter a valid numeric value.");
                return false;
            }

            // Validate Agency Commission
            if (!pkgAgencyCommission.match(/^\d+(\.\d{1,2})?$/) || parseFloat(pkgAgencyCommission) > parseFloat(pkgBasePrice)) {
                alert("Invalid Agency Commission. It must not exceed the Base Price and should be a valid numeric value.");
                return false;
            }

            return true;
        }

        // Function to load select options with packages
        function loadSelectPackages() {
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/package/getallpackages",
                function(data) {
                    var select = $("#packageselect").empty().append('<option value="">Select a package</option>');
                    data.forEach(function(pack) {
                        select.append($('<option>').text(pack.pkgName).val(pack.id));
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
            $.getJSON("http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/package/getpackage/" + packageId,
                function(data) {
                    $("#pkgName").val(data.pkgName);
                    $("#pkgStartDate").val(data.pkgStartDate ? new Date(data.pkgStartDate).toISOString().substring(0, 10) : '');
                    $("#pkgEndDate").val(data.pkgEndDate ? new Date(data.pkgEndDate).toISOString().substring(0, 10) : '');
                    $("#pkgDesc").val(data.pkgDesc);
                    $("#pkgBasePrice").val(data.pkgBasePrice);
                    $("#pkgAgencyCommission").val(data.pkgAgencyCommission);
                }).fail(function() {
                alert("Failed to load package details.");
            });
        }

        // Function to refresh and clear the form
        function refreshAndClearForm() {
            $('form')[0].reset();
            loadSelectPackages();
        }

        // Function to save package data
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
            var url = "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/package/" + (method === "POST" ? "postpackage" : "putpackage");

            $.ajax({
                url: url,
                type: method,
                contentType: "application/json",
                data: JSON.stringify(packageData),
                success: function() {
                    alert("Package operation successful.");
                    refreshAndClearForm();
                },
                error: function(xhr) {
                    alert("Failed to process package: " + xhr.responseText);
                }
            });
        }

        // Function to delete package
        function deletePackage() {
            var packageId = $("#packageselect").val();
            if (!packageId) {
                alert("Select a package to delete.");
                return;
            }
            $.ajax({
                url: "http://localhost:8080/TravelExpertsRESTJPA-1.0-SNAPSHOT/api/package/deletepackage/" + packageId,
                type: "DELETE",
                success: function() {
                    alert("Package deleted successfully.");
                    refreshAndClearForm();
                },
                error: function(xhr) {
                    alert("Failed to delete package: " + xhr.responseText);
                }
            });
        }

        // Function to validate form before submission
        function validateForm() {
            return $("#pkgName").val().trim();
        }

        $(document).ready(function() {
            loadSelectPackages();
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
<form>
    <select id="packageselect" onchange="getPackage(this.value)">
        <option value="">Select a package to see details</option>
    </select>

    <!-- Package Information Fields -->
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
        <button type="button" id="btnInsert">Insert</button>
        <button type="button" id="btnUpdate">Update</button>
        <button type="button" id="btnDelete">Delete</button>
        <button type="button" id="btnClear">Clear</button>
    </div>
</form>
</body>
</html>
