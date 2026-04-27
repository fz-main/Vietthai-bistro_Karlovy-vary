<!DOCTYPE html>
<html lang="cs">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>VietThai Food Bistro – Karlovy Vary</title>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
<style>
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --gold:#C8952A;
  --gold-light:#E8B84B;
  --deep:#0A0A0A;
  --deep2:#111111;
  --surface:#161616;
  --surface2:#1E1E1E;
  --text:#F0EDE8;
  --muted:#8A8070;
  --accent:#D4492A;
  --green:#2D6A4F;
}
html{scroll-behavior:smooth}
body{background:var(--deep);color:var(--text);font-family:'DM Sans',sans-serif;overflow-x:hidden}

/* ====== LOADER ====== */
#loader{
  position:fixed;inset:0;z-index:9999;background:var(--deep);
  display:flex;align-items:center;justify-content:center;flex-direction:column;
  transition:opacity 0.8s ease, visibility 0.8s ease;
}
#loader.hide{opacity:0;visibility:hidden;pointer-events:none}
.loader-logo{
  font-family:'Playfair Display',serif;font-size:clamp(2rem,6vw,4rem);
  color:var(--gold);letter-spacing:0.1em;opacity:0;
  animation:logoFade 1s ease 0.3s forwards;
}
.loader-sub{
  font-size:clamp(0.7rem,2vw,0.9rem);letter-spacing:0.4em;text-transform:uppercase;
  color:var(--muted);margin-top:0.5rem;opacity:0;
  animation:logoFade 1s ease 0.7s forwards;
}
.loader-line{
  width:0;height:1px;background:var(--gold);margin-top:2rem;
  animation:lineGrow 1.2s ease 0.5s forwards;
}
.loader-dots{display:flex;gap:8px;margin-top:1.5rem;opacity:0;animation:logoFade 0.5s ease 1s forwards}
.loader-dots span{width:6px;height:6px;border-radius:50%;background:var(--gold);animation:dotPulse 1.2s ease infinite}
.loader-dots span:nth-child(2){animation-delay:0.2s}
.loader-dots span:nth-child(3){animation-delay:0.4s}

@keyframes logoFade{to{opacity:1}}
@keyframes lineGrow{to{width:200px}}
@keyframes dotPulse{0%,100%{opacity:0.2;transform:scale(0.8)}50%{opacity:1;transform:scale(1)}}

/* ====== NAV ====== */
nav{
  position:fixed;top:0;left:0;right:0;z-index:100;
  padding:1.2rem 5vw;display:flex;align-items:center;justify-content:space-between;
  transition:background 0.4s ease,backdrop-filter 0.4s ease,padding 0.3s ease;
}
nav.scrolled{background:rgba(10,10,10,0.92);backdrop-filter:blur(16px);padding:0.8rem 5vw;border-bottom:1px solid rgba(200,149,42,0.15)}
.nav-logo{font-family:'Playfair Display',serif;font-size:1.4rem;color:var(--gold);text-decoration:none;letter-spacing:0.05em}
.nav-links{display:flex;gap:2rem;align-items:center;list-style:none}
.nav-links a{color:var(--muted);text-decoration:none;font-size:0.85rem;letter-spacing:0.1em;text-transform:uppercase;transition:color 0.3s;position:relative}
.nav-links a::after{content:'';position:absolute;bottom:-4px;left:0;width:0;height:1px;background:var(--gold);transition:width 0.3s}
.nav-links a:hover{color:var(--gold-light)}
.nav-links a:hover::after{width:100%}

/* Lang switcher */
.lang-switcher{display:flex;gap:4px;background:rgba(255,255,255,0.05);border-radius:20px;padding:4px;border:1px solid rgba(200,149,42,0.2)}
.lang-btn{background:none;border:none;color:var(--muted);font-size:0.75rem;padding:4px 10px;border-radius:16px;cursor:pointer;font-family:'DM Sans',sans-serif;letter-spacing:0.05em;transition:all 0.2s;text-transform:uppercase}
.lang-btn.active{background:var(--gold);color:#000;font-weight:500}
.lang-btn:hover:not(.active){color:var(--text)}

/* Burger */
.burger{display:none;flex-direction:column;gap:5px;cursor:pointer;background:none;border:none;padding:4px}
.burger span{width:24px;height:2px;background:var(--gold);transition:all 0.3s;border-radius:2px;display:block}
.burger.open span:nth-child(1){transform:rotate(45deg) translate(5px,5px)}
.burger.open span:nth-child(2){opacity:0}
.burger.open span:nth-child(3){transform:rotate(-45deg) translate(5px,-5px)}

/* Mobile menu */
.mobile-menu{
  position:fixed;inset:0;z-index:99;background:rgba(10,10,10,0.98);
  display:flex;flex-direction:column;align-items:center;justify-content:center;gap:2.5rem;
  transform:translateX(100%);transition:transform 0.5s cubic-bezier(0.4,0,0.2,1);
  backdrop-filter:blur(20px);
}
.mobile-menu.open{transform:translateX(0)}
.mobile-menu a{font-family:'Playfair Display',serif;font-size:2rem;color:var(--text);text-decoration:none;transition:color 0.3s;opacity:0;transform:translateX(30px);transition:all 0.4s}
.mobile-menu.open a{opacity:1;transform:translateX(0)}
.mobile-menu.open a:nth-child(1){transition-delay:0.1s}
.mobile-menu.open a:nth-child(2){transition-delay:0.15s}
.mobile-menu.open a:nth-child(3){transition-delay:0.2s}
.mobile-menu.open a:nth-child(4){transition-delay:0.25s}
.mobile-menu.open a:nth-child(5){transition-delay:0.3s}
.mobile-menu a:hover{color:var(--gold)}
.mobile-lang{display:flex;gap:8px;margin-top:1rem}

/* ====== HERO ====== */
#hero{
  min-height:100vh;position:relative;display:flex;align-items:center;justify-content:center;
  overflow:hidden;
}
.hero-bg{
  position:absolute;inset:0;
  background:
    radial-gradient(ellipse at 20% 50%, rgba(200,149,42,0.08) 0%, transparent 60%),
    radial-gradient(ellipse at 80% 20%, rgba(212,73,42,0.06) 0%, transparent 50%),
    radial-gradient(ellipse at 60% 80%, rgba(45,106,79,0.05) 0%, transparent 50%),
    var(--deep);
}
.hero-pattern{
  position:absolute;inset:0;opacity:0.04;
  background-image:repeating-linear-gradient(45deg,var(--gold) 0,var(--gold) 1px,transparent 0,transparent 50%);
  background-size:30px 30px;
}
.hero-content{
  position:relative;z-index:1;text-align:center;padding:0 5vw;
  opacity:0;transform:translateY(30px);
  transition:opacity 1s ease 1.8s, transform 1s ease 1.8s;
}
.hero-content.visible{opacity:1;transform:translateY(0)}
.hero-badge{
  display:inline-block;border:1px solid rgba(200,149,42,0.4);
  padding:6px 20px;border-radius:20px;font-size:0.75rem;letter-spacing:0.3em;
  text-transform:uppercase;color:var(--gold-light);margin-bottom:2rem;
  background:rgba(200,149,42,0.06);
}
.hero-title{
  font-family:'Playfair Display',serif;
  font-size:clamp(3rem,10vw,7rem);
  line-height:0.95;letter-spacing:-0.02em;
  margin-bottom:1.5rem;
}
.hero-title .line1{display:block;color:var(--text)}
.hero-title .line2{display:block;color:var(--gold);font-style:italic}
.hero-desc{
  max-width:520px;margin:0 auto 3rem;
  font-size:clamp(0.95rem,2vw,1.1rem);color:var(--muted);
  line-height:1.8;font-weight:300;
}
.hero-ctas{display:flex;gap:1rem;justify-content:center;flex-wrap:wrap}
.btn-primary{
  background:var(--gold);color:#000;font-weight:500;
  padding:14px 32px;border-radius:3px;text-decoration:none;
  font-size:0.85rem;letter-spacing:0.1em;text-transform:uppercase;
  transition:all 0.3s;border:none;cursor:pointer;font-family:'DM Sans',sans-serif;
}
.btn-primary:hover{background:var(--gold-light);transform:translateY(-2px)}
.btn-outline{
  border:1px solid rgba(200,149,42,0.5);color:var(--gold-light);
  padding:14px 32px;border-radius:3px;text-decoration:none;
  font-size:0.85rem;letter-spacing:0.1em;text-transform:uppercase;
  transition:all 0.3s;background:transparent;cursor:pointer;font-family:'DM Sans',sans-serif;
}
.btn-outline:hover{border-color:var(--gold);background:rgba(200,149,42,0.08);transform:translateY(-2px)}

