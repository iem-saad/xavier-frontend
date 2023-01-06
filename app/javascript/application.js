// Entry point for the build script in your package.json
import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false
import "./controllers"
import './add_jquery'
// import "./custom/template.js"
// import "./vendor/aos/aos.css"
// import "./vendor/aos/aos.js"
// import "./vendor/swiper/swiper-bundle.min.css"
// import "./vendor/swiper/swiper-bundle.min.js"
// import "./vendor/bootstrap/css/bootstrap.min.css"
// import "./vendor/bootstrap-icons/bootstrap-icons.css"
// import "./vendor/boxicons/css/boxicons.min.css"
// import "./vendor/glightbox/css/glightbox.min.css"
import * as bootstrap from "bootstrap"
