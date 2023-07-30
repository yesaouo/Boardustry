// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.23.0/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/9.23.0/firebase-analytics.js";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries
import { getAuth } from "https://www.gstatic.com/firebasejs/9.23.0/firebase-auth.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/9.23.0/firebase-firestore.js";
// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
    apiKey: "AIzaSyDgHAx7Aw_0AtVOWUizKEzudbYRzgW_hc4",
    authDomain: "boardustry.firebaseapp.com",
    projectId: "boardustry",
    storageBucket: "boardustry.appspot.com",
    messagingSenderId: "237879409861",
    appId: "1:237879409861:web:2a99bd8d2d1b2f3d74c4ac",
    measurementId: "G-8XYY50NWQ9"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const auth = getAuth();
const db = getFirestore(app);

import { createUserWithEmailAndPassword, signInWithEmailAndPassword, onAuthStateChanged, updateProfile, signOut, signInWithPopup, GoogleAuthProvider } from "https://www.gstatic.com/firebasejs/9.23.0/firebase-auth.js";
import { collection, doc, setDoc, getDoc, getDocs, query, orderBy, limit, where, onSnapshot, deleteDoc } from "https://www.gstatic.com/firebasejs/9.23.0/firebase-firestore.js"; 
import { getStorage, ref, uploadBytes, getDownloadURL } from "https://www.gstatic.com/firebasejs/9.23.0/firebase-storage.js";
onAuthStateChanged(auth, (user) => {
    if (user) {
        if(user.displayName !== null) {
            UserSignedIn();
        }
    } else {UserSignedOut();}
});
function Register() {
    createUserWithEmailAndPassword(auth, registrationAccount.value, registrationPassword.value)
    .then((userCredential) => {
        const user = userCredential.user;
        updateProfile(user, {
            displayName: registrationUsername.value,
            photoURL: 'img/icon/user.png'
        }).then(async() => {
            await setDoc(doc(db, "users", user.email), {
                name: registrationUsername.value,
                rank: 0,
                coin: 0,
                diamond: 0,
                formate: [  
                    {name: "pulsar", player: 0, posX: 2, posY: 0},
                    {name: "atrax", player: 0, posX: 3, posY: 1},
                    {name: "mace", player: 0, posX: 4, posY: 0},
                    {name: "atrax", player: 0, posX: 5, posY: 1},
                    {name: "pulsar", player: 0, posX: 6, posY: 0}
                ]
            });
            UserSignedIn();
        }).catch((error) => {
            registrationError.innerHTML = error.message;
        });
    })
    .catch((error) => {
        registrationError.innerHTML = error.message;
    });
}
function LogIn() {
    signInWithEmailAndPassword(auth, loginAccount.value, loginPassword.value)
    .then((userCredential) => {UserSignedIn();})
    .catch((error) => {loginError.innerHTML = error.message;});
}
function LogOut() {
    signOut(auth)
}
loginBtn.onclick = function (e) {
    LogIn();
};
registrationBtn.onclick = function (e) {
    Register();
};
logoutBtn.onclick = function (e) {
    LogOut();
};
loginGoogleBtn.onclick = function (e) {
    const providerGoogle = new GoogleAuthProvider();
    signInWithPopup(auth, providerGoogle)
    .then(async (result) => {
        const user = result.user;
        const docRef = doc(db, "users", user.email);
        const docSnap = await getDoc(docRef);
        if (!docSnap.exists()) {
            await setDoc(doc(db, "users", user.email), {
                name: user.displayName,
                rank: 0,
                coin: 0,
                diamond: 0,
                formate: [  
                    {name: "pulsar", player: 0, posX: 2, posY: 0},
                    {name: "atrax", player: 0, posX: 3, posY: 1},
                    {name: "mace", player: 0, posX: 4, posY: 0},
                    {name: "atrax", player: 0, posX: 5, posY: 1},
                    {name: "pulsar", player: 0, posX: 6, posY: 0}
                ]
            });
        }
        UserSignedIn();
    }).catch((error) => {loginError.innerHTML = error.message;});
}

async function uploadImage() {
    const fileInput = file.files[0];
    if (fileInput) {
        const storage = getStorage();
        const storageRef = ref(storage, `images/${auth.currentUser.email}.png`);
        const metadata = {contentType: 'image/png'};
        await uploadBytes(storageRef, fileInput, metadata);
        getDownloadURL(storageRef).then((url) => {
            updateProfile(auth.currentUser, {photoURL: url});
        });
    }
}
file.onchange = (event) => {
    uploadImage();
};
newsBtn.onclick = async function (e) {
    newsList.innerHTML = "";
    const q = query(collection(db, "news"), orderBy("time", "desc"));
    const querySnapshot = await getDocs(q);
    querySnapshot.forEach((doc) => {
        const newsItem = generateNewsItem(doc.data());
        newsList.appendChild(newsItem);
    });
    News();
};


