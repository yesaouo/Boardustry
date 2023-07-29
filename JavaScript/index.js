const signContainer = document.getElementsByClassName('sign-container')[0];
const pageContainer = document.getElementsByClassName('page-container')[0];
const gameContainer = document.getElementsByClassName('game-container')[0];
const homeContainer = document.getElementsByClassName('home-container')[0];
const menuContainer = document.getElementsByClassName('menu-container')[0];
const newsContainer = document.getElementsByClassName('news-container')[0];
const databaseContainer = document.getElementsByClassName('database-container')[0];
const formationContainer = document.getElementsByClassName('formation-container')[0];
const joingameContainer = document.getElementsByClassName('joingame-container')[0];

//sign-container
const loginAccount = document.getElementById('login-account');
const loginPassword = document.getElementById('login-password');
const registrationUsername = document.getElementById('registration-username');
const registrationAccount = document.getElementById('registration-account');
const registrationPassword = document.getElementById('registration-password');
const loginError = document.getElementById('login-error');
const registrationError = document.getElementById('registration-error');
const loginBtn = document.getElementById('login-btn');
const registrationBtn = document.getElementById('registration-btn');
const signupButton = document.querySelector(".signup-button");
const signinButton = document.querySelector(".signin-button");
const loginView = document.querySelector(".login-view");
const registrationView = document.querySelector(".registration-view");

//menu-container
const file = document.getElementById('file');
const newsBtn = document.getElementById('news-btn');
const logoutBtn = document.getElementById('logout-btn');

//database-container
const nowDisplay = document.querySelector(".now-display");
const changeDisplay = document.querySelector(".change-display");
const databaseUnits = document.querySelector(".database-units");
const databaseBlocks = document.querySelector(".database-blocks");
const databaseBack = document.querySelector(".database-back");

//news-container
const newsList = document.querySelector(".news-list");
const newsTime = document.querySelector(".news-time");
const newsBack = document.querySelector(".news-back");
const newsContent = document.getElementById("news-content");

//formation-container
const downloadBtn = document.getElementById('download-btn');
const uploadBtn = document.getElementById('upload-btn');
const uturnBtn = document.getElementById('uturn-btn');
const unitBtns = document.querySelectorAll('.unit-btn');
const icloudDown = document.getElementById('icloud-down');
const icloudUp = document.getElementById('icloud-up');
const counter = document.querySelector('.counter');
const formationTiles = document.querySelectorAll('.formation-tile');
const formationBoard = document.querySelector('.formation-board');
const formationTable = document.querySelector('.formation-table');

//joingame-container
const searchID = document.getElementById('searchID');
const roomList = document.getElementById('room-list');
const roomsContainer = document.querySelector('.rooms-container');
const addroomContainer = document.querySelector('.addroom-container');
const roomContainer = document.querySelector('.room-container');
const mapSize = document.getElementById("map-size");
const playerCount = document.getElementById("player-count");
const publicRoom = document.getElementById("public-room");
const createBtn = document.getElementById("create-btn");
const leaveBtn = document.getElementById("leave-btn");
const prepareBtn = document.getElementById("prepare-btn");
const roomHeader = document.querySelector('.room-header');
const roomContent = document.querySelector('.room-content');

//game-container
const gameHeader = document.querySelector('.game-header');
const gameBoard = document.querySelector('.game-board');
const gameSwitch = document.getElementById('game-switch');
const turnIndicator = document.querySelector('.turn-indicator');
const gameSelections = document.querySelectorAll('.game-selection');
const endRoundBtn = document.getElementById('end-round-btn');
const board = document.getElementById('board');
const gameMenuContainer = document.querySelector('.game-menu-container');
const gameQuit = document.getElementById('game-quit');
const bgMusic = document.getElementById('bg-music');
const volumeSlider = document.getElementById('volume-slider');

volumeSlider.addEventListener('input', function() {
    bgMusic.volume = this.value;
});

window.onload = function() {
    if('serviceWorker' in navigator) {
        navigator.serviceWorker.register('/Boardustry/sw.js')
            .then(() => { console.log('Service Worker Registered'); });
    }
};