/* Scroll indicator */
.scroll-hint{
  position:absolute;bottom:2rem;left:50%;transform:translateX(-50%);
  display:flex;flex-direction:column;align-items:center;gap:8px;
  color:var(--muted);font-size:0.7rem;letter-spacing:0.2em;text-transform:uppercase;
  opacity:0;animation:logoFade 1s ease 2.5s forwards;
}
.scroll-hint-line{width:1px;height:40px;background:linear-gradient(var(--gold),transparent);animation:scrollPulse 2s ease infinite}
@keyframes scrollPulse{0%,100%{opacity:0.3;transform:scaleY(0.8)}50%{opacity:1;transform:scaleY(1)}}

/* Floating orbs */
.orb{
  position:absolute;border-radius:50%;filter:blur(60px);pointer-events:none;
}
.orb1{width:300px;height:300px;background:rgba(200,149,42,0.06);top:20%;left:5%;animation:orbFloat 8s ease-in-out infinite}
.orb2{width:400px;height:400px;background:rgba(212,73,42,0.04);bottom:10%;right:5%;animation:orbFloat 10s ease-in-out infinite reverse}
.orb3{width:200px;height:200px;background:rgba(45,106,79,0.05);top:60%;left:30%;animation:orbFloat 6s ease-in-out infinite 2s}
@keyframes orbFloat{0%,100%{transform:translateY(0) scale(1)}50%{transform:translateY(-30px) scale(1.05)}}

/* Floating food icons */
.food-float{
  position:absolute;font-size:clamp(1.5rem,3vw,2.5rem);opacity:0.08;
  pointer-events:none;animation:floatAround 15s ease-in-out infinite;
}
@keyframes floatAround{
  0%,100%{transform:translateY(0) rotate(0deg)}
  25%{transform:translateY(-20px) rotate(5deg)}
  75%{transform:translateY(10px) rotate(-5deg)}
}

/* ====== SECTIONS ====== */
section{padding:clamp(4rem,10vw,8rem) 5vw}
.section-header{text-align:center;margin-bottom:4rem}
.section-tag{
  display:inline-block;font-size:0.7rem;letter-spacing:0.4em;text-transform:uppercase;
  color:var(--gold);margin-bottom:1rem;
}
.section-title{
  font-family:'Playfair Display',serif;
  font-size:clamp(2rem,5vw,3.5rem);
  line-height:1.1;margin-bottom:1rem;
}
.section-line{width:60px;height:2px;background:var(--gold);margin:1.5rem auto 0}
.section-desc{max-width:580px;margin:1.5rem auto 0;color:var(--muted);line-height:1.8;font-size:1rem}

/* Reveal animation */
.reveal{opacity:0;transform:translateY(40px);transition:opacity 0.8s ease,transform 0.8s ease}
.reveal.visible{opacity:1;transform:translateY(0)}
.reveal-delay-1{transition-delay:0.1s}
.reveal-delay-2{transition-delay:0.2s}
.reveal-delay-3{transition-delay:0.3s}
.reveal-delay-4{transition-delay:0.4s}

/* ====== ABOUT/INTRO ====== */
#about{background:var(--surface)}
.about-grid{display:grid;grid-template-columns:1fr 1fr;gap:4rem;align-items:center;max-width:1100px;margin:0 auto}
.about-visual{position:relative}
.about-frame{
  aspect-ratio:4/5;background:var(--surface2);border-radius:4px;
  overflow:hidden;position:relative;
  border:1px solid rgba(200,149,42,0.2);
}
.about-frame-inner{
  position:absolute;inset:0;
  background:
    radial-gradient(ellipse at 40% 60%, rgba(200,149,42,0.15) 0%, transparent 60%),
    var(--surface2);
  display:flex;align-items:center;justify-content:center;
  font-size:6rem;
}
.about-accent{
  position:absolute;bottom:-20px;right:-20px;width:120px;height:120px;
  border:2px solid var(--gold);border-radius:2px;z-index:-1;
}
.about-text h2{font-family:'Playfair Display',serif;font-size:clamp(1.8rem,4vw,2.8rem);line-height:1.2;margin-bottom:1.5rem}
.about-text h2 em{color:var(--gold);font-style:italic}
.about-text p{color:var(--muted);line-height:1.9;margin-bottom:1.2rem;font-size:1rem}
.stats-row{display:flex;gap:2rem;margin-top:2.5rem;padding-top:2rem;border-top:1px solid rgba(255,255,255,0.07)}
.stat{text-align:center}
.stat-num{font-family:'Playfair Display',serif;font-size:2.2rem;color:var(--gold);display:block}
.stat-label{font-size:0.75rem;color:var(--muted);letter-spacing:0.1em;text-transform:uppercase;margin-top:4px;display:block}

/* ====== ADVANTAGES ====== */
#advantages{background:var(--deep)}
.adv-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1.5px;max-width:1200px;margin:0 auto;background:rgba(200,149,42,0.1);border-radius:4px;overflow:hidden}
.adv-card{
  background:var(--deep2);padding:2.5rem 2rem;
  position:relative;overflow:hidden;
  transition:background 0.3s;
}
.adv-card::before{
  content:'';position:absolute;top:0;left:0;width:3px;height:0;
  background:var(--gold);transition:height 0.5s ease;
}
.adv-card:hover{background:var(--surface)}
.adv-card:hover::before{height:100%}
.adv-icon{font-size:2rem;margin-bottom:1.2rem;display:block}
.adv-title{font-family:'Playfair Display',serif;font-size:1.2rem;margin-bottom:0.8rem;color:var(--text)}
.adv-desc{color:var(--muted);font-size:0.9rem;line-height:1.7}

/* ====== SERVICES ====== */
#services{background:var(--surface)}
.services-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:2rem;max-width:1100px;margin:0 auto}
.service-card{
  background:var(--deep2);border-radius:4px;overflow:hidden;
  border:1px solid rgba(200,149,42,0.1);transition:all 0.4s;
  position:relative;
}
.service-card:hover{transform:translateY(-6px);border-color:rgba(200,149,42,0.4);box-shadow:0 20px 60px rgba(0,0,0,0.4)}
.service-thumb{
  aspect-ratio:16/9;background:var(--surface2);
  display:flex;align-items:center;justify-content:center;font-size:4rem;
  position:relative;overflow:hidden;
}
.service-thumb::after{
  content:'';position:absolute;inset:0;
  background:linear-gradient(to bottom, transparent 50%, var(--deep2));
}
.service-body{padding:1.5rem}
.service-tag{font-size:0.7rem;letter-spacing:0.2em;text-transform:uppercase;color:var(--gold);margin-bottom:0.5rem}
.service-name{font-family:'Playfair Display',serif;font-size:1.3rem;margin-bottom:0.8rem}
.service-desc{color:var(--muted);font-size:0.9rem;line-height:1.7}
.service-price{margin-top:1.2rem;padding-top:1rem;border-top:1px solid rgba(255,255,255,0.07);font-size:0.85rem;color:var(--gold-light)}