let formate = [];
let selectedUnit = null;
async function downloadFormate() {
    downloadDisabled(true);
    uploadDisabled(true);
    selectedUnit?.classList.remove('selected');
    selectedUnit = null;
    formationTiles.forEach((tile) => {
        tile.innerHTML = "";
    });

    const docRef = doc(db, "users", auth.currentUser.email);
    const docSnap = await getDoc(docRef);
    if (docSnap.exists()) {
        formate = docSnap.data().formate;
        showFormate();
    }
}
function showFormate() {
    formate.forEach((unit) => {
        let tile = formationTiles[unit.posX+unit.posY*9];
        tile.innerHTML = `<img src="img/unit/${unit.name}.png" class="unit">`;
        tile.removeEventListener('click', addUnit);
    });
    counter.textContent = `${formate.length}/5`;
}
function downloadDisabled(disabled) {
    if(disabled) {
        icloudDown.src = 'img/icon/icloud.down.png';
        downloadBtn.disabled = true;
    } else {
        icloudDown.src = 'img/icon/icloud.down.fill.png';
        downloadBtn.disabled = false;
    }
}
function uploadDisabled(disabled) {
    if(disabled) {
        icloudUp.src = 'img/icon/icloud.up.png';
        uploadBtn.disabled = true;
    } else {
        icloudUp.src = 'img/icon/icloud.up.fill.png';
        uploadBtn.disabled = false;
    }
}
function selectUnit(button) {
    if (formate.length < 5) {
        if (selectedUnit !== button) {
            selectedUnit?.classList.remove('selected');
            selectedUnit = button;
            selectedUnit.classList.add('selected');
        }
        formationTiles.forEach((tile) => {
            tile.removeEventListener('click', addUnit);
            tile.addEventListener('click', addUnit);
        });
    }
}
function addUnit(event) {
    const tile = event.target;
    const index = Array.prototype.indexOf.call(formationTiles, tile);
    if (formate.length < 5 && selectedUnit !== null) {
        formate.push({name: selectedUnit.ariaLabel, player: 0, posX: index % 9, posY: Math.floor(index / 9)});
        tile.innerHTML = `<img src="img/unit/${selectedUnit.ariaLabel}.png" class="unit">`;
        tile.removeEventListener('click', addUnit);
        selectedUnit.classList.remove('selected');
        selectedUnit = null;
        counter.textContent = `${formate.length}/5`;
        if(formate.length == 5) {
            uploadDisabled(false);
        }
    }
}

downloadBtn.onclick = function (e) {
    downloadFormate();
};
uploadBtn.onclick = function (e) {
    downloadDisabled(true);
    uploadDisabled(true);
    const userRef = doc(db, 'users', auth.currentUser.email);
    setDoc(userRef, { formate: formate }, { merge: true });
};
uturnBtn.onclick = function (e) {
    if(formate.length > 0) {
        downloadDisabled(false);
        uploadDisabled(true);
        let unit = formate.pop();
        counter.textContent = `${formate.length}/5`;
        formationTiles.forEach((tile, index) => {
            if(unit.posX == index % 9 && unit.posY == Math.floor(index / 9)) {
                tile.innerHTML = "";
            }
        });
    }
};
unitBtns.forEach(function(unitBtn) {
    unitBtn.addEventListener('click', function() {
        selectUnit(unitBtn);
    });
});

let IsPlay = false;
let ScrollLeftValue = -1;
let ScrollTopValue = -1;
let RoomID = localStorage.getItem('Boardustry-roomID');
if (RoomID) { listenRoom(RoomID); } else { RoomID = ''; }
let RoomIDs = [];
let unsubscribe = onSnapshot(query(collection(db, "rooms"), orderBy("time", "desc")), (querySnapshot) => {
    fetchAndPopulateRooms(querySnapshot);
});

function fetchAndPopulateRooms(querySnapshot, id = "") {
    RoomIDs = [];
    roomList.innerHTML = '';
    querySnapshot.forEach((doc) => {
        const data = doc.data();
        if (
            ((id.length === 9 && doc.id === id) || (id.length > 0 && doc.id.includes(id) && data.isShow) || (id.length === 0 && data.isShow)) &&
            (!data.isRank && data.accounts.length !== data.playerCount)
        ) {
            RoomIDs.push(doc.id);
            roomList.innerHTML += `<button class="room-btn"><span>${doc.id}</span><div class="spacer"></div><span>${data.accounts.length}/${data.playerCount}</span></button>`;
        }
    });
    const roomBtns = document.querySelectorAll('.room-btn');
    roomBtns.forEach((roomBtn, index) => {
        roomBtn.onclick = (e) => {
            enterRoom(RoomIDs[index]);
        };
    });
}
searchID.oninput = (event) => {
    const id = searchID.value;
    unsubscribe();
    unsubscribe = onSnapshot(query(collection(db, "rooms"), orderBy("time", "desc")), (querySnapshot) => {
        fetchAndPopulateRooms(querySnapshot, id);
    });
};

