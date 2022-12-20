/* side bar drawer */

//let sideNav = document.getElementById("mySidenav")
/* Set side bar width 240px */

/*let openNav = document.getElementById("openNav").addEventListener("click", () => {
    sideNav.style.width = "240px";
})
*/
/* Set the width of the side navigation to 0 */
/*
let closeNav = document.getElementById("closeNav").addEventListener("click", () => {
    sideNav.style.width = "0";
})
*/
let alternative = document.getElementById("alternative");
let competitive = document.getElementById("competitive");
let alternativeStatus = document.getElementById("alternative-status");
let competitiveStatus = document.getElementById("competitive-status");

alternative.addEventListener("click", () => {
    competitiveStatus.classList.add("hide");
    alternativeStatus.classList.remove("hide");
});

competitive.addEventListener("click", () => {
    competitiveStatus.classList.remove("hide");
    alternativeStatus.classList.add("hide");
});

/*
  let sideNav = document.getElementById("mySidenav")
  */
/* Set side bar width 240px */
/*
let openNav = document.getElementById("openNav").addEventListener("click", () => {
    sideNav.style.width = "240px";
})
*/
/* Set the width of the side navigation to 0 */
/*
let closeNav = document.getElementById("closeNav").addEventListener("click", () => {
    sideNav.style.width = "0";
})
*/
export {alternative, competitive}