/* ====== MENU/ASSORTMENT ====== */
#menu{background:var(--deep)}
.menu-tabs{display:flex;gap:0;justify-content:center;margin-bottom:3rem;border:1px solid rgba(200,149,42,0.2);border-radius:3px;overflow:hidden;max-width:600px;margin:0 auto 3rem;flex-wrap:wrap}
.menu-tab{
  background:none;border:none;color:var(--muted);font-family:'DM Sans',sans-serif;
  padding:12px 24px;font-size:0.8rem;letter-spacing:0.1em;text-transform:uppercase;
  cursor:pointer;transition:all 0.3s;border-right:1px solid rgba(200,149,42,0.2);flex:1;min-width:80px;
}
.menu-tab:last-child{border-right:none}
.menu-tab.active{background:var(--gold);color:#000;font-weight:500}
.menu-tab:hover:not(.active){background:rgba(200,149,42,0.08);color:var(--text)}
.menu-content{max-width:1000px;margin:0 auto}
.menu-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:1rem}
.menu-item{
  background:var(--surface);border:1px solid rgba(200,149,42,0.1);
  border-radius:4px;padding:1.2rem 1.5rem;
  display:flex;justify-content:space-between;align-items:start;
  transition:all 0.3s;
}
.menu-item:hover{border-color:rgba(200,149,42,0.3);background:var(--surface2)}
.menu-item-info{}
.menu-item-name{font-size:0.95rem;font-weight:500;margin-bottom:4px}
.menu-item-desc{font-size:0.8rem;color:var(--muted);line-height:1.5}
.menu-item-price{color:var(--gold);font-family:'Playfair Display',serif;font-size:1.1rem;white-space:nowrap;margin-left:1rem;padding-top:2px}
.menu-category{display:none}
.menu-category.active{display:block}

/* ====== MAP ====== */
#contact{background:var(--surface)}
.contact-grid{display:grid;grid-template-columns:1fr 1.6fr;gap:3rem;max-width:1100px;margin:0 auto;align-items:start}
.contact-info h3{font-family:'Playfair Display',serif;font-size:1.8rem;margin-bottom:1.5rem}
.contact-info p{color:var(--muted);line-height:1.8;margin-bottom:1.5rem;font-size:0.95rem}
.contact-detail{display:flex;gap:1rem;align-items:start;margin-bottom:1.2rem}
.contact-detail-icon{font-size:1.2rem;margin-top:2px;flex-shrink:0}
.contact-detail-text{color:var(--muted);font-size:0.9rem;line-height:1.6}
.contact-detail-text strong{color:var(--text);display:block;margin-bottom:2px;font-size:0.85rem;letter-spacing:0.05em}
.map-container{border-radius:4px;overflow:hidden;border:1px solid rgba(200,149,42,0.2);aspect-ratio:16/10}
.map-container iframe{width:100%;height:100%;border:none;display:block;filter:grayscale(0.3) contrast(1.1)}

/* ====== FOOTER ====== */
footer{background:var(--deep);border-top:1px solid rgba(200,149,42,0.1);padding:3rem 5vw 2rem}
.footer-inner{max-width:1100px;margin:0 auto;display:grid;grid-template-columns:2fr 1fr 1fr;gap:3rem;margin-bottom:2rem}
.footer-brand .footer-logo{font-family:'Playfair Display',serif;font-size:1.5rem;color:var(--gold);margin-bottom:0.8rem}
.footer-brand p{color:var(--muted);font-size:0.85rem;line-height:1.7;max-width:280px}
.footer-col h4{font-size:0.75rem;letter-spacing:0.2em;text-transform:uppercase;color:var(--gold);margin-bottom:1.2rem}
.footer-col ul{list-style:none}
.footer-col ul li{margin-bottom:0.6rem}
.footer-col ul li a{color:var(--muted);text-decoration:none;font-size:0.85rem;transition:color 0.3s}
.footer-col ul li a:hover{color:var(--gold-light)}
.footer-bottom{border-top:1px solid rgba(255,255,255,0.06);padding-top:1.5rem;display:flex;justify-content:space-between;align-items:center;flex-wrap:gap;gap:1rem}
.footer-copy{color:var(--muted);font-size:0.8rem}

/* ====== RESPONSIVE ====== */
@media(max-width:900px){
  .about-grid{grid-template-columns:1fr;gap:3rem}
  .about-visual{max-width:400px;margin:0 auto}
  .contact-grid{grid-template-columns:1fr;gap:2rem}
  .footer-inner{grid-template-columns:1fr 1fr}
}
@media(max-width:768px){
  .nav-links{display:none}
  .burger{display:flex}
  .hero-ctas{flex-direction:column;align-items:center}
  .footer-inner{grid-template-columns:1fr}
  .stats-row{gap:1.5rem}
  .menu-tabs{max-width:100%}
  .menu-tab{padding:10px 12px;font-size:0.7rem}
}
@media(max-width:480px){
  .hero-title{font-size:2.8rem}
  .stats-row{flex-wrap:wrap}
  .adv-grid{grid-template-columns:1fr}
}
</style>
</head>
<body>

<!-- LOADER -->
<div id="loader">
  <div class="loader-logo">VietThai</div>
  <div class="loader-sub">Food Bistro • Karlovy Vary</div>
  <div class="loader-line"></div>
  <div class="loader-dots"><span></span><span></span><span></span></div>
</div>

<!-- MOBILE MENU -->
<div class="mobile-menu" id="mobileMenu">
  <a href="#about" onclick="closeMobile()"><span class="t-nav" data-cs="O nás" data-en="About" data-de="Über uns" data-ru="О нас">O nás</span></a>
  <a href="#advantages" onclick="closeMobile()"><span class="t-nav" data-cs="Výhody" data-en="Why us" data-de="Vorteile" data-ru="Преимущества">Výhody</span></a>
  <a href="#services" onclick="closeMobile()"><span class="t-nav" data-cs="Služby" data-en="Services" data-de="Leistungen" data-ru="Услуги">Služby</span></a>
  <a href="#menu" onclick="closeMobile()"><span class="t-nav" data-cs="Menu" data-en="Menu" data-de="Speisekarte" data-ru="Меню">Menu</span></a>
  <a href="#contact" onclick="closeMobile()"><span class="t-nav" data-cs="Kontakt" data-en="Contact" data-de="Kontakt" data-ru="Контакт">Kontakt</span></a>
  <div class="mobile-lang">
    <div class="lang-switcher">
      <button class="lang-btn active" onclick="setLang('cs')">CS</button>
      <button class="lang-btn" onclick="setLang('en')">EN</button>
      <button class="lang-btn" onclick="setLang('de')">DE</button>
      <button class="lang-btn" onclick="setLang('ru')">RU</button>
    </div>
  </div>
</div>

<!-- NAV -->
<nav id="navbar">
  <a href="#" class="nav-logo">VietThai</a>
  <ul class="nav-links">
    <li><a href="#about" class="t-nav" data-cs="O nás" data-en="About" data-de="Über uns" data-ru="О нас">O nás</a></li>
    <li><a href="#advantages" class="t-nav" data-cs="Výhody" data-en="Why us" data-de="Vorteile" data-ru="Преимущества">Výhody</a></li>
    <li><a href="#services" class="t-nav" data-cs="Služby" data-en="Services" data-de="Leistungen" data-ru="Услуги">Služby</a></li>
    <li><a href="#menu" class="t-nav" data-cs="Menu" data-en="Menu" data-de="Speisekarte" data-ru="Меню">Menu</a></li>
    <li><a href="#contact" class="btn-primary" style="padding:10px 22px;border-radius:3px" class="t-nav" data-cs="Kontakt" data-en="Contact" data-de="Kontakt" data-ru="Контакт">Kontakt</a></li>
    <li>
      <div class="lang-switcher">
        <button class="lang-btn active" onclick="setLang('cs')">CS</button>
        <button class="lang-btn" onclick="setLang('en')">EN</button>
        <button class="lang-btn" onclick="setLang('de')">DE</button>
        <button class="lang-btn" onclick="setLang('ru')">RU</button>
      </div>
    </li>
  </ul>
  <button class="burger" id="burger" onclick="toggleMobile()" aria-label="Menu">
    <span></span><span></span><span></span>
  </button>