function unitsChangePlayer(numberOfPlayers, size, u, p) {
    let w = (numberOfPlayers == 2) ? size*3/5 : size;
    let h = size;
    u.forEach((unit) => {
        unit.player = p;
        let x = unit.posX;
        let y = unit.posY;
        if (p === 0) {
            unit.posX = x + (w - 9) / 2;
            unit.posY = y + h - 3;
        } else if (p === 1) {
            unit.posX = w - 1 - (x + (w - 9) / 2);
            unit.posY = 2 - y;
        } else if (p === 2) {
            unit.posX = 2 - y;
            unit.posY = x + (h - 9) / 2;
        } else if (p === 3) {
            unit.posX = y + w - 3;
            unit.posY = h - 1 - (x + (h - 9) / 2);
        }
    });
    return u;
}
function listenRoom(id) {
    localStorage.setItem('Boardustry-roomID', id);
    RoomID = id;
    IsPlay = false;
    ScrollLeftValue = -1;
    ScrollTopValue = -1;
    const unsub = onSnapshot(doc(db, "rooms", id), (doc) => {
        if (!doc.exists()) {
            localStorage.removeItem('Boardustry-roomID');
            unsub();
        } else {
            const room = doc.data();
            const count = room.playerCount;
            const size = room.mapSize;
            const len = room.accounts.length;
            const allTrue = room.isReadys.every((value) => value === true);
            const index = room.accounts.indexOf(auth.currentUser.email);
            if (index === -1) {
                localStorage.removeItem('Boardustry-roomID');
                unsub();
            } else if (len == count && allTrue) {
                if (!IsPlay) {
                    IsPlay = true;
                    roomsContainer.style.display = "flex";
                    addroomContainer.style.display = "none";
                    roomContainer.style.display = "none";
                    pageContainer.style.display = "none";
                    gameContainer.style.display = "flex";
                    gameHeader.innerHTML = getGameHeader(room.names, room.photos);
                    bgMusic.play();
                }
                const GB = new GameBoard(room, id, index);
                if (room.isEnd) {
                    localStorage.removeItem('Boardustry-roomID');
                    unsub();
                }
            } else {
                prepareBtn.disabled = room.isReadys[index];
                roomHeader.innerHTML = `RoomID: ${id}<br>Size: ${size}&nbsp&nbsp&nbspPlayer: ${count}`; 
                let roomCon = '';
                for (let i = 0; i < len; i++) {
                    roomCon += `
                        <div class="room-player${room.isReadys[i] ? ' ready' : ''}">
                            <img width="96" height="96" src="${room.photos[i]}">${room.names[i]}
                        </div>
                    `;
                }
                roomContent.innerHTML = roomCon;
            }
        }
    });
}
async function enterRoom(id) {
    roomsContainer.style.display = "none";
    addroomContainer.style.display = "none";
    roomContainer.style.display = "flex";
    const userSnap = await getDoc(doc(db, "users", auth.currentUser.email));
    let units = userSnap.data().formate;
    let blocks = [
        {name: "coreNucleus", player: 0, posX: 4, posY: 2},
        {name: "mechanicalDrill", player: 0, posX: 2, posY: 2},
        {name: "mechanicalDrill", player: 0, posX: 6, posY: 2}
    ];
    units = units.concat(blocks);

    const roomSnap = await getDoc(doc(db, "rooms", id));
    const room = roomSnap.data();
    const count = room.playerCount;
    const size = room.mapSize;
    const len = room.accounts.length;
    units = unitsChangePlayer(count, size, units, len);
    room.accounts.push(auth.currentUser.email);
    room.names.push(auth.currentUser.displayName);
    room.photos.push(auth.currentUser.photoURL);
    room.resources.push({copper: 100, lead: 0, titanium: 0, silicon: 0, energy: 5});
    room.isReadys.push(false);
    room.isLoses.push(false);
    room.units = room.units.concat(units);
    await setDoc(doc(db, "rooms", id), room);
    listenRoom(id);
}
async function createRoom() {
    const size = parseInt(mapSize.value);
    const count = parseInt(playerCount.value);
    const isPublic = (publicRoom.value === "true");
    RoomID = getRandomNumber(100000000, 999999999).toString();

    const docRef = doc(db, "users", auth.currentUser.email);
    const docSnap = await getDoc(docRef);
    let units = docSnap.data().formate;
    let blocks = [
        {name: "coreNucleus", player: 0, posX: 4, posY: 2},
        {name: "mechanicalDrill", player: 0, posX: 2, posY: 2},
        {name: "mechanicalDrill", player: 0, posX: 6, posY: 2}
    ];
    units = units.concat(blocks);
    units = unitsChangePlayer(count, size, units, 0);

    const date = new Date();
    const timestamp = Math.floor(date.getTime() / 1000);
    await setDoc(doc(db, "rooms", RoomID), {
        playerCount: count,
        mapSize: size,
        isShow: isPublic,
        isRank: false,
        isEnd: false,
        isReadys: [false],
        isLoses: [false],
        time: timestamp,
        accounts: [auth.currentUser.email],
        names: [auth.currentUser.displayName],
        photos: [auth.currentUser.photoURL],
        resources: [{copper: 100, lead: 0, titanium: 0, silicon: 0, energy: 5}],
        units: units
    });
    listenRoom(RoomID);
}
async function leaveRoom(id) {
    const roomSnap = await getDoc(doc(db, "rooms", id));
    const room = roomSnap.data();
    const len = room.accounts.length;
    const index = room.accounts.indexOf(auth.currentUser.email);
    
    const h = room.mapSize;
    const w = (room.playerCount == 2) ? h*3/5 : h;

    if (len < 2) {
        await deleteDoc(doc(db, "rooms", id));
    } else if (index !== -1) {
        room.accounts.splice(index, 1);
        room.names.splice(index, 1);
        room.photos.splice(index, 1);
        room.resources.splice(index, 1);
        room.isReadys = Array(len - 1).fill(false);
        room.isLoses.splice(index, 1);
        let units = [];
        for (let i = 0; i < room.units.length; i++) {
            if (room.units[i].player != index) {
                if (room.units[i].player > index) {
                    const x = room.units[i].posX;
                    const y = room.units[i].posY;
                    if (room.units[i].player == 1) {
                        room.units[i].posX = w-1-x;
                        room.units[i].posY = h-1-y;
                    }
                    if (room.units[i].player == 2) {
                        room.units[i].posX = y;
                        room.units[i].posY = x;
                    }
                    if (room.units[i].player == 3) {
                        room.units[i].posX = w-1-x;
                        room.units[i].posY = h-1-y;
                    }
                    room.units[i].player--;
                }
                units.push(room.units[i]);
            }
        }
        room.units = units;
        await setDoc(doc(db, "rooms", id), room);
    }
}
async function readyRoom(id) {
    const roomSnap = await getDoc(doc(db, "rooms", id));
    const room = roomSnap.data();
    const index = room.accounts.indexOf(auth.currentUser.email);
    if (index !== -1) {
        room.isReadys[index] = true;
        await setDoc(doc(db, "rooms", id), room);
    }
}

