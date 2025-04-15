document.addEventListener('DOMContentLoaded', () => {
    const jsConfetti = new JSConfetti();
    const emojis = Array.from(document.querySelectorAll('.emoji')); 
    const splashSound = new Audio(SPLASH_SOUND_URL);
    const applauseSound = new Audio(APPLAUSE_SOUND_URL);
    const pastelColors = [
        '#FFB3BA',
        '#BAFFC9',
        '#BAE1FF',
        '#FFFFBA',
        '#FFD1DC',
        '#B0E0E6',
        '#98FB98',
        '#DDA0DD'
    ];
    let currentEmojiIndex = 0;
    emojis[currentEmojiIndex].classList.add('active');
    const emojiColors = emojis.map((_, index) => 
        pastelColors[index % pastelColors.length]
    );
    function checkIfBaseCircleIsColored(svg) {
        const baseCircle = svg.querySelector('circle.fl-colorable');
        if (baseCircle) {
            const fillColor = baseCircle.style.fill;
            const expectedColor = emojiColors[currentEmojiIndex];
            return fillColor === expectedColor || fillColor === getRGBFromHex(expectedColor);
        }
        return false;
    }
    function getRGBFromHex(hex) {
        const r = parseInt(hex.slice(1, 3), 16);
        const g = parseInt(hex.slice(3, 5), 16);
        const b = parseInt(hex.slice(5, 7), 16);
        return `rgb(${r}, ${g}, ${b})`;
    }
    function moveToNextEmoji() {
        setTimeout(() => {
            emojis[currentEmojiIndex].classList.remove('active');
            currentEmojiIndex = (currentEmojiIndex + 1) % emojis.length;
            if (currentEmojiIndex === 0) {
                jsConfetti.addConfetti({
                    confettiNumber: 500
                });
                applauseSound.play();
            }
            resetEmojiColors(emojis[currentEmojiIndex]);
            emojis[currentEmojiIndex].classList.add('active');
        }, 750); 
    }
    function resetEmojiColors(svg) {
        const colorableElements = svg.querySelectorAll('.fl-colorable');
        colorableElements.forEach(element => {
            if (element.classList.contains('stroke')) {
                element.style.stroke = ''; 
            } else {
                element.style.fill = ''; 
            }
        });
    }
    emojis.forEach((svg, index) => {
        const colorableElements = svg.querySelectorAll('.fl-colorable');
        colorableElements.forEach(element => {
            element.addEventListener('click', () => {
                splashSound.play();
                const currentColor = emojiColors[currentEmojiIndex];
                if (element.classList.contains('stroke')) {
                    element.style.stroke = currentColor;
                } else {
                    element.style.fill = currentColor;
                }
                setTimeout(() => {
                    if (checkIfBaseCircleIsColored(svg)) {
                        moveToNextEmoji();
                    }
                }, 100);
            });
        });
    });
});