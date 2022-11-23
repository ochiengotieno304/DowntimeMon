// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "chartkick"
import "Chart.bundle"


function showForm() {
  let form = document.getElementById("report-form");
  if (form.style.display === "none") {
    form.style.display = "block";
  }
}