createBtn.onclick = function (e) {
    roomsContainer.style.display = "none";
    addroomContainer.style.display = "none";
    roomContainer.style.display = "flex";
    createRoom();
};
leaveBtn.onclick = function (e) {
    roomsContainer.style.display = "flex";
    addroomContainer.style.display = "none";
    roomContainer.style.display = "none";
    leaveRoom(RoomID);
};
prepareBtn.onclick = function (e) {
    prepareBtn.disabled = true;
    readyRoom(RoomID);
};

//game
function getGameHeader(names, photos) {
    if (names.length === 2) {
        return `
            <div class="player-info">
                <img width="50" height="50" src="${photos[0]}">
                <div class="player-name player0-font">${names[0]}</div>
            </div>
            <div class="spacer"></div>
            <img width="50" height="50" src="img/icon/vs.png">
            <div class="spacer"></div>
            <div class="player-info-right">
                <div class="player-name player1-font text-right">${names[1]}</div>
                <img width="50" height="50" src="${photos[1]}">
            </div>
        `;
    } else if (names.length === 4) {
        return `
            <div class="player-info">
                <img width="50" height="50" src="${photos[0]}">
                <div class="player-name player0-font">${names[0]}</div>
            </div>
            <div class="player-info">
                <img width="50" height="50" src="${photos[1]}">
                <div class="player-name player1-font">${names[1]}</div>
            </div>
            <div class="player-info-right">
                <div class="player-name player2-font text-right">${names[2]}</div>
                <img width="50" height="50" src="${photos[2]}">
            </div>
            <div class="player-info-right">
                <div class="player-name player3-font text-right">${names[3]}</div>
                <img width="50" height="50" src="${photos[3]}">
            </div>
        `;
    }
}
gameBoard.addEventListener('scroll', function() {
    ScrollLeftValue = gameBoard.scrollLeft;
    ScrollTopValue = gameBoard.scrollTop;
});
class GameBoard {
    static unitNames = ['mace', 'pulsar', 'atrax', 'poly'];
    static blockNames = ['coreNucleus', 'mechanicalDrill', 'pneumaticDrill', 'siliconSmelter', 'cryofluidMixer'];
    static resourceNames = ['copper', 'lead', 'titanium', 'silicon'];
    static unitWins = { 
        mace: ['atrax', 'poly', 'coreNucleus', 'mechanicalDrill', 'pneumaticDrill', 'siliconSmelter', 'cryofluidMixer'],
        pulsar: ['mace', 'poly', 'coreNucleus', 'mechanicalDrill', 'pneumaticDrill', 'siliconSmelter', 'cryofluidMixer'],
        atrax: ['pulsar', 'poly', 'coreNucleus', 'mechanicalDrill', 'pneumaticDrill', 'siliconSmelter', 'cryofluidMixer']
    };
    static allCosts = {
        mace: [100, 0, 0, 20, 1],
        pulsar: [100, 0, 20, 0, 1],
        atrax: [100, 20, 0, 0, 1],
        poly: [0, 0, 0, 0, 1],
        mechanicalDrill: [150, 0, 0, 0, 1],
        pneumaticDrill: [100, 100, 0, 0, 1],
        siliconSmelter: [100, 100, 0, 0, 1],
        cryofluidMixer: [200, 200, 0, 0, 1]
    };
    static blockEarns = {
        coreNucleus: [100, 0, 0, 0, 5],
        mechanicalDrill: [20, 20, 0, 0, 0],
        pneumaticDrill: [0, 0, 20, 0, 0],
        siliconSmelter: [0, 0, 0, 20, 0],
        cryofluidMixer: [0, 0, -30, 0, 1]
    }
    