</nav>

<!-- HERO -->
<section id="hero">
  <div class="hero-bg"></div>
  <div class="hero-pattern"></div>
  <div class="orb orb1"></div>
  <div class="orb orb2"></div>
  <div class="orb orb3"></div>
  <div class="food-float" style="top:15%;left:8%;animation-delay:0s">🍜</div>
  <div class="food-float" style="top:25%;right:10%;animation-delay:3s">🍣</div>
  <div class="food-float" style="bottom:20%;left:12%;animation-delay:6s">🥢</div>
  <div class="food-float" style="bottom:30%;right:8%;animation-delay:1.5s">🫕</div>
  <div class="hero-content" id="heroContent">
    <div class="hero-badge">
      <span class="t-key" data-cs="Vietnamská &amp; Thajská kuchyně · Karlovy Vary" data-en="Vietnamese &amp; Thai Cuisine · Karlovy Vary" data-de="Vietnamesische &amp; Thaiküche · Karlsbad" data-ru="Вьетнамская &amp; Тайская кухня · Карловы Вары">Vietnamská &amp; Thajská kuchyně · Karlovy Vary</span>
    </div>
    <h1 class="hero-title">
      <span class="line1">VietThai</span>
      <span class="line2">Food Bistro</span>
    </h1>
    <p class="hero-desc t-key"
      data-cs="Autentické chutě jihovýchodní Asie v srdci lázeňského města. Čerstvé suroviny, tradiční recepty, moderní prezentace."
      data-en="Authentic flavours of Southeast Asia in the heart of the spa town. Fresh ingredients, traditional recipes, modern presentation."
      data-de="Authentische Aromen Südostasiens im Herzen der Kurstadt. Frische Zutaten, traditionelle Rezepte, moderne Präsentation."
      data-ru="Подлинные вкусы Юго-Восточной Азии в сердце курортного города. Свежие продукты, традиционные рецепты, современная подача.">
      Autentické chutě jihovýchodní Asie v srdci lázeňského města. Čerstvé suroviny, tradiční recepty, moderní prezentace.
    </p>
    <div class="hero-ctas">
      <a href="#menu" class="btn-primary t-key"
        data-cs="Prohlédnout menu" data-en="View menu" data-de="Speisekarte" data-ru="Смотреть меню">
        Prohlédnout menu
      </a>
      <a href="#contact" class="btn-outline t-key"
        data-cs="Najít nás" data-en="Find us" data-de="Uns finden" data-ru="Найти нас">
        Najít nás
      </a>
    </div>
  </div>
  <div class="scroll-hint">
    <div class="scroll-hint-line"></div>
    <span class="t-key" data-cs="Scroll" data-en="Scroll" data-de="Scroll" data-ru="Скролл">Scroll</span>
  </div>
</section>

<!-- ABOUT -->
<section id="about">
  <div class="about-grid">
    <div class="about-visual reveal">
      <div class="about-frame">
        <div class="about-frame-inner">🍜</div>
        <div style="position:absolute;bottom:0;left:0;right:0;background:linear-gradient(transparent,rgba(0,0,0,0.7));padding:1.5rem">
          <div style="font-family:'Playfair Display',serif;font-size:0.9rem;color:var(--gold-light)">
            <span class="t-key" data-cs="Od roku 2018" data-en="Since 2018" data-de="Seit 2018" data-ru="С 2018 года">Od roku 2018</span>
          </div>
        </div>
      </div>
      <div class="about-accent"></div>
    </div>
    <div class="about-text reveal reveal-delay-2">
      <div class="section-tag t-key" data-cs="Náš příběh" data-en="Our story" data-de="Unsere Geschichte" data-ru="Наша история">Náš příběh</div>
      <h2>
        <span class="t-key"
          data-cs="Vítejte v místě, kde <em>Asie žije</em>"
          data-en="Welcome to where <em>Asia comes alive</em>"
          data-de="Willkommen, wo <em>Asien lebt</em>"
          data-ru="Добро пожаловать туда, где <em>живёт Азия</em>">
          Vítejte v místě, kde <em>Asie žije</em>
        </span>
      </h2>
      <p class="t-key"
        data-cs="VietThai Food Bistro přináší do Karlových Varů autentické chutě Vietnamu a Thajska. Naše kuchyně kombinuje tradiční recepty předávané po generace s čerstvými, pečlivě vybíranými surovinami."
        data-en="VietThai Food Bistro brings the authentic flavours of Vietnam and Thailand to Karlovy Vary. Our kitchen combines traditional recipes passed down through generations with fresh, carefully selected ingredients."
        data-de="VietThai Food Bistro bringt die authentischen Aromen Vietnams und Thailands nach Karlsbad. Unsere Küche verbindet traditionelle, generationenüberlieferte Rezepte mit frischen, sorgfältig ausgewählten Zutaten."
        data-ru="VietThai Food Bistro привносит в Карловы Вары подлинные вкусы Вьетнама и Таиланда. Наша кухня сочетает традиционные рецепты, передаваемые из поколения в поколение, со свежими, тщательно отобранными продуктами.">
        VietThai Food Bistro přináší do Karlových Varů autentické chutě Vietnamu a Thajska. Naše kuchyně kombinuje tradiční recepty předávané po generace s čerstvými, pečlivě vybíranými surovinami.
      </p>
      <p class="t-key"
        data-cs="Naším cílem je nabídnout vám nejen vynikající jídlo, ale celý gastronomický zážitek — vůně, barvy a harmonie asijské kuchyně přímo ve vašem oblíbeném lázeňském městě."
        data-en="Our goal is to offer you not just excellent food, but a complete gastronomic experience — the aromas, colours and harmony of Asian cuisine right in your favourite spa town."
        data-de="Unser Ziel ist es, Ihnen nicht nur hervorragendes Essen zu bieten, sondern ein vollständiges Gastronomie-Erlebnis — Aromen, Farben und Harmonie der asiatischen Küche mitten in Ihrer Lieblingsstadt."
        data-ru="Наша цель — предложить вам не просто отличную еду, а полноценный гастрономический опыт — ароматы, краски и гармонию азиатской кухни прямо в вашем любимом курортном городе.">
        Naším cílem je nabídnout vám nejen vynikající jídlo, ale celý gastronomický zážitek — vůně, barvy a harmonie asijské kuchyně přímo ve vašem oblíbeném lázeňském městě.
      </p>
      <div class="stats-row">
        <div class="stat">
          <span class="stat-num">7+</span>
          <span class="stat-label t-key" data-cs="Let zkušeností" data-en="Years exp." data-de="Jahre Erfahrung" data-ru="Лет опыта">Let zkušeností</span>
        </div>
        <div class="stat">
          <span class="stat-num">50+</span>
          <span class="stat-label t-key" data-cs="Jídel v menu" data-en="Menu items" data-de="Gerichte" data-ru="Блюд в меню">Jídel v menu</span>
        </div>
        <div class="stat">
          <span class="stat-num">★4.8</span>
          <span class="stat-label t-key" data-cs="Google hodnocení" data-en="Google rating" data-de="Google Wertung" data-ru="Рейтинг Google">Google hodnocení</span>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ADVANTAGES -->
