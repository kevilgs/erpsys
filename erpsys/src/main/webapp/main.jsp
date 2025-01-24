<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
    <head>
        <title>Product</title>
        <!-- Required meta tags -->
        <meta charset="utf-8" />
        <meta
            name="viewport"
            content="width=device-width, initial-scale=1, shrink-to-fit=no"
        />

        <!-- Bootstrap CSS v5.2.1 -->
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
            rel="stylesheet"
            integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN"
            crossorigin="anonymous"
        />
    </head>
    <style>
        body{
            background: rgb(255, 255, 255);
            background-size: cover;
            font-family: Poppins;

            #particles-js {
            position: fixed;
            width: 100%;
            height: 100%;
            background: #000833;
            top: 0;
            left: 0;
            z-index: -1;
        }
        }
        .dropdown-menu {
    background-color: #321535; /* Light gray */
}

/* Set background color for each dropdown item */
.dropdown-item {
    background-color: #e2c2f6; /* White */
    transition: background-color 0.3s, transform 0.3s;
}

/* Change background color and add animation on hover */
.dropdown-item:hover {
    background-color: #321535; /* Blue */
    color: white; /* White text */
    transform: translateX(10px); /* Slide animation */
}
        .btn:hover {
        background-color: #cb8bf2; /* New color when hovered */
        background-color: rgba(203, 139, 242, 0.5);
    }
    
    .carousel, .carousel-inner, .carousel-item, .carousel-item video, .carousel-item img {
            height: 100vh; /* Full viewport height */
            width: 100vw; /* Full viewport width */
            object-fit: cover; /* Ensure the video/image covers the full area */
        }
        .carousel-inner {
            overflow: hidden;
        }
        .form-control:focus {
    outline: none;
    box-shadow: none; /* Removes the default box shadow */
}
        .custom-navbar {
    background-color: #2e1a36; /* Replace with your desired color */
}
    </style>

    <body>
        <div id="particles-js"></div>
        <header>
            <nav
                class="navbar navbar-expand-lg navbar-dark custom-navbar"
            >
                <div class="container">
                
                
                <img
                    src="https://cdn3d.iconscout.com/3d/premium/thumb/e-commerce-website-3d-icon-download-in-png-blend-fbx-gltf-file-formats--online-search-product-shopping-site-pack-icons-5966600.png?f=webp"
                    class=" rounded-circle"
                    alt=""
                    height="40"
                    width="40"
                        />
                    <div class="collapse navbar-collapse" id="collapsibleNavId">
                        <ul class="navbar-nav me-auto mt-2 mt-lg-0">
                            <li class="nav-item">
                                <a class="nav-link active" href="#" aria-current="page"
                                    >Home
                                    <span class="visually-hidden">(current)</span></a
                                >
                            </li>
                            <li class="nav-item dropdown">
                                <a
                                    class="nav-link dropdown-toggle"
                                    href="#"
                                    id="dropdownId"
                                    data-bs-toggle="dropdown"
                                    aria-haspopup="true"
                                    aria-expanded="false"
                                    >Categories</a
                                >
                                <div
                                    class="dropdown-menu"
                                    aria-labelledby="dropdownId"
                                >
                                <a class="dropdown-item" href="HomePage?Category=Automotive">Automotive</a>
                                <a class="dropdown-item" href="HomePage?Category=Beauty">Beauty</a>
                                <a class="dropdown-item" href="HomePage?Category=Books">Books</a>
                                <a class="dropdown-item" href="HomePage?Category=Clothing">Clothing</a>
                                <a class="dropdown-item" href="HomePage?Category=Electronics">Electronics</a>
                                <a class="dropdown-item" href="HomePage?Category=Food">Food</a>
                                <a class="dropdown-item" href="HomePage?Category=Furniture">Furniture</a>
                                <a class="dropdown-item" href="HomePage?Category=Gardening">Gardening</a>
                                <a class="dropdown-item" href="HomePage?Category=Healthcare">Healthcare</a>
                                <a class="dropdown-item" href="HomePage?Category=Kitchen">Kitchen</a>
                                <a class="dropdown-item" href="HomePage?Category=Sports">Sports</a>
                                <a class="dropdown-item" href="HomePage?Category=Toys">Toys</a>
                                
                                </div>
                            </li>
                        </ul>
                        <button type="button" class="btn" onclick="window.location.href='ViewCart';">
                            <img  class="rounded-circle" src="https://cdn-icons-png.flaticon.com/512/3936/3936942.png" alt="Button Image" height="40" width="40" />
                        </button>
                        <button type="button" class="btn"  onclick="window.location.href='userProfile.jsp';">
                            <img  class="rounded-circle" src="https://cdn-icons-png.flaticon.com/512/10813/10813372.png" alt="Button Image" height="40" width="40" />
                        </button>
                    </div>
                </div>
            </nav>
            
        </header>
        <main>
            <div id="carouselId" class="carousel slide" data-bs-ride="carousel">
                <ol class="carousel-indicators">
                    <li data-bs-target="#carouselId" data-bs-slide-to="0" class="active" aria-current="true" aria-label="First slide"></li>
                    <li data-bs-target="#carouselId" data-bs-slide-to="1" aria-label="Second slide"></li>
                    <li data-bs-target="#carouselId" data-bs-slide-to="2" aria-label="Third slide"></li>
                    <li data-bs-target="#carouselId" data-bs-slide-to="3" aria-label="Fourth slide"></li>
                    <li data-bs-target="#carouselId" data-bs-slide-to="4" aria-label="Fifth slide"></li>
                </ol>
                <div class="carousel-inner" role="listbox">
                    <!-- Video Carousel Item 1 -->
                    <div class="carousel-item active">
                        <video class="w-100 d-block" autoplay muted loop id="video1">
                            <source src="images/Screen Recording 2025-01-12 145222 (online-video-cutter.com).mp4" type="video/mp4">
                            Your browser does not support the video tag.
                        </video>
                    </div>
            
                    <!-- Image Carousel Item 2 -->
                    <div class="carousel-item">
                        <img src="images\Screenshot 2025-01-12 154012.png" class="w-100 d-block" alt="Second slide">
                    </div>
            
                    <!-- Image Carousel Item 3 -->
                    <div class="carousel-item">
                        <img src="images\Screenshot 2025-01-12 154355.png" class="w-100 d-block" alt="Third slide">
                    </div>
            
                    <!-- Image Carousel Item 4 (New) -->
                    <div class="carousel-item">
                        <img src="images\Screenshot 2025-01-12 154841.png" class="w-100 d-block" alt="Fourth slide">
                    </div>
            
                    <!-- Video Carousel Item 5 (New) -->
                    <div class="carousel-item">
                        <video class="w-100 d-block" autoplay muted loop id="video2">
                            <source src="images\videoplayback (1).mp4" type="video/mp4">
                            Your browser does not support the video tag.
                        </video>
                    </div>
                </div>
            
                <button class="carousel-control-prev" type="button" data-bs-target="#carouselId" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#carouselId" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
            
        
            

        <div
                class="container mt-5 col-12"
                style="background: rgba(139, 80, 253, 0);
                border-radius: 50px;
            text-align: center;
            ">
            
            <h2 class=""   style="text-align: center; color:  rgb(185, 185, 196); ">Categories</h2>
                <div
                    class="row justify-content-center align-items-center "
                >
                    <div class="col " style="text-align: center;">
                        <button type="button" class="btn " onclick="window.location.href='HomePage?Category=Automotive';">
                            <img  class="rounded-circle" src="https://as1.ftcdn.net/v2/jpg/02/71/52/04/1000_F_271520480_kLKjlmiRHvV8tX0mvGhUNIY1drgmEZ3o.jpg" alt="Button Image" height="70" width="70" />
                            <div><h5 style="color: white;">Automative</h5></div>
                        </button>
                        
                    </div>
                    <div class="col " style="text-align: center;">
                        <button type="button" class="btn " onclick="window.location.href='HomePage?Category=Beauty';">
                            <img  class="rounded-circle" src="https://thumbs.dreamstime.com/b/cream-neon-icon-elements-women-s-accessories-set-simple-websites-web-design-mobile-app-info-graphics-dark-gradient-151367347.jpg" alt="Button Image" height="70" width="70" />
                            <div><h5 style="color: white;">Beauty</h5></div>
                        </button>
                        
                    </div>
                    <div class="col " style="text-align: center;">
                        <button type="button" class="btn " onclick="window.location.href='HomePage?Category=Books';">
                            <img  class="rounded-circle" src="https://i.pinimg.com/736x/ac/b5/2c/acb52c61be9fbbf8bc14256cbdaa7d0d.jpg" alt="Button Image" height="70" width="70" />
                            <div><h5 style="color: white;">Books</h5></div>
                        </button>
                        
                    </div>
                    <div class="col " style="text-align: center;">
                        <button type="button" class="btn " onclick="window.location.href='HomePage?Category=Clothing';">
                            <img  class="rounded-circle" src="https://i.pinimg.com/736x/ee/ca/8e/eeca8e559c83f8988116dc6565dad1d8.jpg" alt="Button Image" height="70" width="70" />
                            <div><h5 style="color: white;">Clothing</h5></div>
                        </button>
                        
                    </div>
                    <div class="col " style="text-align: center;">
                        <button type="button" class="btn " onclick="window.location.href='HomePage?Category=Electronics';">
                            <img  class="rounded-circle" src="https://images.rawpixel.com/image_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDI0LTA0L2ZyZWVpbWFnZXNjb21wYW55X3NpbXBsZV9saW5lX25lb25fb2ZfY29tcHV0ZXJfaWNvbl9pbl90aGVfc3R5bF9kMjg4NWRlMC01MTRhLTQ2YzktOGM4MC02MjY3ODNjYTg5ZTZfMS5qcGc.jpg" alt="Button Image" height="70" width="70" />
                            <div><h5 style="color: white;">Electronics</h5></div>
                        </button>
                        
                    </div>
                    <div class="col " style="text-align: center;">
                        <button type="button" class="btn " onclick="window.location.href='HomePage?Category=Food';">
                            <img  class="rounded-circle" src="https://as1.ftcdn.net/v2/jpg/02/49/13/92/1000_F_249139286_M99CAMRTPC84D4H300wK5CnHXQ8ccdbp.jpg" alt="Button Image" height="70" width="70" />
                            <div><h5 style="color: white;">Food</h5></div>
                        </button>
                        
                    </div>
                    
                </div>
                
                <div
                    class="row justify-content-center align-items-center "
                >
                    <div class="col " style="text-align: center;">
                        <button type="button" class="btn " onclick="window.location.href='HomePage?Category=Furniture';">
                            <img  class="rounded-circle" src="https://static.vecteezy.com/system/resources/previews/020/377/648/non_2x/furniture-table-lamp-neon-glow-icon-illustration-vector.jpg" alt="Button Image" height="70" width="70"/>
                            <div><h5 style="color: white;">Furniture</h5></div>
                        </button>
                        
                    </div>
                    <div class="col " style="text-align: center;">
                        <button type="button" class="btn " onclick="window.location.href='HomePage?Category=Gardening';">
                            <img  class="rounded-circle" src="https://img.freepik.com/premium-vector/flower-pot-neon-sign-gardening-agriculture-concept_98480-402.jpg" alt="Button Image" height="70" width="70" />
                            <div><h5 style="color: white;">Gardening</h5></div>
                        </button>
                        
                    </div>
                    <div class="col " style="text-align: center;">
                        <button type="button" class="btn " onclick="window.location.href='HomePage?Category=Healthcare';">
                            <img  class="rounded-circle" src="https://img.freepik.com/premium-vector/bright-luminous-pink-medical-digital-medical-neon-sign-pharmacy-hospital-store-beautiful-shiny-with-stethoscope-phonendoscope-black-background-vector-illustration_549897-3000.jpg" alt="Button Image" height="70" width="70" />
                            <div><h5 style="color: white;">Healthcare</h5></div>
                        </button>
                        
                    </div>
                    <div class="col " style="text-align: center;">
                        <button type="button" class="btn " onclick="window.location.href='HomePage?Category=Kitchen';">
                            <img  class="rounded-circle" src="https://img.freepik.com/premium-vector/multicooker-neon-sign-glowing-icon-kitchen-appliances-vector-illustration-design-cooking-concept_98480-2521.jpg" alt="Button Image" height="70" width="70"/>
                            <div><h5 style="color: white;">Kitchen</h5></div>
                        </button>
                        
                    </div>
                    <div class="col " style="text-align: center;">
                        <button type="button" class="btn " onclick="window.location.href='HomePage?Category=Sports';">
                            <img  class="rounded-circle" src="https://static.vecteezy.com/system/resources/previews/020/548/197/non_2x/footwear-fitness-sport-neon-glow-icon-illustration-vector.jpg" alt="Button Image" height="70" width="70" />
                            <div><h5 style="color: white;">Sports</h5></div>
                        </button>
                        
                    </div>
                    <div class="col " style="text-align: center;">
                        <button type="button" class="btn " onclick="window.location.href='HomePage?Category=Toys';">
                            <img  class="rounded-circle" src="https://as1.ftcdn.net/v2/jpg/02/71/16/76/1000_F_271167667_4prlbxlZfHTiJ2BgiOCfG2zaItZrgK5b.jpg" alt="Button Image" height="70" width="70" />
                            <div><h5 style="color: white;">Toys</h5></div>
                        </button>
                        
                    </div>
                    
                </div>
                
            </div>

            
        <div class="container mt-5 mb-5" style="text-align: center;">
            <h2 class="mt-2" style="color: rgb(185, 185, 196);"><bold>Our Featured Products</bold></h2>
            <div class="row justify-content-center align-items-center g-4 mt-2" style="margin-left: 20px;">
                <div class="col-md-4">
                    <div class="card" style="width: 18rem;background-color: #525092; position: relative; border-radius: 15px;">
                        <img class="card-img-top" src="https://www.melora.sa/cdn/shop/products/hydro-peel-glow-potion-10percent-aha-2percent-bha-exfoliating-serum-30ml-melora-6-23861385494667.jpg?v=1692798130" alt="Skincare Product" style="border-radius: 15px;" />
                        <h5 class="card-title" style="position: absolute; bottom: 50px; left: 50%; transform: translateX(-50%); color: rgba(255, 255, 255, 1); background-color: rgba(128, 0, 128, 0.5); padding: 5px;">Dot & Key</h5>
                        <button class="btn" id="unique-button" style="position: absolute; bottom: 10px; left: 50%; transform: translateX(-50%); background-color: #420853; border: none; color: white;" onclick="window.location.href='HomePage?Category=Beauty';">View Details</button>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card" style="width: 18rem;background-color: #525092; position: relative; border-radius: 15px;">
                        <img class="card-img-top" src="https://www.boat-lifestyle.com/cdn/shop/files/WaveSigma-FI_Blue02_1500x.png?v=1702009260" alt="Smartwatch" style="border-radius: 15px;" />
                        <h5 class="card-title" style="position: absolute; bottom: 50px; left: 50%; transform: translateX(-50%); color: rgba(255, 255, 255, 1); background-color: rgba(128, 0, 128, 0.5); padding: 5px;">Boat</h5>
                        <button class="btn" id="unique-button" style="position: absolute; bottom: 10px; left: 50%; transform: translateX(-50%); background-color: #420853; border: none; color: white;" onclick="window.location.href='HomePage?Category=Electronics';">View Details</button>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card" style="width: 18rem;background-color: #525092; position: relative; border-radius: 15px;">
                        <img class="card-img-top" src="https://ihascupquake.com/cdn/shop/files/iHC_AppIcons-iphonemock.png?v=1684543224&width=1445" alt="Phone" style="border-radius: 15px;" />
                        <h5 class="card-title" style="position: absolute; bottom: 50px; left: 50%; transform: translateX(-50%); color: rgba(255, 255, 255, 1); background-color: rgba(128, 0, 128, 0.5); padding: 5px;">IPhone 15</h5>
                        <button class="btn" id="unique-button" style="position: absolute; bottom: 10px; left: 50%; transform: translateX(-50%); background-color: #420853; border: none; color: white;"onclick="window.location.href='HomePage?Category=Electronics';" >View Details</button>
