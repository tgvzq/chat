<!doctype html>
<html lang="ru">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#17212b">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="mobile-web-app-capable" content="yes">
<link rel="manifest" href="manifest.json">
<link rel="apple-touch-icon" href="icon-512-1.png">
<link rel="icon" href="icon-512-1.png">
<title>Messenger L - Telegram Style</title>
<style>
  :root { --bg:#0e1621; --panel:#17212b; --in:#182533; --out:#2b5278; --accent:#6ab3f3; --text:#f5f5f5; --muted:#7f91a4; --green:#4fae4e; --red:#e5484d; }
  * { box-sizing:border-box; margin:0; padding:0; -webkit-tap-highlight-color:transparent; }
  html, body { height:100%; background:var(--bg); color:var(--text); font-family:system-ui,-apple-system,"Segoe UI",Roboto,sans-serif; overscroll-behavior:none; }
  .screen { display:none; height:100dvh; flex-direction:column; }
  .screen.active { display:flex; }
  button { font:inherit; color:inherit; border:0; background:none; cursor:pointer; }
  button:disabled { opacity:.5; }
  svg { width:24px; height:24px; display:block; }
  .ib { width:40px; height:40px; border-radius:50%; display:flex; align-items:center; justify-content:center; color:#aab8c6; flex:none; transition:background .15s; }
  .ib:active { background:rgba(255,255,255,.08); }
  .round { width:42px; height:42px; border-radius:50%; background:var(--accent); color:#0e1621; display:flex; align-items:center; justify-content:center; flex:none; transition:transform .15s, background .15s; }
  .round:active { transform:scale(.88); }

  /* Login */
  #login { align-items:center; justify-content:center; padding:24px; gap:12px; }
  .logo { width:88px; height:88px; border-radius:50%; background:linear-gradient(135deg,#6ab3f3,#3a7bd5); display:flex; align-items:center; justify-content:center; font-size:40px; font-weight:700; color:#fff; box-shadow:0 8px 24px rgba(58,123,213,.3); margin-bottom:6px; }
  #login h1 { font-size:24px; font-weight:600; }
  #login p { color:var(--muted); font-size:14px; margin-bottom:10px; }
  #login form { width:100%; max-width:320px; display:flex; flex-direction:column; gap:12px; }
  #login input { width:100%; padding:13px 16px; border-radius:12px; border:1px solid #2a3a4a; background:var(--panel); color:var(--text); font-size:16px; outline:none; transition:border-color .15s; }
  #login input:focus { border-color:var(--accent); }
  #loginBtn { padding:13px; border-radius:12px; background:var(--accent); color:#0e1621; font-weight:700; font-size:16px; }
  #err { color:#ff6b6b; font-size:14px; min-height:18px; text-align:center; }

  /* Header */
  header { position:relative; display:flex; align-items:center; gap:10px; padding:6px 8px 6px 12px; padding-top:max(6px, env(safe-area-inset-top)); background:var(--panel); box-shadow:0 1px 0 rgba(0,0,0,.2); z-index:5; }
  .avatar { width:40px; height:40px; border-radius:50%; background:linear-gradient(135deg,#6ab3f3,#3a7bd5); display:flex; align-items:center; justify-content:center; font-weight:700; color:#fff; flex:none; }
  .hl { min-width:0; flex:1; cursor:pointer; }
  .title { font-weight:600; font-size:15px; }
  .sub { font-size:12px; color:var(--muted); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
  .sub.on { color:var(--accent); }
  .btns { display:flex; gap:2px; }
  #hmenu { display:none; position:absolute; right:8px; top:100%; background:#1f2c3a; border-radius:12px; box-shadow:0 8px 24px rgba(0,0,0,.5); min-width:170px; padding:6px; z-index:20; }
  #hmenu.show { display:block; animation:pop .15s; }
  #who { padding:8px 12px; color:var(--muted); font-size:13px; border-bottom:1px solid rgba(255,255,255,.05); margin-bottom:4px; }
  #hmenu button { width:100%; text-align:left; padding:10px 12px; border-radius:8px; font-size:14px; }
  #hmenu button:active { background:rgba(255,255,255,.08); }

  /* Call banner */
  #banner { display:none; align-items:center; justify-content:space-between; gap:8px; padding:10px 14px; background:#1b3a2a; font-size:14px; border-bottom:1px solid rgba(0,0,0,.2); }
  #banner.show { display:flex; }
  #banner .acts { display:flex; gap:8px; }
  #banner button { padding:6px 14px; border-radius:16px; background:var(--green); color:#fff; font-weight:600; font-size:13px; }

  /* Messages area */
  #msgwrap { flex:1; position:relative; min-height:0; display:flex; flex-direction:column;
    background:radial-gradient(circle at 20% 10%, rgba(106,179,243,.04), transparent 40%), radial-gradient(circle at 80% 90%, rgba(106,179,243,.03), transparent 45%), var(--bg); }
  #msgs { flex:1; min-height:0; overflow-y:auto; padding:8px 12px; display:flex; flex-direction:column; gap:2px; }
  
  .day { align-self:center; background:rgba(23,33,43,.85); backdrop-filter:blur(4px); padding:4px 12px; border-radius:10px; font-size:12px; color:#cfd9e3; margin:12px 0 8px; font-weight:500; box-shadow:0 1px 2px rgba(0,0,0,.2); }
  
  /* Telegram style message bubbles */
  .msg { position:relative; max-width:82%; padding:6px 10px 8px; border-radius:14px; background:var(--in); align-self:flex-start; line-height:1.4; box-shadow:0 1px 2px rgba(0,0,0,.15); transform-origin:bottom left; word-break:break-word; }
  .msg.me { background:var(--out); align-self:flex-end; transform-origin:bottom right; }
  
  .msg.first { margin-top:6px; }
  .msg:not(.me):not(.last) { border-bottom-left-radius:4px; }
  .msg:not(.me):not(.first) { border-top-left-radius:4px; }
  .msg.me:not(.last) { border-bottom-right-radius:4px; }
  .msg.me:not(.first) { border-top-right-radius:4px; }

  .msg .name { display:none; font-size:12px; font-weight:600; margin-bottom:2px; }
  .msg.first .name { display:block; }
  
  .tx { white-space:pre-wrap; overflow-wrap:anywhere; font-size:15px; padding-right:48px; }
  .time { position:absolute; right:8px; bottom:4px; font-size:11px; color:rgba(255,255,255,.5); user-select:none; white-space:nowrap; }
  .msg.me .time { color:rgba(255,255,255,.6); }

  .msg.media { padding:3px; }
  .msg.media .tx { padding:6px 8px 2px; }
  .msg img, .msg video { display:block; max-width:100%; max-height:320px; border-radius:12px; background:#000; cursor:pointer; }
  
  .msg.in { animation:pop .2s ease-out; }
  @keyframes pop { from { opacity:0; transform:translateY(6px) scale(.96); } to { opacity:1; transform:none; } }

  .msg .quote { border-left:3px solid var(--accent); background:rgba(0,0,0,.15); border-radius:6px; padding:4px 8px; margin-bottom:4px; font-size:13px; cursor:pointer; }
  .msg .quote b { display:block; font-size:12px; color:var(--accent); }
  .msg .quote span { opacity:.85; display:-webkit-box; -webkit-line-clamp:2; -webkit-box-orient:vertical; overflow:hidden; }

  .msg .rx { display:flex; flex-wrap:wrap; gap:4px; margin-top:4px; }
  .msg .rx:empty { display:none; }
  .rxchip { background:rgba(255,255,255,.1); border:1px solid transparent; border-radius:10px; padding:2px 7px; font-size:13px; cursor:pointer; display:flex; align-items:center; gap:3px; }
  .rxchip.mine { border-color:var(--accent); background:rgba(106,179,243,.2); }
  .rxchip.pop { animation:rxpop .3s cubic-bezier(.3,1.5,.5,1); }
  @keyframes rxpop { from { transform:scale(.3); opacity:0; } to { transform:scale(1); opacity:1; } }

  .msg.flash { animation:flash 1s; }
  @keyframes flash { 0%,60% { box-shadow:0 0 0 3px rgba(106,179,243,.8); } 100% { box-shadow:0 1px 2px rgba(0,0,0,.15); } }

  /* Voice player */
  .vm { display:flex; align-items:center; gap:8px; min-width:210px; padding:2px 4px; }
  .vp { width:36px; height:36px; border-radius:50%; background:var(--accent); color:#0e1621; display:flex; align-items:center; justify-content:center; flex:none; }
  .msg.me .vp { background:#fff; color:var(--out); }
  .vp svg { width:20px; height:20px; }
  .vw { flex:1; display:flex; align-items:center; gap:2px; height:28px; cursor:pointer; }
  .vw i { flex:1; min-width:2px; max-width:3px; border-radius:2px; background:rgba(255,255,255,.3); display:block; }
  .vw i.on { background:var(--accent); }
  .msg.me .vw i.on { background:#fff; }
  .vd { font-size:11px; opacity:.75; min-width:32px; text-align:right; }
  .vs { font-size:11px; background:rgba(255,255,255,.15); border-radius:6px; padding:1px 5px; font-weight:600; }

  /* Scroll-down button */
  #down { position:absolute; right:16px; bottom:16px; width:42px; height:42px; border-radius:50%; background:var(--panel); color:#aab8c6; box-shadow:0 3px 10px rgba(0,0,0,.4); display:none; align-items:center; justify-content:center; z-index:6; }
  #down.show { display:flex; animation:pop .2s; }
  #badge { position:absolute; top:-4px; right:-2px; min-width:18px; height:18px; border-radius:9px; background:var(--accent); color:#0e1621; font-size:11px; font-weight:700; display:none; align-items:center; justify-content:center; padding:0 4px; }
  #badge.show { display:flex; }

  /* Footer & Reply bar */
  #busy { display:none; padding:6px 14px; font-size:13px; color:var(--muted); background:var(--panel); text-align:center; }
  #busy.show { display:block; }
  
  #replybar { display:none; align-items:center; gap:8px; padding:6px 12px; background:var(--panel); border-top:1px solid rgba(0,0,0,.2); }
  #replybar.show { display:flex; }
  #replybar .rb { flex:1; min-width:0; border-left:3px solid var(--accent); padding-left:8px; font-size:13px; }
  #replybar .rb b { display:block; color:var(--accent); font-size:12px; }
  #replybar .rb span { display:block; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; opacity:.85; }

  form#send { display:flex; align-items:flex-end; gap:6px; padding:8px; padding-bottom:max(8px, env(safe-area-inset-bottom)); background:var(--panel); border-top:1px solid rgba(0,0,0,.15); }
  form#send .field { flex:1; display:flex; align-items:center; background:var(--bg); border-radius:20px; padding:2px 6px; min-width:0; border:1px solid #233140; }
  form#send #text { flex:1; min-width:0; background:none; border:0; outline:none; color:var(--text); font-size:15px; padding:10px 8px; max-height:120px; resize:none; }
  
  #rec { display:none; align-items:center; gap:10px; padding:8px 12px; padding-bottom:max(8px, env(safe-area-inset-bottom)); background:var(--panel); border-top:1px solid rgba(0,0,0,.15); }
  #rec.show { display:flex; }
  #rec .panel { flex:1; min-width:0; display:flex; align-items:center; gap:10px; background:var(--bg); border-radius:20px; padding:0 14px; height:42px; border:1px solid #233140; }
  #recDot { width:10px; height:10px; border-radius:50%; background:var(--red); animation:blink 1s infinite; flex:none; }
  @keyframes blink { 50% { opacity:.2; } }
  #recTime { font-variant-numeric:tabular-nums; font-size:14px; flex:none; }
  #recWave { flex:1; display:flex; align-items:center; justify-content:flex-end; gap:2px; height:24px; overflow:hidden; }
  #recWave i { width:3px; border-radius:2px; background:var(--accent); flex:none; }
  #rec .cancel { color:var(--red); font-weight:600; font-size:14px; padding:0 6px; }

  /* Context Menu sheet */
  #menu { display:none; position:fixed; inset:0; background:rgba(0,0,0,.6); z-index:45; align-items:flex-end; backdrop-filter:blur(2px); }
  #menu.show { display:flex; }
  #menu .sheet { width:100%; background:var(--panel); border-radius:20px 20px 0 0; padding:12px 14px max(14px, env(safe-area-inset-bottom)); display:flex; flex-direction:column; gap:6px; animation:slideup .2s ease-out; }
  @keyframes slideup { from { transform:translateY(30px); opacity:0; } to { transform:none; opacity:1; } }
  #emojiRow { display:flex; justify-content:space-around; padding:6px 0 10px; border-bottom:1px solid rgba(255,255,255,.06); margin-bottom:4px; }
  #emojiRow button { font-size:28px; padding:4px 6px; border-radius:10px; transition:transform .15s; }
  #emojiRow button:active { transform:scale(1.3); }
  #emojiRow button.sel { background:rgba(106,179,243,.2); }
  #menu .sheet > button { background:#1f2c3a; text-align:left; padding:12px 14px; border-radius:12px; font-size:15px; font-weight:500; }
  #menu .sheet > button:active { background:#253647; }

  /* Lightbox & FX */
  #lb { display:none; position:fixed; inset:0; background:rgba(0,0,0,.95); z-index:50; align-items:center; justify-content:center; }
  #lb.show { display:flex; }
  #lb img { max-width:100%; max-height:100%; object-fit:contain; }
  #fx { position:fixed; inset:0; width:100%; height:100%; pointer-events:none; z-index:70; }

  /* Call overlay */
  #call { display:none; position:fixed; inset:0; background:#000; z-index:40; flex-direction:column; }
  #call.active { display:flex; }
  #grid { flex:1; display:flex; flex-direction:column; gap:4px; padding:4px; padding-top:max(4px, env(safe-area-inset-top)); min-height:0; }
  .tile { position:relative; flex:1; background:#182533; border-radius:12px; overflow:hidden; min-height:0; display:flex; align-items:center; justify-content:center; }
  .tile video { position:absolute; inset:0; width:100%; height:100%; object-fit:cover; background:#182533; }
  .tile .lbl { position:absolute; left:12px; bottom:10px; font-size:14px; font-weight:600; text-shadow:0 1px 3px rgba(0,0,0,.8); z-index:2; }
  .tile .st { position:relative; z-index:2; font-size:14px; color:#cfd3de; text-align:center; padding:0 12px; text-shadow:0 1px 3px rgba(0,0,0,.8); }
  #pip { position:absolute; right:12px; top:max(12px, env(safe-area-inset-top)); width:90px; height:120px; object-fit:cover; border-radius:10px; border:2px solid #2a3a4a; background:#111; z-index:5; transform:scaleX(-1); display:none; }
  #controls { display:flex; justify-content:center; gap:20px; padding:16px; padding-bottom:max(16px, env(safe-area-inset-bottom)); background:#0b0c10; }
  #controls button { width:54px; height:54px; border-radius:50%; padding:0; font-size:22px; background:#1f2c3a; display:flex; align-items:center; justify-content:center; }
  #controls button.off { background:#fff; color:#000; }
  #controls button.end { background:var(--red); }
</style>
</head>
<body>

<section id="login" class="screen active">
  <div class="logo">M</div>
  <h1>Messenger L</h1>
  <p>Приватный чат для троих</p>
  <form id="loginForm" autocomplete="on">
    <input id="name" placeholder="Ваше имя" autocapitalize="none" autocomplete="username" required>
    <input id="pass" type="password" placeholder="Пароль" autocomplete="current-password" required>
    <button id="loginBtn" type="submit">Войти</button>
    <div id="err"></div>
  </form>
</section>

<section id="chat" class="screen">
  <header>
    <div class="avatar">M</div>
    <div class="hl" id="headerInfo"><div class="title">Messenger L</div><div class="sub" id="online"></div></div>
    <div class="btns">
      <button class="ib" id="callAudio" title="Аудиозвонок"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/></svg></button>
      <button class="ib" id="callVideo" title="Видеозвонок"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M17 10.5V7c0-.55-.45-1-1-1H4c-.55 0-1 .45-1 1v10c0 .55.45 1 1 1h12c.55 0 1-.45 1-1v-3.5l4 4v-11l-4 4z"/></svg></button>
      <button class="ib" id="more" title="Меню"><svg viewBox="0 0 24 24"><circle cx="12" cy="5" r="2" fill="currentColor"/><circle cx="12" cy="12" r="2" fill="currentColor"/><circle cx="12" cy="19" r="2" fill="currentColor"/></svg></button>
    </div>
    <div id="hmenu"><div id="who"></div><button id="logout">Выйти</button></div>
  </header>
  
  <div id="banner"><span id="bannerText"></span><span class="acts"><button id="joinAudio">📞 Войти</button><button id="joinVideo">🎥 Видео</button></span></div>
  
  <div id="msgwrap">
    <div id="msgs"></div>
    <button id="down" title="Вниз"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M7.41 8.59L12 13.17l4.59-4.58L18 10l-6 6-6-6 1.41-1.41z"/></svg><span id="badge"></span></button>
  </div>
  
  <div id="busy"></div>
  
  <div id="replybar">
    <div class="rb"><b id="rbName"></b><span id="rbText"></span></div>
    <button type="button" id="rbX" class="ib" title="Отмена">✕</button>
  </div>
  
  <form id="send" autocomplete="off">
    <div class="field">
      <button type="button" class="ib" id="attach" title="Прикрепить фото или видео"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M16.5 6v11.5c0 2.21-1.79 4-4 4s-4-1.79-4-4V5c0-1.38 1.12-2.5 2.5-2.5s2.5 1.12 2.5 2.5v10.5c0 .55-.45 1-1 1s-1-.45-1-1V6H10v9.5c0 1.38 1.12 2.5 2.5 2.5s2.5-1.12 2.5-2.5V5c0-2.21-1.79-4-4-4S7 2.79 7 5v12.5c0 3.04 2.46 5.5 5.5 5.5s5.5-2.46 5.5-5.5V6h-1.5z"/></svg></button>
      <input id="text" placeholder="Сообщение..." maxlength="2000">
    </div>
    <button type="submit" id="sendBtn" class="round" style="display:none" title="Отправить"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg></button>
    <button type="button" id="mic" class="round" title="Голосовое сообщение"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M12 14c1.66 0 2.99-1.34 2.99-3L15 5c0-1.66-1.34-3-3-3S9 3.34 9 5v6c0 1.66 1.34 3 3 3zm5.3-3c0 3-2.54 5.1-5.3 5.1S6.7 14 6.7 11H5c0 3.41 2.72 6.23 6 6.72V21h2v-3.28c3.28-.48 6-3.3 6-6.72h-1.7z"/></svg></button>
  </form>

  <div id="rec">
    <div class="panel"><span id="recDot"></span><span id="recTime">0:00</span><div id="recWave"></div></div>
    <button type="button" id="recCancel" class="cancel">Отмена</button>
    <button type="button" id="recSend" class="round" title="Отправить"><svg viewBox="0 0 24 24"><path fill="currentColor" d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/></svg></button>
  </div>
  
  <input id="file" type="file" accept="image/*,video/*" hidden>
</section>

<div id="lb"><img id="lbImg" alt=""></div>

<div id="menu">
  <div class="sheet">
    <div id="emojiRow"></div>
    <button type="button" id="mReply">↩️ Ответить</button>
    <button type="button" id="mCopy">📋 Копировать текст</button>
  </div>
</div>

<canvas id="fx"></canvas>

<section id="call">
  <div id="grid"></div>
  <video id="pip" autoplay playsinline muted></video>
  <div id="controls">
    <button id="mute" title="Микрофон">🎤</button>
    <button id="cam" title="Камера">📷</button>
    <button id="hang" class="end" title="Завершить">📵</button>
  </div>
</section>

<script type="module">
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-app.js";
import { getAuth, signInWithEmailAndPassword, onAuthStateChanged, signOut } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-auth.js";
import { getFirestore, collection, addDoc, query, orderBy, limit, onSnapshot, serverTimestamp, doc, setDoc, deleteDoc, getDocs, where } from "https://www.gstatic.com/firebasejs/10.12.2/firebase-firestore.js";

const firebaseConfig = {
  apiKey: "AIzaSyCoU2dICPk5nVcP0jA1Z-Y4evWQJvdIw3g",
  authDomain: "messenger-l.firebaseapp.com",
  projectId: "messenger-l",
  storageBucket: "messenger-l.firebasestorage.app",
  messagingSenderId: "199511334954",
  appId: "1:199511334954:web:bc2960377f19e8da9fe353"
};

const DOMAIN = "@chat.app";
const CLOUD = { cloudName: "xv9f1k1y", uploadPreset: "omar09" };
const ICE = { iceServers: [{ urls: "stun:stun.l.google.com:19302" }, { urls: "stun:stun1.l.google.com:19302" }] };

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);

const $ = id => document.getElementById(id);
const show = id => { document.querySelectorAll("section.screen").forEach(s => s.classList.remove("active")); $(id).classList.add("active"); };

let me = null;
let unsubMsgs = null, unsubParts = null, partsTimer = null;
let unsubReact = null, unsubPres = null, presTimer = null;

$("loginForm").addEventListener("submit", async e => {
  e.preventDefault();
  $("err").textContent = "";
  $("loginBtn").disabled = true;
  try {
    const name = $("name").value.trim().toLowerCase();
    await signInWithEmailAndPassword(auth, name + DOMAIN, $("pass").value);
  } catch (err) {
    $("err").textContent = "Неверное имя или пароль";
  } finally {
    $("loginBtn").disabled = false;
  }
});

$("logout").addEventListener("click", async () => {
  await hangup();
  try { if (presenceSet) await presenceSet(false); } catch (_) {}
  signOut(auth);
});

onAuthStateChanged(auth, user => {
  if (unsubMsgs) { unsubMsgs(); unsubMsgs = null; }
  if (unsubReact) { unsubReact(); unsubReact = null; }
  if (unsubParts) { unsubParts(); unsubParts = null; }
  if (partsTimer) { clearInterval(partsTimer); partsTimer = null; }
  stopPresence();
  resetChatUI();
  if (!user) { me = null; show("login"); return; }
  me = { uid: user.uid, name: user.email.split("@")[0] };
  $("who").textContent = "Вы: " + me.name;
  show("chat");
  startChat();
  startPresence();
  watchCalls();
});

function safeMedia(url, type) {
  if (typeof url !== "string") return false;
  if (type === "image") return url.startsWith("data:image/") || url.startsWith("https://");
  if (type === "video") return url.startsWith("https://");
  if (type === "audio") return url.startsWith("data:audio/") || url.startsWith("https://");
  return false;
}

const EMOJIS = ["👍", "❤️", "😂", "😮", "😢", "🔥"];
const ICON_PLAY = '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M8 5v14l11-7z"/></svg>';
const ICON_PAUSE = '<svg viewBox="0 0 24 24"><path fill="currentColor" d="M6 5h4v14H6zM14 5h4v14h-4z"/></svg>';
const NAME_COLORS = ["#e17076", "#eda86c", "#a695e7", "#7bc862", "#6ec9cb", "#65aadd", "#ee7aae"];
const nameColor = n => { let h = 0; for (const c of String(n)) h = (h * 31 + c.charCodeAt(0)) >>> 0; return NAME_COLORS[h % NAME_COLORS.length]; };

const msgEls = new Map(), dayEls = new Map();
let msgDocs = [], reactionsByMsg = {}, presence = {}, replyTo = null, menuCtx = null, presenceSet = null;
let unread = 0, playingAudio = null;

const reduceMotion = () => window.matchMedia && matchMedia("(prefers-reduced-motion: reduce)").matches;
const buzz = ms => { try { navigator.vibrate && navigator.vibrate(ms); } catch (_) {} };

function snippet(m) {
  if (m.text) return String(m.text).slice(0, 100);
  if (m.mediaType === "image") return "📷 Фото";
  if (m.mediaType === "video") return "🎥 Видео";
  if (m.mediaType === "audio") return "🎤 Голосовое";
  return "";
}
const fmtClock = d => d.toLocaleTimeString("ru-RU", { hour: "2-digit", minute: "2-digit" });
const fmtTime = s => Math.floor(s / 60) + ":" + String(s % 60).padStart(2, "0");

const fxc = $("fx"), fctx = fxc.getContext("2d");
let fxParts = [], fxRun = false;
function fxSize() {
  const d = window.devicePixelRatio || 1;
  fxc.width = Math.round(innerWidth * d); fxc.height = Math.round(innerHeight * d);
  fctx.setTransform(d, 0, 0, d, 0, 0);
}
function fxStart() { if (!fxRun) { fxRun = true; requestAnimationFrame(fxLoop); } }
function fxLoop() {
  fctx.clearRect(0, 0, innerWidth, innerHeight);
  fxParts = fxParts.filter(p => p.life > 0 && p.y < innerHeight + 80);
  for (const p of fxParts) {
    p.t += 0.08; p.x += p.vx + (p.sway ? Math.sin(p.t) * p.sway : 0);
    p.y += p.vy; p.vy += p.g; p.rot += p.vr; p.life--;
    fctx.save(); fctx.globalAlpha = Math.min(1, p.life / 30);
    fctx.translate(p.x, p.y); fctx.rotate(p.rot);
    if (p.emoji) { fctx.font = p.size + "px sans-serif"; fctx.textAlign = "center"; fctx.textBaseline = "middle"; fctx.fillText(p.emoji, 0, 0); }
    else { fctx.fillStyle = p.color; fctx.fillRect(-p.size / 2, -p.size / 3, p.size, p.size * 0.6); }
    fctx.restore();
  }
  if (fxParts.length) requestAnimationFrame(fxLoop);
  else { fxRun = false; fctx.clearRect(0, 0, innerWidth, innerHeight); }
}

function fakeWave(seed) {
  let h = 7; for (const c of String(seed)) h = (h * 33 + c.charCodeAt(0)) >>> 0;
  return Array.from({ length: 40 }, () => { h = (h * 1103515245 + 12345) >>> 0; return 6 + (h >>> 16) % 24; });
}

function buildVoice(m) {
  const wrap = document.createElement("div"); wrap.className = "vm";
  const audio = document.createElement("audio");
  audio.src = m.mediaUrl; audio.preload = "metadata";
  const btn = document.createElement("button");
  btn.type = "button"; btn.className = "vp"; btn.innerHTML = ICON_PLAY;
  const wave = document.createElement("div"); wave.className = "vw";
  const vals = Array.isArray(m.wave) && m.wave.length ? m.wave : fakeWave(m.mediaUrl);
  const bars = vals.slice(0, 42).map(v => {
    const i = document.createElement("i");
    i.style.height = (14 + Math.max(0, Math.min(31, +v || 0)) * 86 / 31) + "%";
    wave.appendChild(i); return i;
  });
  const total = () => (isFinite(audio.duration) && audio.duration > 0 ? audio.duration : (+m.duration || 0));
  const dur = document.createElement("span"); dur.className = "vd"; dur.textContent = fmtTime(Math.round(+m.duration || 0));
  const spd = document.createElement("button"); spd.type = "button"; spd.className = "vs"; spd.textContent = "1×";
  const paint = () => {
    const t = total(), r = t ? audio.currentTime / t : 0;
    const k = Math.round(r * bars.length);
    bars.forEach((b, i) => b.classList.toggle("on", i < k));
    dur.textContent = fmtTime(Math.round(audio.paused && audio.currentTime === 0 ? t : (audio.currentTime || 0)));
  };
  btn.onclick = () => {
    if (audio.paused) {
      if (playingAudio && playingAudio !== audio) playingAudio.pause();
      playingAudio = audio; audio.play().catch(() => {});
    } else audio.pause();
  };
  audio.addEventListener("play", () => { btn.innerHTML = ICON_PAUSE; });
  audio.addEventListener("pause", () => { btn.innerHTML = ICON_PLAY; });
  audio.addEventListener("ended", () => { audio.currentTime = 0; btn.innerHTML = ICON_PLAY; paint(); });
  audio.addEventListener("timeupdate", paint);
  audio.addEventListener("loadedmetadata", paint);
  wave.onclick = e => {
    const rc = wave.getBoundingClientRect(), t = total();
    if (t) { audio.currentTime = Math.max(0, Math.min(1, (e.clientX - rc.left) / rc.width)) * t; paint(); }
  };
  const rates = [1, 1.5, 2];
  spd.onclick = () => {
    const k = (rates.indexOf(audio.playbackRate) + 1) % rates.length;
    audio.playbackRate = rates[k]; spd.textContent = rates[k] + "×";
  };
  wrap.append(btn, wave, dur, spd, audio);
  return wrap;
}

function resetChatUI() {
  msgEls.clear(); dayEls.clear();
  $("msgs").replaceChildren();
  msgDocs = []; reactionsByMsg = {}; unread = 0; setBadge();
  replyTo = null; $("replybar").classList.remove("show");
  $("online").textContent = ""; $("online").classList.remove("on");
  $("menu").classList.remove("show"); $("hmenu").classList.remove("show"); menuCtx = null;
}

function buildMsg(id, m) {
  const mine = m.uid === me.uid;
  const hasMedia = safeMedia(m.mediaUrl, m.mediaType);
  const el = document.createElement("div");
  el.className = "msg" + (mine ? " me" : "") + (hasMedia && m.mediaType !== "audio" ? " media" : "");
  el.dataset.id = id;
  
  if (!mine) {
    const n = document.createElement("div");
    n.className = "name"; n.textContent = m.name || "?"; n.style.color = nameColor(m.name || "?");
    el.appendChild(n);
  }
  if (m.replyTo && typeof m.replyTo === "object") {
    const q = document.createElement("div"); q.className = "quote";
    const qn = document.createElement("b"); qn.textContent = String(m.replyTo.name || "?");
    const qt = document.createElement("span"); qt.textContent = String(m.replyTo.text || "");
    q.append(qn, qt);
    q.onclick = () => scrollToMsg(m.replyTo.id);
    el.appendChild(q);
  }
  if (hasMedia) {
    if (m.mediaType === "image") {
      const im = document.createElement("img"); im.src = m.mediaUrl; im.loading = "lazy";
      im.onclick = () => { $("lbImg").src = m.mediaUrl; $("lb").classList.add("show"); };
      el.appendChild(im);
    } else if (m.mediaType === "audio") {
      el.appendChild(buildVoice(m));
    } else {
      const v = document.createElement("video"); v.src = m.mediaUrl; v.controls = true; v.playsInline = true; v.preload = "metadata";
      el.appendChild(v);
    }
  }
  if (m.text) {
    const t = document.createElement("div"); t.className = "tx"; t.textContent = m.text;
    el.appendChild(t);
  }
  const timeEl = document.createElement("span"); timeEl.className = "time";
  el.appendChild(timeEl);

  const rx = document.createElement("div"); rx.className = "rx"; el.appendChild(rx);

  el.addEventListener("click", e => {
    if (e.target.closest("video,audio,img,.rxchip,.quote,.vm")) return;
    openMenu(id, m);
  });
  el.addEventListener("contextmenu", e => { e.preventDefault(); openMenu(id, m); });

  let sx = 0, sy = 0, sdx = 0, skip = false;
  el.addEventListener("touchstart", e => {
    const t = e.touches[0]; sx = t.clientX; sy = t.clientY; sdx = 0;
    skip = !!e.target.closest("video,audio,.vm");
  }, { passive: true });
  el.addEventListener("touchmove", e => {
    if (skip) return;
    const t = e.touches[0];
    if (Math.abs(t.clientY - sy) > 24) { sdx = 0; el.style.transform = ""; return; }
    sdx = t.clientX - sx;
    el.style.transform = sdx > 0 ? `translateX(${Math.min(sdx, 60)}px)` : "";
  }, { passive: true });
  el.addEventListener("touchend", () => {
    el.style.transform = "";
    if (!skip && sdx > 50) { buzz(10); startReply(id, m); }
    sdx = 0;
  });
  return el;
}

function renderRx(el, id) {
  const box = el.querySelector(".rx");
  const r = reactionsByMsg[id] || {};
  const agg = {};
  Object.entries(r).forEach(([uid, x]) => {
    const a = agg[x.emoji] = agg[x.emoji] || { n: 0, mine: false, names: [] };
    a.n++; a.names.push(x.name || "?");
    if (uid === me.uid) a.mine = true;
  });
  const prev = el._rk || new Set(), now = new Set();
  box.replaceChildren(...Object.entries(agg).map(([emo, a]) => {
    const key = emo + "#" + a.n; now.add(key);
    const b = document.createElement("span");
    b.className = "rxchip" + (a.mine ? " mine" : "") + (prev.has(key) ? "" : " pop");
    b.innerHTML = `<span>${emo}</span>` + (a.n > 1 ? `<span>${a.n}</span>` : "");
    b.title = a.names.join(", ");
    b.onclick = () => setReaction(id, emo);
    return b;
  }));
  el._rk = now;
}

function setBadge() {
  $("badge").textContent = unread > 99 ? "99+" : String(unread);
  $("badge").classList.toggle("show", unread > 0);
}

let initialLoaded = false;
function renderMsgs(pending, onlyRx) {
  if (!me) return;
  const box = $("msgs");
  const nearBottom = box.scrollHeight - box.scrollTop - box.clientHeight < 160;
  const expected = [], seen = new Set(), created = [];
  const items = msgDocs.map(({ id, data: m }) => ({ id, m, date: m.createdAt && m.createdAt.toDate ? m.createdAt.toDate() : new Date() }));
  const dayOf = d => d.toDateString();
  let lastDay = "";
  items.forEach((it, i) => {
    const { id, m, date } = it, prev = items[i - 1], next = items[i + 1];
    seen.add(id);
    const dk = dayOf(date);
    const first = !prev || prev.m.uid !== m.uid || date - prev.date > 300000 || dayOf(prev.date) !== dk;
    const last = !next || next.m.uid !== m.uid || next.date - date > 300000 || dayOf(next.date) !== dk;
    if (dk !== lastDay) {
      let dv = dayEls.get(dk);
      if (!dv) { dv = document.createElement("div"); dv.className = "day"; dv.textContent = date.toLocaleDateString("ru-RU", { day: "numeric", month: "long" }); dayEls.set(dk, dv); }
      expected.push(dv); lastDay = dk;
    }
    let el = msgEls.get(id);
    if (!el) {
      el = buildMsg(id, m); msgEls.set(id, el);
      if (initialLoaded && !reduceMotion()) el.classList.add("in");
      created.push({ m, date });
    }
    el.classList.toggle("first", first); el.classList.toggle("last", last);
    el.querySelector(".time").textContent = fmtClock(date);
    renderRx(el, id);
    expected.push(el);
  });
  for (const [id, el] of msgEls) if (!seen.has(id)) { el.remove(); msgEls.delete(id); }
  let cur = box.firstChild;
  expected.forEach(n => { if (n === cur) cur = cur.nextSibling; else box.insertBefore(n, cur); });
  while (cur) { const nx = cur.nextSibling; cur.remove(); cur = nx; }
  if (!onlyRx) {
    created.forEach(({ m, date }) => {
      if (!initialLoaded || Date.now() - date > 20000) return;
      if (m.uid !== me.uid && !nearBottom) unread++;
    });
    if (nearBottom || pending) { box.scrollTop = box.scrollHeight; unread = 0; }
    setBadge();
    if (items.length) initialLoaded = true;
  }
}

function startChat() {
  initialLoaded = false;
  const q = query(collection(db, "messages"), orderBy("createdAt", "desc"), limit(100));
  unsubMsgs = onSnapshot(q, snap => {
    msgDocs = snap.docs.slice().reverse().map(d => ({ id: d.id, data: d.data() }));
    renderMsgs(snap.metadata && snap.metadata.hasPendingWrites, false);
  }, err => console.error(err));
  unsubReact = onSnapshot(collection(db, "reactions"), snap => {
    const r = {};
    snap.docs.forEach(d => {
      const x = d.data();
      if (!x.msgId || !x.uid) return;
      (r[x.msgId] = r[x.msgId] || {})[x.uid] = { emoji: String(x.emoji || ""), name: x.name };
    });
    reactionsByMsg = r;
    renderMsgs(false, true);
  }, err => console.error(err));
  setTimeout(() => { const b = $("msgs"); b.scrollTop = b.scrollHeight; }, 400);
}

function scrollToMsg(id) {
  const el = msgEls.get(id);
  if (!el) return;
  el.scrollIntoView({ block: "center", behavior: "smooth" });
  el.classList.remove("flash"); void el.offsetWidth; el.classList.add("flash");
}

$("msgs").addEventListener("scroll", () => {
  const b = $("msgs"), dist = b.scrollHeight - b.scrollTop - b.clientHeight;
  $("down").classList.toggle("show", dist > 240);
  if (dist < 60 && unread) { unread = 0; setBadge(); }
}, { passive: true });
$("down").onclick = () => { const b = $("msgs"); b.scrollTo({ top: b.scrollHeight, behavior: "smooth" }); unread = 0; setBadge(); };

$("more").onclick = e => { e.stopPropagation(); $("who").textContent = me ? "Вы: " + me.name : ""; $("hmenu").classList.toggle("show"); };
document.addEventListener("click", () => $("hmenu").classList.remove("show"));

async function setReaction(id, emoji) {
  if (!me) return;
  const ref = doc(db, "reactions", id + "_" + me.uid);
  const cur = reactionsByMsg[id] && reactionsByMsg[id][me.uid];
  try {
    if (cur && cur.emoji === emoji) await deleteDoc(ref);
    else { buzz(8); await setDoc(ref, { msgId: id, uid: me.uid, name: me.name, emoji, at: Date.now() }); }
  } catch (err) { console.error(err); }
}

function openMenu(id, m) {
  menuCtx = { id, m };
  const mineR = reactionsByMsg[id] && reactionsByMsg[id][me.uid];
  $("emojiRow").replaceChildren(...EMOJIS.map(emo => {
    const b = document.createElement("button");
    b.type = "button"; b.textContent = emo;
    if (mineR && mineR.emoji === emo) b.className = "sel";
    b.onclick = () => { closeMenu(); setReaction(id, emo); };
    return b;
  }));
  $("mCopy").style.display = m.text ? "" : "none";
  $("menu").classList.add("show");
  buzz(6);
}
function closeMenu() { $("menu").classList.remove("show"); menuCtx = null; }
$("menu").addEventListener("click", e => { if (e.target === $("menu")) closeMenu(); });
$("mReply").onclick = () => { const c = menuCtx; closeMenu(); if (c) startReply(c.id, c.m); };
$("mCopy").onclick = async () => {
  const c = menuCtx; closeMenu();
  if (c && c.m.text) { try { await navigator.clipboard.writeText(c.m.text); } catch (_) {} }
};

function startReply(id, m) {
  replyTo = { id, name: m.name || "?", text: snippet(m) };
  $("rbName").textContent = replyTo.name;
  $("rbText").textContent = replyTo.text;
  $("replybar").classList.add("show");
  $("text").focus();
}
function clearReply() { replyTo = null; $("replybar").classList.remove("show"); }
$("rbX").onclick = clearReply;

async function sendMsg(fields) {
  const data = { text: "", name: me.name, uid: me.uid, createdAt: serverTimestamp(), ...fields };
  if (replyTo) data.replyTo = replyTo;
  await addDoc(collection(db, "messages"), data);
  clearReply();
}

function presVis() { if (me && presenceSet) presenceSet(document.visibilityState === "visible"); }
function presOff() { if (presenceSet) presenceSet(false); }
function startPresence() {
  const ref = doc(db, "presence", me.uid);
  presenceSet = online => setDoc(ref, { name: me.name, online, beat: Date.now() }).catch(() => {});
  if (document.visibilityState === "visible") presenceSet(true);
  presTimer = setInterval(() => {
    if (document.visibilityState === "visible") presenceSet(true);
    renderPresence();
  }, 60000);
  document.addEventListener("visibilitychange", presVis);
  window.addEventListener("pagehide", presOff);
  unsubPres = onSnapshot(collection(db, "presence"), snap => {
    presence = {};
    snap.docs.forEach(d => { presence[d.id] = d.data(); });
    renderPresence();
  }, err => console.error(err));
}
function stopPresence() {
  if (presTimer) { clearInterval(presTimer); presTimer = null; }
  document.removeEventListener("visibilitychange", presVis);
  window.removeEventListener("pagehide", presOff);
  if (unsubPres) { unsubPres(); unsubPres = null; }
  presence = {}; presenceSet = null;
}
function renderPresence() {
  if (!me) return;
  const now = Date.now();
  let anyOn = false;
  const parts = Object.entries(presence).filter(([uid]) => uid !== me.uid).map(([, p]) => {
    if (p.online && now - (p.beat || 0) < 150000) { anyOn = true; return p.name + " в сети"; }
    if (!p.beat) return p.name + " не в сети";
    const d = new Date(p.beat);
    const same = d.toDateString() === new Date().toDateString();
    return p.name + " был(а) " + (same ? "в " + fmtClock(d) : d.toLocaleDateString("ru-RU", { day: "numeric", month: "short" }) + " в " + fmtClock(d));
  });
  $("online").textContent = parts.length ? parts.join(", ") : "приватный чат";
  $("online").classList.toggle("on", anyOn);
}

$("lb").addEventListener("click", () => $("lb").classList.remove("show"));

function toggleSendMic() {
  const has = $("text").value.trim().length > 0;
  $("sendBtn").style.display = has ? "" : "none";
  $("mic").style.display = has ? "none" : "";
}
$("text").addEventListener("input", toggleSendMic);

$("send").onsubmit = async e => {
  e.preventDefault();
  const text = $("text").value.trim();
  if (!text || !me) return;
  $("text").value = ""; toggleSendMic();
  try { await sendMsg({ text }); } catch (err) {
    alert("Не отправилось: " + err.message);
    $("text").value = text; toggleSendMic();
  }
};

function setBusy(msg) { const b = $("busy"); b.textContent = msg || ""; b.classList.toggle("show", !!msg); }

function compressImage(file, max = 1280, q = 0.75) {
  return new Promise((res, rej) => {
    const img = new Image(); const u = URL.createObjectURL(file);
    img.onload = () => {
      let w = img.naturalWidth, h = img.naturalHeight;
      const s = Math.min(1, max / Math.max(w, h));
      w = Math.round(w * s); h = Math.round(h * s);
      const c = document.createElement("canvas"); c.width = w; c.height = h;
      c.getContext("2d").drawImage(img, 0, 0, w, h);
      let qq = q, out = c.toDataURL("image/jpeg", qq);
      URL.revokeObjectURL(u); res(out);
    };
    img.onerror = () => { URL.revokeObjectURL(u); rej(new Error("Ошибка фото")); };
    img.src = u;
  });
}

$("attach").onclick = () => $("file").click();
$("file").onchange = async e => {
  const f = e.target.files[0]; e.target.value = "";
  if (!f || !me) return;
  const isVid = f.type.startsWith("video/"), isImg = f.type.startsWith("image/");
  if (!isVid && !isImg) return;
  setBusy(isVid ? "Загрузка видео..." : "Отправка фото...");
  try {
    let url;
    if (isVid) {
      const fd = new FormData(); fd.append("file", f); fd.append("upload_preset", CLOUD.uploadPreset);
      const r = await fetch(`https://api.cloudinary.com/v1_1/${CLOUD.cloudName}/auto/upload`, { method: "POST", body: fd });
      const j = await r.json();
      if (!j.secure_url) throw new Error("Ошибка загрузки видео");
      url = j.secure_url;
    } else {
      url = await compressImage(f);
    }
    await sendMsg({ mediaType: isVid ? "video" : "image", mediaUrl: url });
  } catch (err) {
    alert("Ошибка: " + err.message);
  } finally {
    setBusy("");
  }
};

let recorder = null, recChunks = [], recStream = null, recTimer = null, recStart = 0, recCancelled = false;
let recAC = null, recAN = null, recLevels = [], recLevelTimer = null;

function blobToDataURL(b) {
  return new Promise((res, rej) => {
    const r = new FileReader();
    r.onload = () => res(r.result);
    r.onerror = () => rej(new Error("Ошибка записи"));
    r.readAsDataURL(b);
  });
}
function pickMime() {
  const c = ["audio/webm;codecs=opus", "audio/webm", "audio/mp4", "audio/ogg;codecs=opus"];
  return c.find(t => window.MediaRecorder && MediaRecorder.isTypeSupported(t)) || "";
}
function makeWave(levels, n = 40) {
  if (!levels.length) return [];
  const out = [], step = levels.length / n;
  for (let i = 0; i < n; i++) {
    const a = Math.floor(i * step), b = Math.max(a + 1, Math.floor((i + 1) * step));
    let mx = 0; for (let j = a; j < b && j < levels.length; j++) mx = Math.max(mx, levels[j]);
    out.push(mx);
  }
  const peak = Math.max(...out, 0.05);
  return out.map(v => Math.round(Math.min(1, v / peak) * 31));
}
function drawRecWave() {
  $("recWave").replaceChildren(...recLevels.slice(-30).map(l => {
    const i = document.createElement("i"); i.style.height = (10 + l * 90) + "%"; return i;
  }));
}
function cleanupRec() {
  clearInterval(recTimer); recTimer = null;
  clearInterval(recLevelTimer); recLevelTimer = null;
  if (recStream) { recStream.getTracks().forEach(t => t.stop()); recStream = null; }
  if (recAC) { try { recAC.close(); } catch (_) {} recAC = null; recAN = null; }
  $("rec").classList.remove("show");
  $("send").style.display = "";
  toggleSendMic();
}
async function startRec() {
  if (recorder) return;
  try {
    recStream = await navigator.mediaDevices.getUserMedia({ audio: { echoCancellation: true, noiseSuppression: true } });
  } catch (err) { alert("Нет доступа к микрофону"); return; }
  const mime = pickMime();
  recChunks = []; recCancelled = false; recLevels = [];
  try { recorder = new MediaRecorder(recStream, mime ? { mimeType: mime } : {}); } catch (_) { cleanupRec(); return; }
  recorder.ondataavailable = e => { if (e.data && e.data.size) recChunks.push(e.data); };
  recorder.onstop = onRecStop;
  try {
    recAC = new (window.AudioContext || window.webkitAudioContext)();
    const src = recAC.createMediaStreamSource(recStream);
    recAN = recAC.createAnalyser(); recAN.fftSize = 512; src.connect(recAN);
  } catch (_) {}
  const buf = recAN ? new Uint8Array(recAN.fftSize) : null;
  recLevelTimer = setInterval(() => {
    let lvl = 0.2;
    if (recAN) {
      recAN.getByteTimeDomainData(buf);
      let sum = 0; for (let i = 0; i < buf.length; i++) { const v = (buf[i] - 128) / 128; sum += v * v; }
      lvl = Math.min(1, Math.sqrt(sum / buf.length) * 3);
    }
    recLevels.push(lvl); drawRecWave();
  }, 100);
  recorder.start();
  recStart = Date.now(); buzz(12);
  $("send").style.display = "none";
  $("rec").classList.add("show");
  $("recTime").textContent = "0:00";
  recTimer = setInterval(() => {
    const s = Math.floor((Date.now() - recStart) / 1000);
    $("recTime").textContent = fmtTime(s);
    if (s >= 300) stopRec(false);
  }, 250);
}
function stopRec(cancel) {
  if (!recorder) return;
  recCancelled = !!cancel;
  try { recorder.stop(); } catch (_) { onRecStop(); }
}
async function onRecStop() {
  const r = recorder; if (!r) return;
  recorder = null;
  const dur = Math.round((Date.now() - recStart) / 1000);
  const type = r.mimeType || "audio/webm";
  const wave = makeWave(recLevels);
  cleanupRec();
  if (recCancelled || dur < 1 || !recChunks.length || !me) { recChunks = []; return; }
  const blob = new Blob(recChunks, { type }); recChunks = [];
  setBusy("Отправка голоса...");
  try {
    let url;
    if (CLOUD.cloudName && CLOUD.uploadPreset) {
      const fd = new FormData(); fd.append("file", blob, "voice.webm"); fd.append("upload_preset", CLOUD.uploadPreset);
      const resp = await fetch(`https://api.cloudinary.com/v1_1/${CLOUD.cloudName}/auto/upload`, { method: "POST", body: fd });
      const j = await resp.json();
      if (!j.secure_url) throw new Error("Ошибка загрузки");
      url = j.secure_url;
    } else {
      url = await blobToDataURL(blob);
    }
    await sendMsg({ mediaType: "audio", mediaUrl: url, duration: dur, wave });
  } catch (err) {
    alert("Ошибка: " + err.message);
  } finally {
    setBusy("");
  }
}

$("mic").onclick = startRec;
$("recCancel").onclick = () => stopRec(true);
$("recSend").onclick = () => stopRec(false);

/* Звонки WebRTC */
const tuneSdp = sdp => sdp.replace(/(a=fmtp:\d+ [^\r\n]*useinbandfec=1)/g, "$1;maxaveragebitrate=64000");
let inCall = false, localStream = null, myJoinedAt = 0, myVideo = false;
let hbTimer = null, sigUnsub = null, sigChain = Promise.resolve();
let lastParts = [];
const peers = {}, pendingC = {};

const activeParts = () => {
  const now = Date.now();
  return lastParts.filter(p => p.id !== me.uid && now - (p.beat || 0) < 30000);
};

function watchCalls() {
  unsubParts = onSnapshot(collection(db, "callRoom"), snap => {
    lastParts = snap.docs.map(d => ({ id: d.id, ...d.data() }));
    onParts();
  }, err => console.error(err));
  partsTimer = setInterval(onParts, 8000);
}

function onParts() {
  if (!me) return;
  const act = activeParts();
  const banner = $("banner");
  if (!inCall) {
    if (act.length) {
      $("bannerText").textContent = "📞 Идет звонок: " + act.map(p => p.name).join(", ");
      banner.classList.add("show");
    } else banner.classList.remove("show");
    return;
  }
  banner.classList.remove("show");
  for (const p of act) {
    const e = peers[p.id];
    if (e && e.joinedAt !== p.joinedAt) closePeer(p.id);
    if (!peers[p.id]) {
      const iOffer = p.joinedAt < myJoinedAt || (p.joinedAt === myJoinedAt && p.id < me.uid);
      if (iOffer) startOffer(p);
      else ensureTile(p.id, p.name, "Ожидание...");
    }
  }
  for (const id of Object.keys(peers)) if (!act.find(p => p.id === id)) closePeer(id);
  for (const id of Object.keys(tiles)) if (!act.find(p => p.id === id)) removeTile(id);
}

const tiles = {};
function ensureTile(id, name, status) {
  if (tiles[id]) return tiles[id];
  const el = document.createElement("div"); el.className = "tile";
  const vid = document.createElement("video"); vid.autoplay = true; vid.playsInline = true;
  const st = document.createElement("div"); st.className = "st"; st.textContent = status || "Соединение...";
  const lbl = document.createElement("div"); lbl.className = "lbl"; lbl.textContent = name || "?";
  el.append(vid, st, lbl);
  $("grid").appendChild(el);
  tiles[id] = { el, vid, st };
  return tiles[id];
}
function removeTile(id) { if (tiles[id]) { tiles[id].el.remove(); delete tiles[id]; } }

function sendSignal(to, type, data) {
  return addDoc(collection(db, "callSignals"), { from: me.uid, to, type, data, name: me.name, joined: myJoinedAt, at: Date.now() }).catch(() => {});
}

function makePeer(id, name, joined) {
  const pc = new RTCPeerConnection(ICE);
  const tile = ensureTile(id, name, "Соединение...");
  const e = { pc, joinedAt: joined, q: pendingC[id] || [], tile };
  delete pendingC[id];
  peers[id] = e;
  pc.onicecandidate = ev => { if (ev.candidate) sendSignal(id, "candidate", JSON.stringify(ev.candidate)); };
  pc.ontrack = ev => { if (ev.streams && ev.streams[0]) tile.vid.srcObject = ev.streams[0]; };
  pc.onconnectionstatechange = () => {
    const s = pc.connectionState;
    if (s === "connected") tile.st.textContent = "";
    else if (s === "failed") tile.st.textContent = "Ошибка соединения";
    else if (s === "disconnected") tile.st.textContent = "Переподключение...";
  };
  return e;
}

function attachLocal(pc) { localStream.getTracks().forEach(t => pc.addTrack(t, localStream)); }

async function flush(e) {
  const q = e.q; e.q = [];
  for (const c of q) { try { await e.pc.addIceCandidate(c); } catch (_) {} }
}

async function startOffer(p) {
  const e = makePeer(p.id, p.name, p.joinedAt);
  try {
    attachLocal(e.pc);
    if (!localStream.getVideoTracks().length) e.pc.addTransceiver("video", { direction: "recvonly" });
    const off = await e.pc.createOffer();
    await e.pc.setLocalDescription({ type: off.type, sdp: tuneSdp(off.sdp) });
    await sendSignal(p.id, "offer", JSON.stringify(e.pc.localDescription));
  } catch (err) { console.error(err); }
}

async function handleSignal(s) {
  if (!inCall) return;
  const from = s.from;
  try {
    if (s.type === "offer") {
      closePeer(from);
      const e = makePeer(from, s.name, s.joined);
      await e.pc.setRemoteDescription(JSON.parse(s.data));
      attachLocal(e.pc);
      await flush(e);
      const ans = await e.pc.createAnswer();
      await e.pc.setLocalDescription({ type: ans.type, sdp: tuneSdp(ans.sdp) });
      await sendSignal(from, "answer", JSON.stringify(e.pc.localDescription));
    } else if (s.type === "answer") {
      const e = peers[from]; if (!e) return;
      await e.pc.setRemoteDescription(JSON.parse(s.data));
      await flush(e);
    } else if (s.type === "candidate") {
      const c = JSON.parse(s.data);
      const e = peers[from];
      if (!e) { (pendingC[from] = pendingC[from] || []).push(c); return; }
      if (e.pc.remoteDescription) await e.pc.addIceCandidate(c);
      else e.q.push(c);
    }
  } catch (err) { console.error(err); }
}

function closePeer(id) {
  const e = peers[id]; if (!e) return;
  try { e.pc.close(); } catch (_) {}
  delete peers[id]; removeTile(id);
}

async function beat() {
  try { await setDoc(doc(db, "callRoom", me.uid), { name: me.name, joinedAt: myJoinedAt, beat: Date.now(), video: myVideo }); } catch (_) {}
}

async function joinCall(video) {
  if (inCall || !me) return;
  try {
    localStream = await navigator.mediaDevices.getUserMedia({
      audio: { echoCancellation: true, noiseSuppression: true },
      video: video ? { facingMode: "user", width: { ideal: 1280 }, height: { ideal: 720 } } : false
    });
  } catch (err) {
    alert("Нет доступа к камере/микрофону"); return;
  }
  inCall = true; myVideo = !!video; myJoinedAt = Date.now();
  for (const k of Object.keys(pendingC)) delete pendingC[k];
  $("call").classList.add("active");
  $("banner").classList.remove("show");
  const pip = $("pip"); pip.srcObject = localStream;
  pip.style.display = video ? "block" : "none";
  $("cam").style.display = video ? "" : "none";
  $("mute").classList.remove("off"); $("mute").textContent = "🎤";
  $("cam").classList.remove("off");

  try {
    const old = await getDocs(query(collection(db, "callSignals"), where("to", "==", me.uid)));
    await Promise.all(old.docs.map(d => deleteDoc(d.ref).catch(() => {})));
  } catch (_) {}

  sigUnsub = onSnapshot(query(collection(db, "callSignals"), where("to", "==", me.uid)), snap => {
    const added = snap.docChanges().filter(c => c.type === "added");
    added.sort((a, b) => (a.doc.data().at || 0) - (b.doc.data().at || 0));
    added.forEach(ch => {
      const s = ch.doc.data();
      deleteDoc(ch.doc.ref).catch(() => {});
      sigChain = sigChain.then(() => handleSignal(s));
    });
  }, err => console.error(err));

  await beat();
  hbTimer = setInterval(beat, 10000);
  onParts();
}

async function hangup() {
  if (!inCall) return;
  inCall = false;
  clearInterval(hbTimer); hbTimer = null;
  if (sigUnsub) { sigUnsub(); sigUnsub = null; }
  Object.keys(peers).forEach(closePeer);
  Object.keys(tiles).forEach(removeTile);
  if (localStream) { localStream.getTracks().forEach(t => t.stop()); localStream = null; }
  $("pip").srcObject = null;
  $("call").classList.remove("active");
  try { await deleteDoc(doc(db, "callRoom", me.uid)); } catch (_) {}
  onParts();
}

window.addEventListener("pagehide", () => { if (inCall && me) deleteDoc(doc(db, "callRoom", me.uid)).catch(() => {}); });

$("callAudio").onclick = () => joinCall(false);
$("callVideo").onclick = () => joinCall(true);
$("joinAudio").onclick = () => joinCall(false);
$("joinVideo").onclick = () => joinCall(true);
$("hang").onclick = hangup;
$("mute").onclick = () => {
  if (!localStream) return;
  const t = localStream.getAudioTracks()[0]; if (!t) return;
  t.enabled = !t.enabled;
  $("mute").classList.toggle("off", !t.enabled);
  $("mute").textContent = t.enabled ? "🎤" : "🔇";
};
$("cam").onclick = () => {
  if (!localStream) return;
  const t = localStream.getVideoTracks()[0]; if (!t) return;
  t.enabled = !t.enabled;
  $("cam").classList.toggle("off", !t.enabled);
};
</script>
</body>
</html>
```eof