<section id="advantages">
  <div class="section-header reveal">
    <div class="section-tag t-key" data-cs="Proč my" data-en="Why us" data-de="Warum wir" data-ru="Почему мы">Proč my</div>
    <h2 class="section-title t-key"
      data-cs="Naše výhody"
      data-en="Our advantages"
      data-de="Unsere Vorteile"
      data-ru="Наши преимущества">Naše výhody</h2>
    <div class="section-line"></div>
  </div>
  <div class="adv-grid" style="max-width:1200px;margin:0 auto">
    <div class="adv-card reveal">
      <span class="adv-icon">🌿</span>
      <div class="adv-title t-key" data-cs="Čerstvé suroviny" data-en="Fresh ingredients" data-de="Frische Zutaten" data-ru="Свежие продукты">Čerstvé suroviny</div>
      <div class="adv-desc t-key"
        data-cs="Používáme pouze čerstvé, denně dodávané suroviny. Žádné konzervanty, maximum chuti."
        data-en="We use only fresh, daily-delivered ingredients. No preservatives, maximum flavour."
        data-de="Wir verwenden nur frische, täglich gelieferte Zutaten. Keine Konservierungsstoffe, maximaler Geschmack."
        data-ru="Мы используем только свежие продукты с ежедневной поставкой. Без консервантов, максимум вкуса.">
        Používáme pouze čerstvé, denně dodávané suroviny. Žádné konzervanty, maximum chuti.
      </div>
    </div>
    <div class="adv-card reveal reveal-delay-1">
      <span class="adv-icon">👨‍🍳</span>
      <div class="adv-title t-key" data-cs="Autentická kuchyně" data-en="Authentic cuisine" data-de="Authentische Küche" data-ru="Аутентичная кухня">Autentická kuchyně</div>
      <div class="adv-desc t-key"
        data-cs="Naši kuchaři pocházejí přímo z Vietnamu a Thajska a přinášejí s sebou generacemi předávané recepty."
        data-en="Our chefs come directly from Vietnam and Thailand, bringing with them recipes passed down through generations."
        data-de="Unsere Köche kommen direkt aus Vietnam und Thailand und bringen Rezepte mit, die seit Generationen überliefert werden."
        data-ru="Наши повара приехали прямо из Вьетнама и Таиланда, привезя с собой рецепты, передаваемые из поколения в поколение.">
        Naši kuchaři pocházejí přímo z Vietnamu a Thajska a přinášejí s sebou generacemi předávané recepty.
      </div>
    </div>
    <div class="adv-card reveal reveal-delay-2">
      <span class="adv-icon">🌶️</span>
      <div class="adv-title t-key" data-cs="Přizpůsobíme vám" data-en="Customised for you" data-de="Auf Sie zugeschnitten" data-ru="Под ваш вкус">Přizpůsobíme vám</div>
      <div class="adv-desc t-key"
        data-cs="Jídlo přizpůsobíme vašim preferencím — pikantnost, alergie, vegetariánská nebo veganská volba."
        data-en="We adapt the food to your preferences — spiciness level, allergies, vegetarian or vegan options."
        data-de="Wir passen das Essen an Ihre Wünsche an — Schärfegrad, Allergien, vegetarische oder vegane Optionen."
        data-ru="Мы адаптируем блюда под ваши предпочтения — острота, аллергии, вегетарианский или веганский вариант.">
        Jídlo přizpůsobíme vašim preferencím — pikantnost, alergie, vegetariánská nebo veganská volba.
      </div>
    </div>
    <div class="adv-card reveal reveal-delay-3">
      <span class="adv-icon">💰</span>
      <div class="adv-title t-key" data-cs="Skvělá cena" data-en="Great value" data-de="Tolles Preis-Leistung" data-ru="Отличная цена">Skvělá cena</div>
      <div class="adv-desc t-key"
        data-cs="Nabízíme vynikající jídlo za dostupné ceny. Polední menu od 119 Kč, rozvoz zdarma od 400 Kč."
        data-en="We offer excellent food at affordable prices. Lunch menu from 119 CZK, free delivery from 400 CZK."
        data-de="Wir bieten exzellentes Essen zu erschwinglichen Preisen. Mittagsmenü ab 119 CZK, kostenlose Lieferung ab 400 CZK."
        data-ru="Мы предлагаем отличную еду по доступным ценам. Обеденное меню от 119 крон, бесплатная доставка от 400 крон.">
        Nabízíme vynikající jídlo za dostupné ceny. Polední menu od 119 Kč, rozvoz zdarma od 400 Kč.
      </div>
    </div>
    <div class="adv-card reveal">
      <span class="adv-icon">🚗</span>
      <div class="adv-title t-key" data-cs="Rozvoz & s sebou" data-en="Delivery & takeaway" data-de="Lieferung & Mitnahme" data-ru="Доставка и навынос">Rozvoz & s sebou</div>
      <div class="adv-desc t-key"
        data-cs="Rozvážíme po celých Karlových Varech. Jídlo si můžete také vyzvednout osobně nebo zarezervovat stůl."
        data-en="We deliver throughout Karlovy Vary. You can also pick up in person or book a table."
        data-de="Wir liefern in ganz Karlsbad. Sie können auch persönlich abholen oder einen Tisch reservieren."
        data-ru="Мы доставляем по всем Карловым Варам. Вы также можете забрать самостоятельно или забронировать столик.">
        Rozvážíme po celých Karlových Varech. Jídlo si můžete také vyzvednout osobně nebo zarezervovat stůl.
      </div>
    </div>
    <div class="adv-card reveal reveal-delay-1">
      <span class="adv-icon">⭐</span>
      <div class="adv-title t-key" data-cs="Top hodnocení" data-en="Top rated" data-de="Top bewertet" data-ru="Высокий рейтинг">Top hodnocení</div>
      <div class="adv-desc t-key"
        data-cs="Více než 4.8 hvězd na Google od stovek spokojených zákazníků z celého světa."
        data-en="Over 4.8 stars on Google from hundreds of satisfied customers from around the world."
        data-de="Über 4,8 Sterne auf Google von hunderten zufriedenen Kunden aus aller Welt."
        data-ru="Более 4,8 звезды на Google от сотен довольных клиентов со всего мира.">
        Více než 4.8 hvězd na Google od stovek spokojených zákazníků z celého světa.
      </div>
    </div>
  </div>
</section>