</div>
                </div>
            </div>
            <div class="row justify-content-center align-items-center g-4 mt-2" style="margin-left: 20px;">
                <div class="col-md-4">
                    <div class="card" style="width: 18rem;background-color: #525092; position: relative; border-radius: 15px;">
                        <img class="card-img-top" src="https://i.pinimg.com/736x/b4/a3/15/b4a315ea477cbc37632175c22e049793.jpg" alt="Best Selling" style="border-radius: 15px;" />
                        <h5 class="card-title" style="position: absolute; bottom: 50px; left: 50%; transform: translateX(-50%); color: rgba(255, 255, 255, 1); background-color: rgba(128, 0, 128, 0.5); padding: 5px;">HP Collection</h5>
                        <button class="btn" id="unique-button" style="position: absolute; bottom: 10px; left: 50%; transform: translateX(-50%); background-color: #420853; border: none; color: white;" onclick="window.location.href='HomePage?Category=Books';">View Details</button>
</div>
                </div>
                <div class="col-md-4">
                    <div class="card" style="width: 18rem;background-color: #525092; position: relative; border-radius: 15px;">
                        <img class="card-img-top" src="https://imgcdn.stablediffusionweb.com/2024/10/21/76f31589-f0bb-4dfe-87b6-a7dd19ddf9e4.jpg" alt="Looks Matter" style="border-radius: 15px;" />
                        <h5 class="card-title" style="position: absolute; bottom: 50px; left: 50%; transform: translateX(-50%); color: rgba(255, 255, 255, 1); background-color: rgba(128, 0, 128, 0.5); padding: 5px;">New Balance</h5>
                        <button class="btn" id="unique-button" style="position: absolute; bottom: 10px; left: 50%; transform: translateX(-50%); background-color: #420853; border: none; color: white;" onclick="window.location.href='HomePage?Category=Sports';">View Details</button>