//function
function Home() {
    menuContainer.style.display = 'none';
    formationContainer.style.display = 'none';
    joingameContainer.style.display = 'none';
    homeContainer.style.display = 'flex';
}
function Shop() {
    alert('Temporarily unavailable');
}
function Menu() {
    homeContainer.style.display = 'none';
    formationContainer.style.display = 'none';
    joingameContainer.style.display = 'none';
    menuContainer.style.display = 'block';
}
function Formation() {
    menuContainer.style.display = 'none';
    homeContainer.style.display = 'none';
    joingameContainer.style.display = 'none';
    formationContainer.style.display = 'block';
    formationBoard.scrollLeft = 115;
}
function JoinGame() {
    menuContainer.style.display = 'none';
    homeContainer.style.display = 'none';
    formationContainer.style.display = 'none';
    joingameContainer.style.display = 'flex';
}

function News() {
    newsContainer.style.display = 'flex';
}
function NewsBack() {
    if(newsList.style.display == 'flex') {
        newsContainer.style.display = 'none';
    } else {
        newsContent.value = '';
        newsTime.innerHTML = '';
        newsList.style.display = 'flex';
    }
}
function Database() {
    gameMenuContainer.style.display = "none";
    databaseContainer.style.display = 'block';
}
function DatabaseBack() {
    databaseContainer.style.display = 'none';
}
function ChangeDisplay() {
    if(nowDisplay.innerHTML == "Units") {
        nowDisplay.innerHTML = "Blocks";
        changeDisplay.innerHTML = "Units";
        databaseUnits.style.display = "none";
        databaseBlocks.style.display = "flex";
    } else {
        nowDisplay.innerHTML = "Units";
        changeDisplay.innerHTML = "Blocks";
        databaseBlocks.style.display = "none";
        databaseUnits.style.display = "flex";
    }
}
function ChooseSignIn() {
    signupButton.classList.remove("focus");
    signinButton.classList.add("focus");
    registrationView.style.display = "none";
    loginView.style.display = "block";
}
function ChooseSignUp() {
    signinButton.classList.remove("focus");
    signupButton.classList.add("focus");
    loginView.style.display = "none";
    registrationView.style.display = "block";
}
function UserSignedIn() {
    signContainer.style.display = "none";
    pageContainer.style.display = "flex";
}
function UserSignedOut() {
    pageContainer.style.display = "none";
    signContainer.style.display = "flex";
}

function ReportBug() {
    window.open('mailto:ethan147852369@gmail.com?subject=Boardustry - Report Bug');
}
function GitHub() {
    window.open('https://github.com/yesaouo/Swift_Boardustry');
}

function generateNewsItem(news) {
    const newsItem = document.createElement("div");
    newsItem.className = "news-item";
    newsItem.innerHTML = news.title;
    newsItem.addEventListener("click", function() {
        showNewsContent(news);
    });
    return newsItem;
}
function showNewsContent(news) {
    newsList.style.display = "none";
    newsContent.value = news.content;
    newsTime.innerHTML = `
        <div>${new Date(news.time.toDate()).toLocaleDateString()}</div>
        <div>${new Date(news.time.toDate()).toLocaleTimeString()}</div>
    `;
}

function addRoom() {
    roomsContainer.style.display = "none";
    addroomContainer.style.display = "flex";
    roomContainer.style.display = "none";
}
function cancelAddRoom() {
    roomsContainer.style.display = "flex";
    addroomContainer.style.display = "none";
    roomContainer.style.display = "none";
}
function getRandomNumber(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}
function hasOnlyOneFalse(arr) {
    const falseValues = arr.filter((item) => item === false);
    return falseValues.length === 1;
}

function showMenu() {
    gameMenuContainer.style.display = "flex";
}
function closeMenu() {
    gameMenuContainer.style.display = "none";
}
function setEndRoundBtn(bool) {
    if (bool) {
        endRoundBtn.disabled = true;
        endRoundBtn.innerHTML = '<img width="40" height="40" src="img/icon/checkmark.png" alt="Checkmark">';
    } else {
        endRoundBtn.disabled = false;
        endRoundBtn.innerHTML = '<img width="40" height="40" src="img/icon/checkmark.fill.png" alt="Checkmark">';
    }
}