<!-- SERVICES -->
<section id="services">
  <div class="section-header reveal">
    <div class="section-tag t-key" data-cs="Co nabízíme" data-en="What we offer" data-de="Was wir anbieten" data-ru="Что мы предлагаем">Co nabízíme</div>
    <h2 class="section-title t-key" data-cs="Naše služby" data-en="Our services" data-de="Unsere Leistungen" data-ru="Наши услуги">Naše služby</h2>
    <div class="section-line"></div>
    <p class="section-desc t-key"
      data-cs="Ať preferujete posezení v restauraci, rozvoz domů nebo firemní catering — máme pro vás řešení."
      data-en="Whether you prefer dining in, home delivery or corporate catering — we have a solution for you."
      data-de="Ob Sie es vorziehen, im Restaurant zu sitzen, sich nach Hause liefern zu lassen oder Firmen-Catering wünschen — wir haben eine Lösung für Sie."
      data-ru="Предпочитаете ли вы посидеть в ресторане, доставку домой или корпоративный кейтеринг — у нас есть решение для вас.">
      Ať preferujete posezení v restauraci, rozvoz domů nebo firemní catering — máme pro vás řešení.
    </p>
  </div>
  <div class="services-grid">
    <div class="service-card reveal">
      <div class="service-thumb">🍽️</div>
      <div class="service-body">
        <div class="service-tag t-key" data-cs="Restaurace" data-en="Restaurant" data-de="Restaurant" data-ru="Ресторан">Restaurace</div>
        <div class="service-name t-key" data-cs="Jídlo na místě" data-en="Dine in" data-de="Vor-Ort-Essen" data-ru="Питание в зале">Jídlo na místě</div>
        <div class="service-desc t-key"
          data-cs="Příjemná atmosféra bistro stylu, rychlá obsluha a kompletní asijské menu. Otevřeno 7 dní v týdnu."
          data-en="Pleasant bistro-style atmosphere, fast service and a complete Asian menu. Open 7 days a week."
          data-de="Angenehme Bistro-Atmosphäre, schneller Service und ein komplettes asiatisches Menü. 7 Tage die Woche geöffnet."
          data-ru="Приятная атмосфера в стиле бистро, быстрое обслуживание и полное азиатское меню. Открыто 7 дней в неделю.">
          Příjemná atmosféra bistro stylu, rychlá obsluha a kompletní asijské menu. Otevřeno 7 dní v týdnu.
        </div>
        <div class="service-price t-key" data-cs="Po–Pá 10:00–22:00 · So–Ne 11:00–22:00" data-en="Mon–Fri 10:00–22:00 · Sat–Sun 11:00–22:00" data-de="Mo–Fr 10:00–22:00 · Sa–So 11:00–22:00" data-ru="Пн–Пт 10:00–22:00 · Сб–Вс 11:00–22:00">Po–Pá 10:00–22:00 · So–Ne 11:00–22:00</div>
      </div>
    </div>
    <div class="service-card reveal reveal-delay-1">
      <div class="service-thumb">🛵</div>
      <div class="service-body">
        <div class="service-tag t-key" data-cs="Doručení" data-en="Delivery" data-de="Lieferung" data-ru="Доставка">Doručení</div>
        <div class="service-name t-key" data-cs="Rozvoz po KV" data-en="Karlovy Vary delivery" data-de="Lieferung in KV" data-ru="Доставка по КВ">Rozvoz po KV</div>
        <div class="service-desc t-key"
          data-cs="Rozvážíme čerstvé jídlo přímo k vám domů nebo do kanceláře. Objednejte telefonicky nebo online."
          data-en="We deliver fresh food directly to your home or office. Order by phone or online."
          data-de="Wir liefern frisches Essen direkt zu Ihnen nach Hause oder ins Büro. Per Telefon oder online bestellen."
          data-ru="Мы доставляем свежую еду прямо к вам домой или в офис. Заказывайте по телефону или онлайн.">
          Rozvážíme čerstvé jídlo přímo k vám domů nebo do kanceláře. Objednejte telefonicky nebo online.
        </div>
        <div class="service-price t-key" data-cs="Zdarma od 400 Kč · do 45 min" data-en="Free from 400 CZK · within 45 min" data-de="Kostenlos ab 400 CZK · in 45 Min." data-ru="Бесплатно от 400 крон · за 45 мин">Zdarma od 400 Kč · do 45 min</div>
      </div>
    </div>
    <div class="service-card reveal reveal-delay-2">
      <div class="service-thumb">🎉</div>
      <div class="service-body">
        <div class="service-tag t-key" data-cs="Catering" data-en="Catering" data-de="Catering" data-ru="Кейтеринг">Catering</div>
        <div class="service-name t-key" data-cs="Firemní & soukromé akce" data-en="Corporate & private events" data-de="Firmen & Privatveranstaltungen" data-ru="Корпоративы и частные мероприятия">Firemní & soukromé akce</div>
        <div class="service-desc t-key"
          data-cs="Organizujeme catering pro firemní večírky, narozeniny, svatby a jiné soukromé akce. Kontaktujte nás pro individuální nabídku."
          data-en="We organise catering for company parties, birthdays, weddings and other private events. Contact us for a personalised quote."
          data-de="Wir organisieren Catering für Firmenfeiern, Geburtstage, Hochzeiten und andere Privatveranstaltungen. Kontaktieren Sie uns für ein individuelles Angebot."
          data-ru="Организуем кейтеринг для корпоративов, дней рождения, свадеб и других частных мероприятий. Свяжитесь с нами для индивидуального предложения.">
          Organizujeme catering pro firemní večírky, narozeniny, svatby a jiné soukromé akce. Kontaktujte nás pro individuální nabídku.
        </div>
        <div class="service-price t-key" data-cs="Individuální nabídka na vyžádání" data-en="Individual quote on request" data-de="Individuelles Angebot auf Anfrage" data-ru="Индивидуальное предложение по запросу">Individuální nabídka na vyžádání</div>
      </div>
    </div>
  </div>
</section>

