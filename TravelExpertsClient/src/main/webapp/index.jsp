<!--created by Mohsen!-->
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="navbar.jsp" />
    <link rel="stylesheet" href="indexstyles.css" />
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.0.0/fonts/remixicon.css" rel="stylesheet" />

    <title>TravelExperts</title>
</head>
<body>

<header>
    <div class="section__container">
        <div class="header__content">
            <h1>Travel</h1>
            <p>
                Embark on a journey of a lifetime and explore the world's most
                breathtaking destinations with our expert travel advice. From exotic
                beaches to cultural wonders, we've got you covered with our
                comprehensive travel guides and insider tips.
            </p>
            <a href="aboutus.jsp"><button>Learn more</button></a>
        </div>
    </div>
</header>

<section class="journey__container">
    <div class="section__container">
        <h2 class="section__title">Start Your Journey</h2>
        <p class="section__subtitle">The most searched countries in March</p>
        <div class="journey__grid">
            <div class="country__card">
                <img src="assets/country-1.jpg" alt="country" />
                <div class="country__name">
                    <i class="ri-map-pin-2-fill"></i>
                    <span>Santorini, Greece</span>
                </div>
            </div>
            <div class="country__card">
                <img src="assets/country-2.jpg" alt="country" />
                <div class="country__name">
                    <i class="ri-map-pin-2-fill"></i>
                    <span>Vernazza, Italy</span>
                </div>
            </div>
            <div class="country__card">
                <img src="assets/country-3.jpg" alt="country" />
                <div class="country__name">
                    <i class="ri-map-pin-2-fill"></i>
                    <span>San Francisco</span>
                </div>
            </div>
            <div class="country__card">
                <img src="assets/country-4.jpg" alt="country" />
                <div class="country__name">
                    <i class="ri-map-pin-2-fill"></i>
                    <span>navagio, Greece</span>
                </div>
            </div>
            <div class="country__card">
                <img src="assets/country-5.jpg" alt="country" />
                <div class="country__name">
                    <i class="ri-map-pin-2-fill"></i>
                    <span>Ao Nang, Thailand</span>
                </div>
            </div>
            <div class="country__card">
                <img src="assets/country-6.jpg" alt="country" />
                <div class="country__name">
                    <i class="ri-map-pin-2-fill"></i>
                    <span>Phi Phi Island, Thailand</span>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="banner__container">
    <div class="section__container">
        <div class="banner__content">
            <h2>Discount <a href="getpackages.jsp">10-30%</a> Off</h2>
            <p>
                Travel the world on a budget with our unbeatable discounted travel
                deals. Whether you're looking for a last-minute escape or planning
                ahead, we've got you covered with incredible discounts on flights,
                hotels, and packages. Don't wait, book now and experience the
                adventure of a lifetime without breaking the bank.
            </p>
            <button>See Tours</button>
        </div>
    </div>
</section>

<section class="display__container">
    <div class="section__container">
        <h2 class="section__title">Why Choose Us</h2>
        <p class="section__subtitle">
            The gladdest moment in human life, is a departure into unknown lands.
        </p>
        <div class="display__grid">
            <div class="display__card grid-1">
                <img src="assets/grid-1.jpg" alt="grid" />
            </div>
            <div class="display__card">
                <i class="ri-earth-line"></i>
                <h4>Passionate Travel</h4>
                <p>Fuel your passion for adventure and discover new horizons</p>
            </div>
            <div class="display__card">
                <img src="assets/grid-2.jpg" alt="grid" />
            </div>
            <div class="display__card">
                <img src="assets/grid-3.jpg" alt="grid" />
            </div>
            <div class="display__card">
                <i class="ri-road-map-line"></i>
                <h4>Beautiful Places</h4>
                <p>Uncover the world's most breathtakingly beautiful places</p>
            </div>
        </div>
    </div>
</section>

<footer>
    <div class="section__container">
        <h4>TravelExperts</h4>
        <p>
            Travel makes one modest. You see what a tiny place you occupy in the
            world.
        </p>
    </div>
</footer>
</body>
</html>
