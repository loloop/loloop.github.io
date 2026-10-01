// Expands moodboard images into a full-screen overlay when clicked.
(function () {
    const grid = document.querySelector(".moodboard");
    if (grid === null) { return; }

    const overlay = document.createElement("div");
    overlay.className = "lightbox";
    const full = document.createElement("img");
    full.alt = "";
    overlay.appendChild(full);
    document.body.appendChild(overlay);

    const close = () => overlay.classList.remove("visible");

    grid.addEventListener("click", (event) => {
        const image = event.target.closest("img");
        if (image === null) { return; }
        full.src = image.src;
        overlay.classList.add("visible");
    });

    overlay.addEventListener("click", close);
    document.addEventListener("keydown", (event) => {
        if (event.key === "Escape") { close(); }
    });
})();