<!-- MENU -->
<section id="menu">
  <div class="section-header reveal">
    <div class="section-tag t-key" data-cs="Naše jídla" data-en="Our dishes" data-de="Unsere Gerichte" data-ru="Наши блюда">Naše jídla</div>
    <h2 class="section-title t-key" data-cs="Výběr z menu" data-en="Menu highlights" data-de="Aus der Speisekarte" data-ru="Избранное меню">Výběr z menu</h2>
    <div class="section-line"></div>
  </div>
  <div class="menu-tabs reveal">
    <button class="menu-tab active" onclick="showCategory('soups')" data-cs="Polévky" data-en="Soups" data-de="Suppen" data-ru="Супы">Polévky</button>
    <button class="menu-tab" onclick="showCategory('mains')" data-cs="Hlavní jídla" data-en="Mains" data-de="Hauptgerichte" data-ru="Основные">Hlavní jídla</button>
    <button class="menu-tab" onclick="showCategory('rice')" data-cs="Rýže & nudle" data-en="Rice & noodles" data-de="Reis & Nudeln" data-ru="Рис и лапша">Rýže & nudle</button>
    <button class="menu-tab" onclick="showCategory('drinks')" data-cs="Nápoje" data-en="Drinks" data-de="Getränke" data-ru="Напитки">Nápoje</button>
  </div>
  <div class="menu-content reveal">
    <!-- SOUPS -->
    <div class="menu-category active" id="cat-soups">
      <div class="menu-grid">
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Phở bò</div><div class="menu-item-desc t-key" data-cs="Hovězí vývar, rýžové nudle, bylinky" data-en="Beef broth, rice noodles, herbs" data-de="Rinderbrühe, Reisnudeln, Kräuter" data-ru="Говяжий бульон, рисовая лапша, травы">Hovězí vývar, rýžové nudle, bylinky</div></div><div class="menu-item-price">149 Kč</div></div>
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Phở gà</div><div class="menu-item-desc t-key" data-cs="Kuřecí vývar, rýžové nudle, kuřecí maso" data-en="Chicken broth, rice noodles, chicken" data-de="Hühnerbrühe, Reisnudeln, Hühnchen" data-ru="Куриный бульон, рисовая лапша, курица">Kuřecí vývar, rýžové nudle, kuřecí maso</div></div><div class="menu-item-price">139 Kč</div></div>
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Tom Yum Kung</div><div class="menu-item-desc t-key" data-cs="Pikantní thajská polévka s krevetami" data-en="Spicy Thai soup with shrimp" data-de="Würzige Thai-Suppe mit Garnelen" data-ru="Острый тайский суп с креветками">Pikantní thajská polévka s krevetami</div></div><div class="menu-item-price">169 Kč</div></div>
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Tom Kha Gai</div><div class="menu-item-desc t-key" data-cs="Kokosová polévka s kuřecím masem" data-en="Coconut soup with chicken" data-de="Kokossuppe mit Hühnchen" data-ru="Кокосовый суп с курицей">Kokosová polévka s kuřecím masem</div></div><div class="menu-item-price">159 Kč</div></div>
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Bún bò Huế</div><div class="menu-item-desc t-key" data-cs="Pikantní polévka s hovězím a vepřovým" data-en="Spicy soup with beef and pork" data-de="Würzige Suppe mit Rind und Schwein" data-ru="Острый суп с говядиной и свининой">Pikantní polévka s hovězím a vepřovým</div></div><div class="menu-item-price">159 Kč</div></div>
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name" class="t-key" data-cs="Vegetariánská Tom Yum" data-en="Vegetarian Tom Yum" data-de="Vegetarische Tom Yum" data-ru="Вегетарианский Tom Yum">Vegetariánská Tom Yum</div><div class="menu-item-desc t-key" data-cs="Pikantní polévka s houbami a tofu" data-en="Spicy soup with mushrooms and tofu" data-de="Würzige Suppe mit Pilzen und Tofu" data-ru="Острый суп с грибами и тофу">Pikantní polévka s houbami a tofu</div></div><div class="menu-item-price">149 Kč</div></div>
      </div>
    </div>
    <!-- MAINS -->
    <div class="menu-category" id="cat-mains">
      <div class="menu-grid">
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Pad Thai</div><div class="menu-item-desc t-key" data-cs="Rýžové nudle, krevety nebo kuře, arašídy" data-en="Rice noodles, shrimp or chicken, peanuts" data-de="Reisnudeln, Garnelen oder Hühnchen, Erdnüsse" data-ru="Рисовая лапша, креветки или курица, арахис">Rýžové nudle, krevety nebo kuře, arašídy</div></div><div class="menu-item-price">189 Kč</div></div>
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Green Curry</div><div class="menu-item-desc t-key" data-cs="Zelené thajské kari s kuřecím masem a zeleninou" data-en="Green Thai curry with chicken and vegetables" data-de="Grünes Thai-Curry mit Hühnchen und Gemüse" data-ru="Зелёное тайское карри с курицей и овощами">Zelené thajské kari s kuřecím masem</div></div><div class="menu-item-price">199 Kč</div></div>
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Bún chả</div><div class="menu-item-desc t-key" data-cs="Grilované vepřové maso, nudle, bylinky" data-en="Grilled pork, noodles, fresh herbs" data-de="Gegrilltes Schweinefleisch, Nudeln, Kräuter" data-ru="Жареная свинина, лапша, свежие травы">Grilované vepřové maso, nudle, bylinky</div></div><div class="menu-item-price">179 Kč</div></div>
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Massaman Curry</div><div class="menu-item-desc t-key" data-cs="Bohaté kari s hovězím masem a bramborami" data-en="Rich curry with beef and potatoes" data-de="Reichhaltiges Curry mit Rindfleisch und Kartoffeln" data-ru="Насыщенное карри с говядиной и картофелем">Bohaté kari s hovězím masem a bramborami</div></div><div class="menu-item-price">209 Kč</div></div>
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Gỏi cuốn (4 ks)</div><div class="menu-item-desc t-key" data-cs="Čerstvé jarní závitky s krevetami a zeleninou" data-en="Fresh spring rolls with shrimp and vegetables" data-de="Frische Frühlingsrollen mit Garnelen und Gemüse" data-ru="Свежие спринг-роллы с креветками и овощами">Čerstvé jarní závitky s krevetami</div></div><div class="menu-item-price">159 Kč</div></div>
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Red Curry Tofu</div><div class="menu-item-desc t-key" data-cs="Červené kari s tofu a zeleninou (vegan)" data-en="Red curry with tofu and vegetables (vegan)" data-de="Rotes Curry mit Tofu und Gemüse (vegan)" data-ru="Красное карри с тофу и овощами (веган)">Červené kari s tofu — vegan</div></div><div class="menu-item-price">179 Kč</div></div>
      </div>
    </div>
    <!-- RICE -->
    <div class="menu-category" id="cat-rice">
      <div class="menu-grid">
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Cơm chiên (smažená rýže)</div><div class="menu-item-desc t-key" data-cs="Smažená rýže s vejcem, zeleninou, kuřetem nebo krevetami" data-en="Fried rice with egg, vegetables, chicken or shrimp" data-de="Gebratener Reis mit Ei, Gemüse, Hühnchen oder Garnelen" data-ru="Жареный рис с яйцом, овощами, курицей или креветками">Smažená rýže s vejcem a zeleninou</div></div><div class="menu-item-price">159 Kč</div></div>
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Mì xào bò</div><div class="menu-item-desc t-key" data-cs="Smažené nudle s hovězím masem a zeleninou" data-en="Stir-fried noodles with beef and vegetables" data-de="Gebratene Nudeln mit Rind und Gemüse" data-ru="Жареная лапша с говядиной и овощами">Smažené nudle s hovězím masem</div></div><div class="menu-item-price">179 Kč</div></div>
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Pad See Ew</div><div class="menu-item-desc t-key" data-cs="Thajské nudle s vejcem, brokolicí a kuřetem" data-en="Thai noodles with egg, broccoli and chicken" data-de="Thai-Nudeln mit Ei, Brokkoli und Hühnchen" data-ru="Тайская лапша с яйцом, брокколи и курицей">Thajské nudle s vejcem a brokolicí</div></div><div class="menu-item-price">185 Kč</div></div>
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Khao Pad Sapparod</div><div class="menu-item-desc t-key" data-cs="Rýže smažená s ananasem, krevety, kešu" data-en="Pineapple fried rice, shrimp, cashew" data-de="Ananas-Reis gebraten, Garnelen, Cashews" data-ru="Жареный рис с ананасом, креветками, кешью">Rýže s ananasem, krevety, kešu</div></div><div class="menu-item-price">199 Kč</div></div>
      </div>
    </div>
    <!-- DRINKS -->
    <div class="menu-category" id="cat-drinks">
      <div class="menu-grid">
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Thai Iced Tea</div><div class="menu-item-desc t-key" data-cs="Thajský mléčný čaj s ledem" data-en="Thai milk tea with ice" data-de="Thaiischer Milchtee mit Eis" data-ru="Тайский молочный чай со льдом">Thajský mléčný čaj s ledem</div></div><div class="menu-item-price">69 Kč</div></div>
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Coconut Smoothie</div><div class="menu-item-desc t-key" data-cs="Čerstvé kokosové mléko, led, tropické ovoce" data-en="Fresh coconut milk, ice, tropical fruit" data-de="Frische Kokosmilch, Eis, Tropenfrüchte" data-ru="Свежее кокосовое молоко, лёд, тропические фрукты">Čerstvé kokosové mléko, led</div></div><div class="menu-item-price">79 Kč</div></div>
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Vietnamská káva</div><div class="menu-item-desc t-key" data-cs="Silná káva s kondenzovaným mlékem, studená" data-en="Strong coffee with condensed milk, iced" data-de="Starker Kaffee mit Kondensmilch, kalt" data-ru="Крепкий кофе со сгущённым молоком, холодный">Silná káva s kondenzovaným mlékem</div></div><div class="menu-item-price">75 Kč</div></div>
        <div class="menu-item"><div class="menu-item-info"><div class="menu-item-name">Jasmine Tea</div><div class="menu-item-desc t-key" data-cs="Jasmínový zelený čaj, horký nebo studený" data-en="Jasmine green tea, hot or cold" data-de="Jasmintee, heiß oder kalt" data-ru="Жасминовый зелёный чай, горячий или холодный">Jasmínový zelený čaj</div></div><div class="menu-item-price">59 Kč</div></div>
      </div>
    </div>
  </div>
</section>

