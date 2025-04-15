const canvas = document.getElementById('gameCanvas');
const ctx = canvas.getContext('2d');
const backgroundImage = new Image();
backgroundImage.src = BACKGROUND_IMAGE_URL;
const balloonImage = new Image();
balloonImage.src = BALLOON_IMAGE_URL;
const inhaleSound = new Audio(INHALE_SOUND_URL);
const exhaleSound = new Audio(EXHALE_SOUND_URL);
const clapSound = new Audio(CLAP_SOUND_URL);
let clapCount = 0;
let currentActionText = '';
let balloon = {
    x: 0,
    y: 0,
    width: 0,
    height: 0,
    originalWidth: 0,
    originalHeight: 0,
    isAnimating: false
};
let textScale = 1;
let lastActionText = '';
function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.drawImage(backgroundImage, 0, 0, canvas.width, canvas.height);
    ctx.drawImage(balloonImage, balloon.x, balloon.y, balloon.width, balloon.height);
    ctx.font = '24px Arial';
    ctx.fillStyle = 'white';
    ctx.textAlign = 'right';
    ctx.fillText(`Claps: ${clapCount.toString().padStart(3, '0')}`, canvas.width - 20, 40);
    ctx.textAlign = 'center';
    if (currentActionText) {
        ctx.font = 'bold 64px Arial';
        let gradient = ctx.createLinearGradient(
            canvas.width / 2 - 100,
            canvas.height * 0.99 - 30,
            canvas.width / 2 + 100,
            canvas.height * 0.99 + 30
        );
        gradient.addColorStop(0, '#FFD700');
        gradient.addColorStop(1, '#FFA500');
        ctx.fillStyle = gradient;
        ctx.strokeStyle = 'white';
        ctx.lineWidth = 4;
        const textY = canvas.height * 0.99;
        if (lastActionText !== currentActionText) {
            textScale = 1.5; 
            lastActionText = currentActionText;
        }
        textScale = textScale > 1 ? textScale * 0.95 : 1;
        ctx.save();
        ctx.translate(canvas.width / 2, textY);
        ctx.scale(textScale, textScale);
        ctx.strokeText(currentActionText, 0, 0);
        ctx.fillText(currentActionText, 0, 0);
        ctx.restore();
    }
}
function startBreathingExercise() {
    if (balloon.isAnimating) return;
    balloon.isAnimating = true;
    function breathingCycle() {
        inhaleSound.currentTime = 0;
        inhaleSound.play();
        currentActionText = 'INHALE';
        const startTime = performance.now();
        const expandTo = balloon.originalWidth * 2;
        function inhale(currentTime) {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / 2000, 1);
            const easedProgress = 1 - Math.cos((progress * Math.PI) / 2);
            balloon.width = balloon.originalWidth + (expandTo - balloon.originalWidth) * easedProgress;
            balloon.height = balloon.originalHeight + (expandTo - balloon.originalWidth) * easedProgress;
            balloon.x = (canvas.width - balloon.width) / 2;
            balloon.y = (canvas.height - balloon.height) / 2;
            if (progress < 1) {
                requestAnimationFrame(inhale);
            } else {
                setTimeout(() => {
                    exhaleSound.currentTime = 0;
                    exhaleSound.play();
                    currentActionText = 'EXHALE';
                    const exhaleStart = performance.now();
                    function exhale(currentTime) {
                        const elapsed = currentTime - exhaleStart;
                        const progress = Math.min(elapsed / 2000, 1);
                        const easedProgress = Math.sin((progress * Math.PI) / 2);
                        balloon.width = expandTo - (expandTo - balloon.originalWidth) * easedProgress;
                        balloon.height = expandTo - (expandTo - balloon.originalHeight) * easedProgress;
                        balloon.x = (canvas.width - balloon.width) / 2;
                        balloon.y = (canvas.height - balloon.height) / 2;
                        if (progress < 1) {
                            requestAnimationFrame(exhale);
                        } else {
                            clapSound.currentTime = 0;
                            clapSound.play();
                            currentActionText = 'CLAP!';
                            clapCount++;
                            const clapStart = performance.now();
                            function clapAnimation(currentTime) {
                                const elapsed = currentTime - clapStart;
                                const progress = Math.min(elapsed / 300, 1);
                                const squishFactor = Math.sin(progress * Math.PI);
                                balloon.width = balloon.originalWidth * (1 - squishFactor * 0.2);
                                balloon.height = balloon.originalHeight * (1 + squishFactor * 0.2);
                                balloon.x = (canvas.width - balloon.width) / 2;
                                balloon.y = (canvas.height - balloon.height) / 2;
                                if (progress < 1) {
                                    requestAnimationFrame(clapAnimation);
                                } else {
                                    balloon.width = balloon.originalWidth;
                                    balloon.height = balloon.originalHeight;
                                    balloon.x = (canvas.width - balloon.width) / 2;
                                    balloon.y = (canvas.height - balloon.height) / 2;
                                    setTimeout(() => {
                                        if (balloon.isAnimating) {
                                            breathingCycle();
                                        }
                                    }, 1200);
                                }
                            }
                            requestAnimationFrame(clapAnimation);
                        }
                    }
                    requestAnimationFrame(exhale);
                }, 500);
            }
        }
        requestAnimationFrame(inhale);
    }
    breathingCycle();
}
function updateBalloonPosition() {
    balloon.originalHeight = canvas.height * 0.4;
    balloon.originalWidth = balloon.originalHeight * 0.8;
    balloon.width = balloon.originalWidth;
    balloon.height = balloon.originalHeight;
    balloon.x = (canvas.width - balloon.width) / 2;
    balloon.y = (canvas.height - balloon.height) / 2;
}
function init() {
    updateBalloonPosition();
    draw();
    startBreathingExercise(); 
}
window.addEventListener('load', init);
window.addEventListener('resize', () => {
    updateBalloonPosition();
    draw();
});
function animate() {
    draw();
    requestAnimationFrame(animate);
}
animate();