    constructor(room, roomID, index) {
        this.room = room;
        this.roomID = roomID;
        this.me = index;
        this.height = room.mapSize;
        this.width = (room.playerCount == 2) ? room.mapSize*3/5 : room.mapSize;
        this.units = room.units;
        this.resources = room.resources[index];
        this.moves = {
            mace: [[0, 1], [1, 0], [0, -1], [-1, 0]],
            pulsar: [[1, 1], [1, -1], [-1, -1], [-1, 1]],
            atrax: [[[0, 1], [-1, -1], [1, -1], [0, -1]], [[0, 1], [-1, 1], [1, 1], [0, -1]], [[1, 0], [1, -1], [1, 1], [-1, 0]], [[1, 0], [-1, -1], [-1, 1], [-1, 0]]][index],
            poly: [[0, 1], [1, 0], [0, -1], [-1, 0], [1, 1], [1, -1], [-1, -1], [-1, 1], [0, 2], [2, 0], [0, -2], [-2, 0]]
        };
        this.tiles = [];
        this.isMove = false;
        this.isSwitch = false;
        this.canMoves = [];
        this.lastPick = null;
        this.unitChoose = null;
        this.blockChoose = null;
        this.switchDisplay();
        this.createTurnIndicator();
        this.createGameBoard();
        gameQuit.onclick = (e) => {
            localStorage.removeItem('Boardustry-roomID');
            gameContainer.style.display = "none";
            gameMenuContainer.style.display = "none";
            pageContainer.style.display = "flex";
            bgMusic.pause();
            if (!this.room.isLoses[this.me] && !this.room.isEnd) {
                this.room.isLoses[this.me] = true;
                if (hasOnlyOneFalse(this.room.isLoses)) {
                    setDoc(doc(db, 'rooms', this.roomID), { isLoses: this.room.isLoses, isEnd: true }, { merge: true });
                } else {
                    setDoc(doc(db, 'rooms', this.roomID), { isLoses: this.room.isLoses }, { merge: true });
                }
            }
        };
        if (!room.isLoses[index] && !room.isEnd) {
            gameSwitch.onclick = (e) => {
                this.isSwitch = !this.isSwitch;
                this.switchDisplay();
            };
            endRoundBtn.onclick = (e) => {
                this.resources['energy'] = 0;
                this.createTurnIndicator();
                this.updateGameToFirestore();
            };
        }
    }
    
    async updateGameToFirestore() {
        this.isMove = true;
        endRoundBtn.disabled = true;
        endRoundBtn.innerHTML = '<img width="40" height="40" src="img/icon/checkmark.png" alt="Checkmark">';
        turnIndicator.innerHTML = 'Connecting';
        this.room.resources[this.me] = this.resources;
        if (this.checkAllEnergyZero()) {
            for (let i = 0; i < this.room.units.length; i++) {
                const unit = this.room.units[i];
                if (unit.name in GameBoard.blockEarns && !this.room.isLoses[unit.player]) {
                    this.room.resources[unit.player] = this.resourcePlusEarn(this.room.resources[unit.player], unit.name);
                }
            }
        }
        await setDoc(doc(db, 'rooms', this.roomID),
            { units: this.units, resources: this.room.resources, isLoses: this.room.isLoses, isEnd: this.room.isEnd },
            { merge: true }
        );
        this.createTurnIndicator();
        this.isMove = false;
    }