<!-- CONTACT + MAP -->
<section id="contact">
  <div class="section-header reveal">
    <div class="section-tag t-key" data-cs="Kde nás najdete" data-en="Find us" data-de="So finden Sie uns" data-ru="Как нас найти">Kde nás najdete</div>
    <h2 class="section-title t-key" data-cs="Kontakt & mapa" data-en="Contact & map" data-de="Kontakt & Karte" data-ru="Контакт и карта">Kontakt & mapa</h2>
    <div class="section-line"></div>
  </div>
  <div class="contact-grid">
    <div class="reveal">
      <h3 class="t-key" data-cs="Navštivte nás" data-en="Visit us" data-de="Besuchen Sie uns" data-ru="Приходите к нам">Navštivte nás</h3>
      <div class="contact-detail">
        <div class="contact-detail-icon">📍</div>
        <div class="contact-detail-text">
          <strong class="t-key" data-cs="Adresa" data-en="Address" data-de="Adresse" data-ru="Адрес">Adresa</strong>
          Závodu míru 55/124, 360 17 Karlovy Vary – Stará Role
        </div>
      </div>
      <div class="contact-detail">
        <div class="contact-detail-icon">🕐</div>
        <div class="contact-detail-text">
          <strong class="t-key" data-cs="Otevírací doba" data-en="Opening hours" data-de="Öffnungszeiten" data-ru="Часы работы">Otevírací doba</strong>
          <span class="t-key"
            data-cs="Po–Pá: 10:00–22:00 · So–Ne: 11:00–22:00"
            data-en="Mon–Fri: 10:00–22:00 · Sat–Sun: 11:00–22:00"
            data-de="Mo–Fr: 10:00–22:00 · Sa–So: 11:00–22:00"
            data-ru="Пн–Пт: 10:00–22:00 · Сб–Вс: 11:00–22:00">
            Po–Pá: 10:00–22:00 · So–Ne: 11:00–22:00
          </span>
        </div>
      </div>
      <div class="contact-detail">
        <div class="contact-detail-icon">📞</div>
        <div class="contact-detail-text">
          <strong class="t-key" data-cs="Telefon" data-en="Phone" data-de="Telefon" data-ru="Телефон">Telefon</strong>
          <a href="tel:+420" style="color:var(--gold-light);text-decoration:none">+420 XXX XXX XXX</a>
        </div>
      </div>
      <div class="contact-detail">
        <div class="contact-detail-icon">🚌</div>
        <div class="contact-detail-text">
          <strong class="t-key" data-cs="Doprava" data-en="Getting here" data-de="Anfahrt" data-ru="Как добраться">Doprava</strong>
          <span class="t-key"
            data-cs="Autobus č. 7, 11, 22 — zastávka Stará Role"
            data-en="Bus no. 7, 11, 22 — stop Stará Role"
            data-de="Bus Nr. 7, 11, 22 — Haltestelle Stará Role"
            data-ru="Автобус №7, 11, 22 — остановка Stará Role">
            Autobus č. 7, 11, 22 — zastávka Stará Role
          </span>
        </div>
      </div>
      <div style="margin-top:2rem">
        <a href="https://maps.app.goo.gl/yxVtxjMTNMU5uQG69" target="_blank" class="btn-primary t-key"
          data-cs="Otevřít v Google Maps" data-en="Open in Google Maps" data-de="In Google Maps öffnen" data-ru="Открыть в Google Картах">
          Otevřít v Google Maps
        </a>
      </div>
    </div>
    <div class="map-container reveal reveal-delay-2">
      <iframe
        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2548.1234567!2d12.8799!3d50.2291!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x47a099b835c65653%3A0xbbb1694602d6fedf!2sVietThai%20Food%20bistro!5e0!3m2!1scs!2scz!4v1714000000000!5m2!1scs!2scz"
        allowfullscreen=""
        loading="lazy"
        referrerpolicy="no-referrer-when-downgrade"
        title="VietThai Food Bistro map">
      </iframe>
    </div>
  </div>
</section>

<!-- FOOTER -->
<footer>
  <div class="footer-inner">
    <div class="footer-brand">
      <div class="footer-logo">VietThai</div>
      <p class="t-key"
        data-cs="Autentická vietnamská a thajská kuchyně v srdci Karlových Varů. Těšíme se na vás!"
        data-en="Authentic Vietnamese and Thai cuisine in the heart of Karlovy Vary. We look forward to seeing you!"
        data-de="Authentische vietnamesische und thaiische Küche im Herzen von Karlsbad. Wir freuen uns auf Sie!"
        data-ru="Подлинная вьетнамская и тайская кухня в сердце Карловых Варов. Ждём вас!">
        Autentická vietnamská a thajská kuchyně v srdci Karlových Varů. Těšíme se na vás!
      </p>
    </div>
    <div class="footer-col">
      <h4 class="t-key" data-cs="Navigace" data-en="Navigation" data-de="Navigation" data-ru="Навигация">Navigace</h4>
      <ul>
        <li><a href="#about" class="t-key" data-cs="O nás" data-en="About" data-de="Über uns" data-ru="О нас">O nás</a></li>
        <li><a href="#advantages" class="t-key" data-cs="Výhody" data-en="Advantages" data-de="Vorteile" data-ru="Преимущества">Výhody</a></li>
        <li><a href="#services" class="t-key" data-cs="Služby" data-en="Services" data-de="Leistungen" data-ru="Услуги">Služby</a></li>
        <li><a href="#menu" class="t-key" data-cs="Menu" data-en="Menu" data-de="Speisekarte" data-ru="Меню">Menu</a></li>
        <li><a href="#contact" class="t-key" data-cs="Kontakt" data-en="Contact" data-de="Kontakt" data-ru="Контакт">Kontakt</a></li>
      </ul>
    </div>
    <div class="footer-col">
      <h4 class="t-key" data-cs="Kontakt" data-en="Contact" data-de="Kontakt" data-ru="Контакт">Kontakt</h4>
      <ul>
        <li><a href="https://maps.app.goo.gl/yxVtxjMTNMU5uQG69" target="_blank">Závodu míru 55/124, Stará Role</a></li>
        <li><a href="tel:+420000000000">+420 XXX XXX XXX</a></li>
        <li style="color:var(--muted);font-size:0.85rem" class="t-key" data-cs="Po–Pá 10–22 · So–Ne 11–22" data-en="Mon–Fri 10–22 · Sat–Sun 11–22" data-de="Mo–Fr 10–22 · Sa–So 11–22" data-ru="Пн–Пт 10–22 · Сб–Вс 11–22">Po–Pá 10–22 · So–Ne 11–22</li>
      </ul>
    </div>
  </div>
  <div class="footer-bottom">
    <span class="footer-copy">© 2025 VietThai Food Bistro · Karlovy Vary</span>
    <div class="lang-switcher">
      <button class="lang-btn active" onclick="setLang('cs')">CS</button>
      <button class="lang-btn" onclick="setLang('en')">EN</button>
      <button class="lang-btn" onclick="setLang('de')">DE</button>
      <button class="lang-btn" onclick="setLang('ru')">RU</button>
    </div>
  </div>
</footer>

<script>
// ====== LOADER ======
window.addEventListener('load', () => {
  setTimeout(() => {
    document.getElementById('loader').classList.add('hide');
    document.getElementById('heroContent').classList.add('visible');
  }, 2200);
});

// ====== NAV SCROLL ======
const navbar = document.getElementById('navbar');
window.addEventListener('scroll', () => {
  navbar.classList.toggle('scrolled', window.scrollY > 60);
});

// ====== BURGER ======
function toggleMobile() {
  const menu = document.getElementById('mobileMenu');
  const burger = document.getElementById('burger');
  menu.classList.toggle('open');
  burger.classList.toggle('open');
  document.body.style.overflow = menu.classList.contains('open') ? 'hidden' : '';
}
function closeMobile() {
  document.getElementById('mobileMenu').classList.remove('open');
  document.getElementById('burger').classList.remove('open');
  document.body.style.overflow = '';
}

// ====== REVEAL ON SCROLL ======
const observer = new IntersectionObserver((entries) => {
  entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add('visible'); observer.unobserve(e.target); }});
}, { threshold: 0.12 });
document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

// ====== MENU TABS ======
function showCategory(cat) {
  document.querySelectorAll('.menu-category').forEach(c => c.classList.remove('active'));
  document.querySelectorAll('.menu-tab').forEach(t => t.classList.remove('active'));
  document.getElementById('cat-' + cat).classList.add('active');
  event.target.classList.add('active');
}

// ====== LANGUAGE ======
let currentLang = 'cs';
function setLang(lang) {
  currentLang = lang;
  // Update all lang-btn active states
  document.querySelectorAll('.lang-btn').forEach(b => {
    b.classList.toggle('active', b.textContent.toLowerCase() === lang);
  });
  // Update all translatable elements
  document.querySelectorAll('[data-' + lang + ']').forEach(el => {
    const val = el.getAttribute('data-' + lang);
    if (val) el.innerHTML = val;
  });
  // Update menu tab text separately
  document.querySelectorAll('.menu-tab').forEach(btn => {
    const key = lang === 'cs' ? 'data-cs' : lang === 'en' ? 'data-en' : lang === 'de' ? 'data-de' : 'data-ru';
    const val = btn.getAttribute(key);
    if (val) btn.textContent = val;
  });
  document.documentElement.lang = lang;
}
</script>
</body>
</html>
