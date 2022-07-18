var toggler = document.getElementById("toggle-sidebar");
var sidebar = document.getElementById("sidebar");

toggler.addEventListener("click", function (event) {
  event.preventDefault();
  sidebar.classList.toggle("hidden");
});
