const nav = document.querySelector(".nav");
let lastScrollY = window.scrollY;

function scroll (){
    if (lastScrollY < window.scrollY && window.scrollY > 0) {
      nav.classList.add("nav--hidden")
    } else {
      nav.classList.remove("nav--hidden")
    }
  
    lastScrollY = window.scrollY;
}

export { scroll }