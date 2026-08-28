// Renders one rotating STL viewer per entry in window.reModels, appended
// to the .moodboard grid. Removes the cells if WebGL/CDN is unavailable.
(async function () {
    const models = window.reModels || [];
    const grid = document.querySelector(".moodboard");
    if (models.length === 0 || grid === null) { return; }

    const cells = models.map((src) => {
        const cell = document.createElement("div");
        cell.className = "stl-viewer";
        grid.appendChild(cell);
        return { cell, src };
    });

    let THREE, STLLoader, OrbitControls;
    try {
        THREE = await import("https://cdn.jsdelivr.net/npm/three@0.160.1/+esm");
        ({ STLLoader } = await import("https://cdn.jsdelivr.net/npm/three@0.160.1/examples/jsm/loaders/STLLoader.js/+esm"));
        ({ OrbitControls } = await import("https://cdn.jsdelivr.net/npm/three@0.160.1/examples/jsm/controls/OrbitControls.js/+esm"));
    } catch (error) {
        cells.forEach(({ cell }) => cell.remove());
        return;
    }

    const loader = new STLLoader();

    cells.forEach(({ cell, src }) => {
        loader.load(src, (geometry) => {
            const scene = new THREE.Scene();
            const camera = new THREE.PerspectiveCamera(45, 1, 0.1, 10000);
            const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
            renderer.setPixelRatio(window.devicePixelRatio);
            cell.appendChild(renderer.domElement);

            geometry.center();
            geometry.computeBoundingSphere();
            const radius = geometry.boundingSphere.radius;

            const mesh = new THREE.Mesh(
                geometry,
                new THREE.MeshStandardMaterial({ color: 0xb9bcc6, metalness: 0.3, roughness: 0.55 })
            );
            // STL files are usually modeled Z-up
            mesh.rotation.x = -Math.PI / 2;
            scene.add(mesh);

            scene.add(new THREE.HemisphereLight(0xffffff, 0x444455, 2.2));
            const keyLight = new THREE.DirectionalLight(0xffffff, 1.6);
            keyLight.position.set(1, 1, 1);
            scene.add(keyLight);

            camera.position.set(0, radius * 0.8, radius * 2.6);

            const controls = new OrbitControls(camera, renderer.domElement);
            controls.enableDamping = true;
            controls.autoRotate = true;
            controls.enableZoom = false;
            controls.enablePan = false;

            const resize = () => {
                renderer.setSize(cell.clientWidth, cell.clientHeight);
                camera.aspect = cell.clientWidth / cell.clientHeight;
                camera.updateProjectionMatrix();
            };
            new ResizeObserver(resize).observe(cell);
            resize();

            renderer.setAnimationLoop(() => {
                controls.update();
                renderer.render(scene, camera);
            });
        });
    });
})();
