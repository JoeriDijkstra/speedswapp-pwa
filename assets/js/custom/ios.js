// Detects if device is on Ios
const isIos = () => {
    const userAgent = window.navigator.userAgent.toLowerCase();
    return /iphone|ipad|ipod/.test(userAgent);
}

// Detects if device is in standalone mode
const isInStandaloneMode = () => ('standalone' in window.navigator) && (window.navigator.standalone);
const popup = document.querySelectorAll(".show-safari");
const IOSDismissedComponent = document.querySelector("#pwa-dismiss")

function UpdateIOSComponents() {
    const isDismissed = sessionStorage.getItem("safari-dismissed") != null

    console.log(isDismissed)

    if (isIos() && !isInStandaloneMode() && !isDismissed) {
        popup.forEach(element => {
            element.classList.remove("hidden")
        });
    };
}

function UpdateIOSDismissed() {
    sessionStorage.setItem("safari-dismissed", true)
    popup.forEach(element => {
        element.classList.add("hidden")
    });
}

export { UpdateIOSDismissed, UpdateIOSComponents, IOSDismissedComponent };