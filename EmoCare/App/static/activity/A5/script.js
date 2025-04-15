const canvas = document.getElementById('gameCanvas');
const ctx = canvas.getContext('2d');
const gameEmotions = [
    { emotion: "Happy", imageUrl: EMOTION_URLS.Happy },
    { emotion: "Sad", imageUrl: EMOTION_URLS.Sad },
    { emotion: "Angry", imageUrl: EMOTION_URLS.Angry },
    { emotion: "Surprise", imageUrl: EMOTION_URLS.Surprise },
    { emotion: "Neutral", imageUrl: EMOTION_URLS.Neutral },
    { emotion: "Fear", imageUrl: EMOTION_URLS.Fear }
];
let currentEmotion = null;
let options = [];
let loadedImages = {};
let isShaking = false;
let shakeStartTime = 0;
let score = 0;
const shakeDuration = 500;
const backgroundImage = new Image();
backgroundImage.src = BACKGROUND_IMAGE_URL;
const correctSound = new Audio(CORRECT_SOUND_URL);
const wrongSound = new Audio(WRONG_SOUND_URL);
function loadImages() {
    gameEmotions.forEach(item => {
        const img = new Image();
        img.src = item.imageUrl;
        loadedImages[item.emotion] = img;
    });
}
function getRandomEmotion(exclude = []) {
    const available = gameEmotions.filter(item => !exclude.includes(item.emotion));
    return available[Math.floor(Math.random() * available.length)];
}
function generateNewRound() {
    currentEmotion = getRandomEmotion();
    options = [currentEmotion];
    while (options.length < 3) {
        const newEmotion = getRandomEmotion(options.map(o => o.emotion));
        options.push(newEmotion);
    }
    options = options.sort(() => Math.random() - 0.5);
}
function isInsideCircle(x, y, circleX, circleY, radius) {
    const dx = x - circleX;
    const dy = y - circleY;
    return dx * dx + dy * dy <= radius * radius;
}
function handleClick(event) {
    if (isShaking) return;
    const rect = canvas.getBoundingClientRect();
    const mouseX = event.clientX - rect.left;
    const mouseY = event.clientY - rect.top;
    for (const option of options) {
        const size = canvas.width * 0.064;
        const x = canvas.width * (0.25 + options.indexOf(option) * 0.25) - size / 2;
        const y = canvas.height * 0.90 - size;
        const centerX = x + size / 2;
        const centerY = y + size / 2;
        if (isInsideCircle(mouseX, mouseY, centerX, centerY, size / 2)) {
            if (option.emotion === currentEmotion.emotion) {
                correctSound.play();
                score += 1;
                generateNewRound();
            } else {
                wrongSound.play();
                isShaking = true;
                shakeStartTime = performance.now();
            }
            break;
        }
    }
}
function getShakeOffset() {
    if (!isShaking) return 0;
    const elapsed = performance.now() - shakeStartTime;
    if (elapsed < shakeDuration) {
        return Math.sin(elapsed * 0.3) * 10;
    } else {
        isShaking = false;
        return 0;
    }
}
function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    if (backgroundImage.complete) {
        const scale = Math.max(
            canvas.width / backgroundImage.width,
            canvas.height / backgroundImage.height
        );
        const newWidth = backgroundImage.width * scale;
        const newHeight = backgroundImage.height * scale;
        const x = (canvas.width - newWidth) / 2;
        const y = (canvas.height - newHeight) / 2;
        ctx.drawImage(backgroundImage, x, y, newWidth, newHeight);
    }
    const shakeOffset = getShakeOffset();
    const mainSize = canvas.width * 0.20;
    const mainX = canvas.width / 2 - mainSize / 2;
    const mainY = canvas.height * 0.15;
    if (currentEmotion && loadedImages[currentEmotion.emotion]) {
        ctx.drawImage(loadedImages[currentEmotion.emotion], mainX, mainY, mainSize, mainSize);
    }
    options.forEach((option, index) => {
        const size = canvas.width * 0.064;
        const x = canvas.width * (0.25 + index * 0.25) - size / 2;
        const y = canvas.height * 0.90 - size;
        if (loadedImages[option.emotion]) {
            ctx.drawImage(loadedImages[option.emotion], x + shakeOffset, y, size, size);
        }
        ctx.beginPath();
        ctx.arc(x + size / 2 + shakeOffset, y + size / 2, size / 2 + 2, 0, Math.PI * 2);
        ctx.strokeStyle = '#FFFFFF';
        ctx.lineWidth = 3;
        ctx.stroke();
    });
    ctx.font = 'bold 24px Arial';
    ctx.fillStyle = 'black';
    ctx.textAlign = 'right';
    ctx.fillText(`Score: ${score}`, canvas.width - 20, 35);
}
function animate() {
    draw();
    requestAnimationFrame(animate);
}
function init() {
    loadImages();
    generateNewRound();
    canvas.addEventListener('click', handleClick);
    canvas.addEventListener('mousemove', (event) => {
        const rect = canvas.getBoundingClientRect();
        const mouseX = event.clientX - rect.left;
        const mouseY = event.clientY - rect.top;
        const isOverOption = options.some((option, index) => {
            const size = canvas.width * 0.064;
            const x = canvas.width * (0.25 + index * 0.25) - size / 2;
            const y = canvas.height * 0.90 - size;
            return isInsideCircle(mouseX, mouseY, x + size / 2, y + size / 2, size / 2);
        });
        canvas.style.cursor = isOverOption ? 'pointer' : 'default';
    });
}
init();
animate();