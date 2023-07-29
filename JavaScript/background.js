var position = { width: 0, height: 0 };
var velocity = { width: 5, height: 3 };
var rotationAngle = 0;
var unitGamma = document.getElementById("unit-gamma");
var screenBounds = { width: window.innerWidth, height: window.innerHeight };

function startAnimating() {
    setInterval(function() {
        updatePosition();
    }, 20);
}

function updatePosition() {
    var newPosition = {
        width: position.width + velocity.width,
        height: position.height + velocity.height
    };

    if (newPosition.width <= 0 || newPosition.width >= screenBounds.width - 50) {
        velocity.width = -velocity.width;
    }

    if (newPosition.height <= 0 || newPosition.height >= screenBounds.height - 50) {
        velocity.height = -velocity.height;
    }

    position = newPosition;
    rotationAngle = Math.atan2(velocity.height, velocity.width) * 180 / Math.PI + 90;

    unitGamma.style.transform = "translate(" + position.width + "px, " + position.height + "px) rotate(" + rotationAngle + "deg)";
}

startAnimating();