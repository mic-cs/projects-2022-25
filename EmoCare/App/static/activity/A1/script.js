document.addEventListener('DOMContentLoaded', function() {
    const jsConfetti = new JSConfetti();
    const button = document.getElementById('drinkButton');
    const svg = document.querySelector('svg');
    const sipCounter = document.getElementById('sipCounter');
    button.textContent = 'Take a Sip!';
    const quackSound = new Audio(QUACK_SOUND_URL);
    const yaySound = new Audio(YAY_SOUND_URL);
    const applauseSound = new Audio(APPLAUSE_SOUND_URL);
    let sipCount = 0;
    const totalSips = 5;
    function resetGame() {
        sipCount = 0;
        button.disabled = false;
        button.textContent = 'Take a Sip!';
        sipCounter.textContent = `Sips: ${sipCount}/${totalSips}`;
        const rect = document.querySelector('#fullClip rect');
        rect.setAttribute('y', '2650');
    }
    svg.addEventListener('animationend', () => {
        svg.classList.remove('wiggle-animation');
    });
    button.addEventListener('click', function() {
        if (sipCount >= totalSips) {
            resetGame();
            return;
        }
        if (sipCount < totalSips - 1) {
            quackSound.currentTime = 0;
            quackSound.play();
        }
        svg.classList.remove('wiggle-animation');
        void svg.offsetWidth;
        svg.classList.add('wiggle-animation');
        const rect = document.querySelector('#fullClip rect');
        const startY = 2650;
        const endY = 500;
        const totalDistance = startY - endY;
        const distancePerSip = totalDistance / totalSips;
        sipCount++;
        sipCounter.textContent = `Sips: ${sipCount}/${totalSips}`;
        const targetY = startY - (distancePerSip * sipCount);
        const duration = 1000;
        const startTime = performance.now();
        const animationStartY = parseInt(rect.getAttribute('y'));
        function animate(currentTime) {
            const elapsed = currentTime - startTime;
            const progress = Math.min(elapsed / duration, 1);
            const newY = animationStartY - (animationStartY - targetY) * progress;
            rect.setAttribute('y', newY);
            if (progress < 1) {
                requestAnimationFrame(animate);
            }
        }
        requestAnimationFrame(animate);
        if (sipCount >= totalSips) {
            button.textContent = 'Take a Drink Again!';
            yaySound.currentTime = 0;
            yaySound.play();
            applauseSound.currentTime = 0;
            applauseSound.play();
            jsConfetti.addConfetti({
                confettiNumber: 500
            });
        }
    });
});