    createTurnIndicator() {
        const water = '<img src="img/item/water.png">';
        const cryofluid = '<img src="img/item/cryofluid.png">';
        if (this.room.isLoses[this.me]) {
            setEndRoundBtn(true)
            turnIndicator.innerHTML = 'Defeat';
        } else if (this.room.isEnd) {
            setEndRoundBtn(true)
            turnIndicator.innerHTML = 'Victory';
        } else if (this.resources['energy'] == 0) {
            setEndRoundBtn(true)
            turnIndicator.innerHTML = 'Waiting';
        } else if (this.resources['energy'] < 6) {
            setEndRoundBtn(false)
            turnIndicator.innerHTML = water.repeat(this.resources['energy']);
        } else {
            setEndRoundBtn(false)
            turnIndicator.innerHTML = cryofluid.repeat(this.resources['energy']-5) + water.repeat(10-this.resources['energy']);
        }
    }
    createGameBoard() {
        board.innerHTML = '';
        for (let row = 0; row < this.height; row++) {
            let tr = document.createElement('tr');
            for (let col = 0; col < this.width; col++) {
                let td = document.createElement('td');
                let div = document.createElement('div');
                div.className = 'tile';
                for (let i in this.units) {
                    let unit = this.units[i];
                    if(unit.posX == col && unit.posY == row) { 
                        div.className += ` player${unit.player}`;
                        let img = document.createElement('img');
                        img.src = `img/unit/${unit.name}.png`;
                        img.className = `rotate${unit.player}`;
                        div.appendChild(img);
                        break;
                    }
                }
                td.appendChild(div);
                tr.appendChild(td);
            }
            board.appendChild(tr);
        }
        if (ScrollLeftValue < 0 || ScrollTopValue < 0) {
            const boardWidth = board.offsetWidth;
            const boardHeight = board.offsetHeight;
            const gameBoardWidth = gameBoard.offsetWidth;
            const gameBoardHeight = gameBoard.offsetHeight;
            if (this.me == 0) {
                ScrollLeftValue = (boardWidth - gameBoardWidth) / 2;
                ScrollTopValue = boardHeight - gameBoardHeight;
            } else if (this.me == 1) {
                ScrollLeftValue = (boardWidth - gameBoardWidth) / 2;
                ScrollTopValue = 0;
            } else if (this.me == 2) {
                ScrollLeftValue = 0;
                ScrollTopValue = (boardHeight - gameBoardHeight) / 2;
            } else if (this.me == 3) {
                ScrollLeftValue = boardWidth - gameBoardWidth;
                ScrollTopValue = (boardHeight - gameBoardHeight) / 2;
            }
        }
        gameBoard.scrollLeft = ScrollLeftValue;
        gameBoard.scrollTop = ScrollTopValue;
        this.tiles = document.querySelectorAll('.tile');
        this.tiles.forEach((tile, index) => {
            tile.addEventListener('click', () => {
                if (!this.isMove && this.resources['energy'] > 0) {
                    this.handleTileClick(tile, index);
                }
            });
        });
    }
    handleTileClick(tile, index) {
        let col = index % this.width;
        let row = Math.floor(index / this.width);
        let img = tile.querySelector('img');
        if (img) {
            let src = img.src;
            let startIndex = src.lastIndexOf('/') + 1;
            let endIndex = src.lastIndexOf('.png');
            let unitName = src.substring(startIndex, endIndex);
            let player = parseInt(img.classList[0][6]);
            if (player == this.me) {
                if (this.lastPick == tile && unitName == 'poly') {
                    this.updatePoly(index);
                    this.clearCanMoves();
                } else {
                    this.clearCanMoves();
                    this.lastPick = tile;
                    this.moves[unitName]?.forEach((move) => {
                        let x = col + move[0];
                        let y = row + move[1];
                        if (x >= 0 && y >= 0 && x < this.width && y < this.height) {
                            let targetPos = x + y * this.width;
                            let targetTile = this.tiles[targetPos];
                            let targetImg = targetTile.querySelector('img');
                            if (targetImg) {
                                if (parseInt(targetImg.classList[0][6]) !== this.me) {
                                    src = targetImg.src;
                                    startIndex = src.lastIndexOf('/') + 1;
                                    endIndex = src.lastIndexOf('.png');
                                    let targetUnitName = src.substring(startIndex, endIndex);
                                    if (GameBoard.unitWins[unitName]?.includes(targetUnitName)) {
                                        targetTile.classList.add('canmove');
                                        this.canMoves.push(targetPos);
                                    }
                                }
                            } else {
                                targetTile.classList.add('canmove');
                                this.canMoves.push(targetPos);
                            }
                        }
                    });
                }
            } else {
                this.moveUnit(index, tile, img, col, row);
            }
        } else {
            this.moveUnit(index, tile, img, col, row);
        }
    }
    clearCanMoves() {
        this.isSwitch = false;
        this.switchDisplay();
    }
    clearCanBuild() {
        this.lastPick = null;
        this.canMoves.forEach((pos) => {
            this.tiles[pos].classList.remove('canmove');
        });
        this.canMoves = [];
    }
    updatePoly(index) {
        this.resources['energy']--;
        this.createTurnIndicator();
        let x = index % this.width;
        let y = Math.floor(index / this.width);
        for (let i in this.units) {
            if (this.units[i].posX == x && this.units[i].posY == y) {
                this.units[i].name = this.units[i].block;
                let img = this.tiles[index].querySelector('img');
                img.src = `img/unit/${this.units[i].name}.png`;
                break;
            }
        }
        this.updateGameToFirestore();
    }
    updateUnit(index, lastIndex) {
        this.resources['energy']--;
        this.createTurnIndicator();
        let units = [];
        let x = index % this.width;
        let y = Math.floor(index / this.width);
        let lastX = lastIndex % this.width;
        let lastY = Math.floor(lastIndex / this.width);
        for (let i in this.units) {
            let unit = this.units[i];
            if (unit.posX == x && unit.posY == y) {
                if (unit.name == 'coreNucleus') {
                    this.room.isLoses[unit.player] = true;
                    this.room.resources[unit.player]['energy'] = 0;
                    if (hasOnlyOneFalse(this.room.isLoses)) {
                        this.room.isEnd = true;
                    }
                }
            } else if (unit.posX == lastX && unit.posY == lastY) {
                unit.posX = x;
                unit.posY = y;
                units.push(unit);
            } else {
                units.push(unit);
            }
        }
        this.units = units;
        this.updateGameToFirestore();
    }
    updatePosition(unit, i, j, k) {
        i++;
        let position = { width: 0, height: 0 };
        if (j === 1) {position = { width: 6 * i, height: 0 };}
        else if (j === -1) {position = { width: -6 * i, height: 0 };}
        else if (j + k === 0) {position = { width: 0, height: -6 * i };}
        else if (j + k === 1) {position = { width: 6 * i, height: -6 * i };}
        else if (j + k === -1) {position = { width: -6 * i, height: -6 * i };}
        else if (j - k === 0) {position = { width: 0, height: 6 * i };}
        else if (j - k === 1) {position = { width: 6 * i, height: 6 * i };} 
        else if (j - k === -1) {position = { width: -6 * i, height: 6 * i };}
        else if (j === -2*k) {position = { width: 0, height: -12 * i };}
        else if (j === 2*k) {position = { width: 0, height: 12 * i };}
        else if (j === -2) {position = { width: -12 * i, height: 0 };}
        else if (j === 2) {position = { width: 12 * i, height: 0 };}
        let rotationAngle = Math.atan2(position.height, position.width) * 180 / Math.PI + 90;
        unit.style.transform = "translate(" + position.width + "px, " + position.height + "px) rotate(" + rotationAngle + "deg)";
    }
    moveUnit(index, tile, img) {
        if (this.lastPick !== null && this.canMoves.includes(index)) {
            this.isMove = true;
            let lastImg = this.lastPick.querySelector('img');
            let lastIndex = Array.prototype.indexOf.call(this.tiles, this.lastPick);
            for (let i = 0; i < 10; i++) {
                setTimeout(() => {
                    this.updatePosition(lastImg, i, index - lastIndex, this.width);
                }, 100 * i);
            }
            setTimeout(() => {
                tile.innerHTML = '';
                this.lastPick.innerHTML = '';
                this.lastPick.classList.remove(`player${this.me}`);
                if (img) {
                    let player = parseInt(img.classList[0][6]);
                    tile.classList.remove(`player${player}`);
                } else {
                    tile.classList.remove(`canmove`);
                }
                tile.classList.add(`player${this.me}`);
                lastImg.style.removeProperty('transform');
                tile.appendChild(lastImg);
                this.clearCanMoves();
                this.updateUnit(index, lastIndex);
                this.isMove = false;
            }, 1000);
        } else if (this.unitChoose !== null && this.canMoves.includes(index)) {
            let img = document.createElement('img');
            img.src = `img/unit/${GameBoard.unitNames[this.unitChoose]}.png`;
            img.className = `rotate${this.me}`;
            tile.appendChild(img);
            tile.classList.add(`player${this.me}`);
            let x = index % this.width;
            let y = Math.floor(index / this.width);
            if (this.unitChoose != 3) {
                this.units.push({name: GameBoard.unitNames[this.unitChoose], player: this.me, posX: x, posY: y});
                this.resourceMinusCost(GameBoard.unitNames[this.unitChoose]);
            } else {
                this.units.push({name: "poly", player: this.me, posX: x, posY: y, block: GameBoard.blockNames[this.blockChoose+1]});
                this.resourceMinusCost(GameBoard.blockNames[this.blockChoose+1]);
            }
        } else {
            this.clearCanMoves();
        }
    }
    buildUnit() {
        this.clearCanBuild();
        let cols = [Math.floor(this.width/2), Math.floor(this.width/2), 0, this.width-1];
        let rows = [this.height-1, 0, Math.floor(this.height/2), Math.floor(this.height/2)];
        let col = cols[this.me];
        let row = rows[this.me];
        let moves = [[0, 1], [1, 0], [0, -1], [-1, 0], [1, 1], [1, -1], [-1, -1], [-1, 1]];
        moves.forEach((move) => {
            let x = col + move[0];
            let y = row + move[1];
            if (x >= 0 && y >= 0 && x < this.width && y < this.height) {
                let targetPos = x + y * this.width;
                let targetTile = this.tiles[targetPos];
                let targetImg = targetTile.querySelector('img');
                if (!targetImg) {
                    targetTile.classList.add('canmove');
                    this.canMoves.push(targetPos);
                }
            }
        });
    }
    resourcePlusEarn(resources, name) {
        if (resources['titanium'] + GameBoard.blockEarns[name][2] < 0 || resources['energy'] + GameBoard.blockEarns[name][4] > 10) {
            return resources;    
        }
        resources['copper'] += GameBoard.blockEarns[name][0];
        resources['lead'] += GameBoard.blockEarns[name][1];
        resources['titanium'] += GameBoard.blockEarns[name][2];
        resources['silicon'] += GameBoard.blockEarns[name][3];
        resources['energy'] += GameBoard.blockEarns[name][4];
        return resources;
    }
    resourceMinusCost(name) {
        this.resources['copper'] -= GameBoard.allCosts[name][0];
        this.resources['lead'] -= GameBoard.allCosts[name][1];
        this.resources['titanium'] -= GameBoard.allCosts[name][2];
        this.resources['silicon'] -= GameBoard.allCosts[name][3];
        this.resources['energy'] -= GameBoard.allCosts[name][4];
        this.createTurnIndicator();
        this.clearCanMoves();
        this.updateGameToFirestore();
    }
    checkAllEnergyZero() {
        for (let i = 0; i < this.room.resources.length; i++) {
            if (this.room.resources[i]['energy'] != 0) {
                return false;
            }
        }
        return true;
    }
    checkResourcesEnough(name) {
        if (GameBoard.allCosts[name][0] > this.resources['copper'] ||
            GameBoard.allCosts[name][1] > this.resources['lead'] ||
            GameBoard.allCosts[name][2] > this.resources['titanium'] ||
            GameBoard.allCosts[name][3] > this.resources['silicon'] ||
            GameBoard.allCosts[name][4] > this.resources['energy']
        ) {return false;}
        return true;
    }
    switchDisplay() {
        if (this.isSwitch) {
            let shows = GameBoard.unitNames;
            let choose = this.unitChoose;
            if (choose == 3) {
                shows = GameBoard.blockNames.slice(1);
                choose = this.blockChoose;
            }
            gameSelections.forEach((select, index) => {
                if (index != choose) {
                    select.classList.remove('can-choose');
                    select.classList.remove('cant-choose');
                }
                select.innerHTML = `<img src="img/unit/${shows[index]}.png">`;
                if (!this.checkResourcesEnough(shows[index])) {
                    select.classList.add('cant-choose');
                }

                select.onclick = (e) => {
                    if (select.classList.contains('can-choose')) {
                        select.classList.remove('can-choose');
                        this.unitChoose = null;
                        this.blockChoose = null;
                        this.clearCanBuild();
                    } else {
                        if (select.classList.contains('cant-choose')) {
                            this.isSwitch = false;
                        } else {
                            if (this.unitChoose != 3) {
                                this.unitChoose = index;
                            } else {
                                this.blockChoose = index;
                            }
                            if (index != 3 && this.resources['energy'] > 0) {
                                select.classList.add('can-choose');
                                this.buildUnit();
                            } else {
                                this.clearCanBuild();
                            }
                        }
                    }
                    this.switchDisplay();
                };
            });
        } else {
            this.clearCanBuild();
            this.unitChoose = null;
            this.blockChoose = null;
            gameSelections.forEach((select, index) => {
                select.onclick = (e) => {};
                select.classList.remove('can-choose');
                select.classList.remove('cant-choose');
                select.innerHTML = `<img src="img/item/${GameBoard.resourceNames[index]}.png">${this.resources[GameBoard.resourceNames[index]]}`;
            });
        }
    }
}