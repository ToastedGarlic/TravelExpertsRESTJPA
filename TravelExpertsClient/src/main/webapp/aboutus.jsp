<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Include navbar -->
    <jsp:include page="navbar.jsp" />
    <!-- Set document metadata -->
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Set page title -->
    <title>About Us - TravelExperts</title>
    <!-- CSS styles -->
    <style>
        /* Styling for body */
        body {
            font-family: 'Open Sans', sans-serif;
            background-image: url('assets/bg-1.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            color: #FFFFFF;
            margin: 0;
            padding: 0;
            height: 100%;
        }
        /* Header styling */
        .about-us-header {
            font-size: 36px;
            text-align: center;
            margin-top: 50px;
            color: #FFFFFF;
        }
        /* Container for text and image */
        .about-us-container {
            display: flex;
            align-items: center;
            justify-content: space-around;
            margin: 20px;
            max-width: 1200px;
            margin: auto;
            color: #FFFFFF;
        }
        /* Styling for the text */
        .about-us-text, .about-us-image {
            flex: 1;
            max-width: 500px;
        }
        .about-us-image img {
            width: 100%;
            height: auto;
            max-height: 750px;
        }
        .about-us-text {
            padding-right: 20px;
            font-size: 120%;
        }
        /* Footer styling */
        footer {
            text-align: center;
            padding: 20px;
            background: rgba(0, 0, 0, 0.5);
        }
        .social__icons {
            font-size: 24px;
            padding: 10px 0;
        }
        .social__icons i {
            margin: 0 10px;
        }
        footer p {
            margin-top: 10px;
            color: #FFFFFF;
        }
    </style>
</head>
<body>

<!-- Header section -->
<div class="about-us-header">WE ARE TRAVEL EXPERTS!</div>

<!-- Main content section -->
<main class="content">
    <!-- Container for text and image -->
    <div class="about-us-container">
        <!-- Text content -->
        <div class="about-us-text">

            <p>Welcome to TravelExperts, the definitive guide to experiential travel.
                Our platform is designed to inspire your wanderlust and help you craft the journey of a lifetime.
                Explore the unknown or revisit familiar places with a new perspective.
                Let us guide you to experiences that enrich and fulfill.</p>

            <p>With a commitment to authentic and immersive experiences, TravelExperts is your portal to
                the hidden gems and cultural heartbeats of destinations across the globe. Our curated adventures are tailored to your
                unique tastes, ensuring that every trip is a personal discovery.
                Experience local cultures, savor exotic cuisines, and embrace the thrill of adventure.</p>

            <p>Our network of seasoned travelers and local experts brings you insights and recommendations
                that go beyond the conventional. Whether you're looking for solitude in nature or vibrant
                city beats, our suggestions will help you find your ideal retreat. Join us at TravelExperts,
                and let’s make your next trip an unforgettable chapter in your travel story.</p>
            <p>TravelExperts is not just about places but about the stories that come alive when you experience them.
                From serene landscapes to bustling markets, each destination offers a chance to create memories that last a lifetime.
                Our expert guides ensure you get the most out of every moment of your journey.</p>
            <p>Join the community of like-minded explorers who seek more than just a holiday.
                With TravelExperts, travel is about discovery, learning, and connecting with the world in a way that is uniquely yours.
                It's not just a trip; it's a transformation that begins with the first step out of your door.
                Let us be part of your next adventure.</p>
        </div>
        <div class="about-us-image">
            <img src="assets/aboutus.jpg" alt="About Us">
        </div>
    </div>
</main>

</body>
</html>
