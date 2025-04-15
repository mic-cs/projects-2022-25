const canvas = document.getElementById('gameCanvas');
const ctx = canvas.getContext('2d');
const circles = [
    { color: '#B8D8E3', sound: SOUND_URLS.sound1, x: 0, y: 0, originalRadius: 0, currentRadius: 0 },
    { color: '#456F7C', sound: SOUND_URLS.sound2, x: 0, y: 0, originalRadius: 0, currentRadius: 0 },
    { color: '#1D3B35', sound: SOUND_URLS.sound3, x: 0, y: 0, originalRadius: 0, currentRadius: 0 },
    { color: '#7A9A64', sound: SOUND_URLS.sound4, x: 0, y: 0, originalRadius: 0, currentRadius: 0 },
    { color: '#E88D97', sound: SOUND_URLS.sound5, x: 0, y: 0, originalRadius: 0, currentRadius: 0 },
    { color: '#FFC4D6', sound: SOUND_URLS.sound6, x: 0, y: 0, originalRadius: 0, currentRadius: 0 },
    { color: '#F9EBE0', sound: SOUND_URLS.sound7, x: 0, y: 0, originalRadius: 0, currentRadius: 0 },
    { color: '#1B1F32', sound: SOUND_URLS.sound8, x: 0, y: 0, originalRadius: 0, currentRadius: 0 }
];
const backgroundImage = new Image();
backgroundImage.src = BACKGROUND_IMAGE_URL;
circles.forEach((circle, index) => {
    circle.audio = new Audio(circle.sound);
});
function updateCirclePositions() {
    const spacing = canvas.width * 0.05;  
    const totalWidth = canvas.width * 0.75;  
    const maxCircleWidth = totalWidth / 4;
    const maxCircleHeight = canvas.height * 0.3 / 2;  
    const circleRadius = Math.min(maxCircleWidth, maxCircleHeight) * 0.5;  
    const gridWidth = (circleRadius * 2 * 4) + (spacing * 3);
    const gridHeight = (circleRadius * 2 * 2) + (spacing * 1.1);  
    const startX = (canvas.width - gridWidth) / 2;
    const startY = (canvas.height - gridHeight) / 2;
    circles.forEach((circle, index) => {
        const row = Math.floor(index / 4);
        const col = index % 4;
        circle.originalRadius = circleRadius;
        circle.currentRadius = circleRadius;
        circle.x = startX + col * (circleRadius * 2 + spacing) + circleRadius;
        circle.y = startY + row * (circleRadius * 2 + spacing * 1.2) + circleRadius;
    });
}
function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.drawImage(backgroundImage, 0, 0, canvas.width, canvas.height);
    circles.forEach(circle => {
        ctx.beginPath();
        ctx.arc(circle.x, circle.y, circle.currentRadius, 0, Math.PI * 2);
        if (circle.isGlowing) {
            ctx.shadowColor = circle.color;
            ctx.shadowBlur = 35;
            ctx.shadowOffsetX = 0;
            ctx.shadowOffsetY = 0;
            for(let i = 0; i < 4; i++) {
                ctx.fill();
            }
            const brighterColor = adjustBrightness(circle.color, 50);
            ctx.fillStyle = brighterColor;
            ctx.fill();
            ctx.fillStyle = '#ffffff';
            ctx.globalAlpha = 0.4;
            ctx.fill();
            ctx.globalAlpha = 1.0;
        } else {
            ctx.fillStyle = circle.color;
            ctx.fill();
        }
        ctx.strokeStyle = 'black';
        ctx.lineWidth = 4;
        ctx.stroke();
        ctx.closePath();
        ctx.shadowColor = 'transparent';
        ctx.shadowBlur = 0;
    });
}
function handleClick(event) {
    const rect = canvas.getBoundingClientRect();
    const x = event.clientX - rect.left;
    const y = event.clientY - rect.top;
    circles.forEach(circle => {
        const distance = Math.sqrt((x - circle.x) ** 2 + (y - circle.y) ** 2);
        if (distance <= circle.currentRadius) {
            circle.audio.currentTime = 0;
            circle.audio.play();
            circle.isGlowing = true;
            const animationDuration = 150;
            const startTime = performance.now();
            const startRadius = circle.originalRadius;
            const shrinkTo = circle.originalRadius * 0.85;
            function animate(currentTime) {
                const elapsed = currentTime - startTime;
                const progress = Math.min(elapsed / animationDuration, 1);
                if (progress < 0.5) {
                    circle.currentRadius = startRadius - (startRadius - shrinkTo) * (progress * 2);
                } else {
                    circle.currentRadius = shrinkTo + (startRadius - shrinkTo) * ((progress - 0.5) * 2);
                }
                if (progress === 1) {
                    circle.isGlowing = false;
                }
                draw();
                if (progress < 1) {
                    requestAnimationFrame(animate);
                }
            }
            requestAnimationFrame(animate);
        }
    });
}
function init() {
    updateCirclePositions();
    draw();
}
window.addEventListener('load', init);
window.addEventListener('resize', () => {
    updateCirclePositions();
    draw();
});
canvas.addEventListener('click', handleClick);
function animate() {
    draw();
    requestAnimationFrame(animate);
}
animate();
function adjustBrightness(color, percent) {
    const num = parseInt(color.replace('#', ''), 16),
        amt = Math.round(2.55 * percent),
        R = Math.min(255, ((num >> 16) + amt)),
        G = Math.min(255, (((num >> 8) & 0x00FF) + amt)),
        B = Math.min(255, ((num & 0x0000FF) + amt));
    return '#' + (0x1000000 + (R << 16) + (G << 8) + B).toString(16).slice(1);
}