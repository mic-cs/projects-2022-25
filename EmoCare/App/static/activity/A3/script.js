const canvas = document.getElementById("gameCanvas");
const ctx = canvas.getContext("2d");
const bgImage = new Image();
bgImage.src = BACKGROUND_IMAGE_URL;
const bubbleImage = new Image();
bubbleImage.src = BUBBLE_IMAGE_URL;
const popSound = new Audio(POP_SOUND_URL);
const entrySound = new Audio(ENTRY_SOUND_URL);
let score = 0;
let bubble = {
    x: 0,
    y: -100, 
    radius: 40, 
    targetX: 0,
    targetY: 0,
    speed: 5,
    isMoving: true,
    isPopping: false, 
    popStartTime: 0, 
    popDuration: 300, 
    initialRadius: 40, 
    maxPopRadius: 60, 
    opacity: 1, 
};
function generateBubble() {
    bubble.targetX = Math.random() * (canvas.width - 2 * bubble.radius) + bubble.radius;
    bubble.targetY = Math.random() * (canvas.height - 2 * bubble.radius) + bubble.radius;
    bubble.y = -bubble.radius; 
    bubble.isMoving = true; 
    bubble.isPopping = false; 
    bubble.opacity = 1; 
    bubble.radius = bubble.initialRadius; 
    entrySound.play();
}
function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height); 
    const bgRatio = bgImage.width / bgImage.height;
    const canvasRatio = canvas.width / canvas.height;
    let bgWidth, bgHeight, bgX, bgY;
    if (canvasRatio > bgRatio) {
        bgWidth = canvas.width;
        bgHeight = canvas.width / bgRatio;
    } else {
        bgHeight = canvas.height;
        bgWidth = canvas.height * bgRatio;
    }
    bgX = (canvas.width - bgWidth) / 2;
    bgY = (canvas.height - bgHeight) / 2;
    ctx.drawImage(bgImage, bgX, bgY, bgWidth, bgHeight);
    ctx.fillStyle = "white";
    ctx.font = "bold 24px Arial";
    ctx.textAlign = "right";
    ctx.fillText(`Score: ${String(score).padStart(3, "0")}`, canvas.width - 20, 30);
    if (!bubble.isPopping) {
        ctx.globalAlpha = bubble.opacity;
        ctx.drawImage(
            bubbleImage,
            bubble.x - bubble.radius, 
            bubble.y - bubble.radius, 
            bubble.radius * 2,       
            bubble.radius * 2        
        );
        ctx.globalAlpha = 1;
    }
    if (bubble.isPopping) {
        const elapsed = Date.now() - bubble.popStartTime;
        const progress = Math.min(elapsed / bubble.popDuration, 1); 
        bubble.radius = bubble.initialRadius + (bubble.maxPopRadius - bubble.initialRadius) * progress;
        bubble.opacity = 1 - progress;
        ctx.globalAlpha = bubble.opacity;
        ctx.drawImage(
            bubbleImage,
            bubble.x - bubble.radius, 
            bubble.y - bubble.radius, 
            bubble.radius * 2,       
            bubble.radius * 2        
        );
        ctx.globalAlpha = 1;
        if (progress >= 1) {
            bubble.isPopping = false;
            score++; 
            generateBubble();
        }
    }
}
function updateBubble() {
    if (!bubble.isMoving || bubble.isPopping) return;
    const dx = bubble.targetX - bubble.x;
    const dy = bubble.targetY - bubble.y;
    const distance = Math.sqrt(dx * dx + dy * dy);
    if (distance > bubble.speed) {
        bubble.x += (dx / distance) * bubble.speed;
        bubble.y += (dy / distance) * bubble.speed;
    } else {
        bubble.x = bubble.targetX;
        bubble.y = bubble.targetY;
        bubble.isMoving = false;
    }
}
function animate() {
    updateBubble();
    draw();
    requestAnimationFrame(animate);
}
canvas.addEventListener("click", function(event) {
    if (bubble.isPopping) return; 
    const rect = canvas.getBoundingClientRect();
    const mouseX = event.clientX - rect.left;
    const mouseY = event.clientY - rect.top;
    const distance = Math.sqrt((mouseX - bubble.x) ** 2 + (mouseY - bubble.y) ** 2);
    if (distance <= bubble.radius) {
        bubble.isPopping = true;
        bubble.popStartTime = Date.now();
        popSound.play();
    }
});
let imagesLoaded = 0;
function imageLoaded() {
    imagesLoaded++;
    if (imagesLoaded === 2) { 
        generateBubble();
        animate();
    }
}
bgImage.onload = imageLoaded;
bubbleImage.onload = imageLoaded;