</div>
                </div>
                <div class="col-md-4">
                    <div class="card" style="width: 18rem;background-color: #525092; position: relative; border-radius: 15px;">
                        <img class="card-img-top" src="https://media-photos.depop.com/b1/38640085/1412907693_e733b4b7278e4e15afcf6244a1144870/P0.jpg" alt="KAWS for your kid" style="border-radius: 15px;" />
                        <h5 class="card-title" style="position: absolute; bottom: 50px; left: 50%; transform: translateX(-50%); color: rgba(255, 255, 255, 1); background-color: rgba(128, 0, 128, 0.5); padding: 5px;">KAWS</h5>
                        <button class="btn" id="unique-button"  style="position: absolute; bottom: 10px; left: 50%; transform: translateX(-50%); background-color: #420853; border: none; color: white;" onclick="window.location.href='HomePage?Category=Toys';">View Details</button>

                    </div>
                </div>
            </div>
        </div>
        
        
        
            
            
            
        </main>
        <footer>
            <!-- place footer here -->
        </footer>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/particles.js@2.0.0/particles.min.js"></script>
        <script>
            particlesJS("particles-js", {
                particles: {
                    number: {
                        value: 80,
                        density: { enable: true, value_area: 800 },
                    },
                    color: { value: "#ffffff" },
                    shape: {
                        type: "circle",
                        stroke: { width: 0, color: "#000000" },
                        polygon: { nb_sides: 5 },
                        image: { src: "img/github.svg", width: 100, height: 100 },
                    },
                    opacity: {
                        value: 0.5,
                        random: false,
                        anim: {
                            enable: false,
                            speed: 1,
                            opacity_min: 0.1,
                            sync: false,
                        },
                    },
                    size: {
                        value: 5,
                        random: true,
                        anim: {
                            enable: false,
                            speed: 40,
                            size_min: 0.1,
                            sync: false,
                        },
                    },
                    line_linked: {
                        enable: true,
                        distance: 150,
                        color: "#ffffff",
                        opacity: 0.4,
                        width: 1,
                    },
                    move: {
                        enable: true,
                        speed: 6,
                        direction: "none",
                        random: false,
                        straight: false,
                        out_mode: "out",
                        bounce: false,
                        attract: {
                            enable: false,
                            rotateX: 600,
                            rotateY: 1200,
                        },
                    },
                },
                interactivity: {
                    detect_on: "canvas",
                    events: {
                        onhover: { enable: true, mode: "repulse" },
                        onclick: { enable: true, mode: "push" },
                        resize: true,
                    },
                    modes: {
                        grab: { distance: 400, line_linked: { opacity: 1 } },
                        bubble: {
                            distance: 400,
                            size: 40,
                            duration: 2,
                            opacity: 8,
                            speed: 3,
                        },
                        repulse: { distance: 200, duration: 0.4 },
                        push: { particles_nb: 4 },
                        remove: { particles_nb: 2 },
                    },
                },
                retina_detect: true,
            });
    </script><script>     
    var myCarousel = document.getElementById('carouselId')
    var carousel = new bootstrap.Carousel(myCarousel, {
        interval: 7000,  // Time for automatic slide change (7 seconds)
        ride: 'carousel'  // Start automatically when the page loads
    });


        </script>
    </body>
</html>





    