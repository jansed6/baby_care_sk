# Dokumentácia projektu

## Názov projektu

**BabyCare SK** - Slovenský denník starostlivosti o bábätko

---

## Stručný opis projektu

### Platforma
Multiplatformová mobilná aplikácia vyvinutá v **Flutter** pre:
- **Android** (min. API 21 / Android 5.0+)
- **iOS** (min. iOS 12.0+)

### Popis aplikácie

BabyCare SK je minimalistická a privacy-first mobilná aplikácia určená slovenským rodičom pre jednoduché a bezpečné sledovanie základných aktivít ich bábätka. Aplikácia kladie dôraz na ochranu súkromia - všetky údaje sú uložené lokálne na zariadení používateľa bez nutnosti registrácie alebo pripojenia k internetu.

**Hlavné funkcie:**
- ⏱️ **Časovač dojčenia** - sledovanie kŕmenia z materského mlieka s pamätaním posledného prsníka
- 😴 **Spánkový denník** - zaznamenávanie spánkových periód s vizualizáciou denných vzorcov
- 🍼 **Kŕmenie z fľaše** - evidencia umelej výživy s množstvom a časom
- 💩 **Plienky tracker** - jednoduchý počítadlo výmeny plienok

**Kľúčové výhody:**
- ✅ Žiadna registrácia ani prihlasovanie
- ✅ Všetky dáta uložené lokálne (offline-first prístup)
- ✅ Žiadne zbieranie osobných údajov
- ✅ Export denníka do PDF pre konzultácie s pediatrom
- ✅ Slovenské prostredie s intuítivnym Material Design 3 rozhraním
- ✅ Tmavý a svetlý režim
- ✅ Open source riešenie

**Cieľová skupina:** Slovenskí a českí rodičia novorodencov a dojčiat, ktorí preferujú jednoduchosť a ochranu súkromia pred komplexnými cloudovými riešeniami.

---

## Prehľad konkurenčných aplikácií

Na trhu existuje niekoľko etablovaných baby tracking aplikácií. Nasledujúca analýza predstavuje hlavnú konkurenciu a identifikuje ich silné a slabé stránky, čo umožňuje nájsť trhové medzery pre BabyCare SK.

### 1. **Baby + | Your Baby Tracker**

**Vývojár:** Philips Digital UK Limited  
**Platforma:** iOS, Android  
**Hodnotenie:** 4,7/5 (85 hodnotení v SK App Store)  
**Cena:** Zdarma  
**Web:** [https://apps.apple.com/sk/app/baby-your-baby-tracker/id1093774002](https://apps.apple.com/sk/app/baby-your-baby-tracker/id1093774002)

**Popis:**  
Komplexná aplikácia od Philips s viac ako 80 miliónmi používateľov globálne. Poskytuje denné blogy, týždenné vývojové príručky, video návody na dojčení, nástroje na sledovanie (rast, kŕmenie, spánok, zdravie, plienky), denník, míľniky, sledovanie zubov a ukolísavky Disney.

**Výhody:**
- ✅ Značka Philips = dôveryhodnosť
- ✅ Obrovská používateľská základňa a komunita
- ✅ Bohatý obsah (články, videá, tipy)
- ✅ Profesionálne spracované video návody
- ✅ Synchronizácia s Apple Health
- ✅ Podpora viacerých detí a dvojčiat
- ✅ Disney ukolísavky a white noise zvuky

**Nevýhody:**
- ❌ Zbieranie veľkého množstva osobných dát (poloha, identifikátory, dôverné údaje)
- ❌ Personalizované reklamy cez Google Ad Manager
- ❌ Vyžaduje pripojenie na internet pre väčšinu funkcií
- ❌ Angličtina ako primárny jazyk (automatický preklad do slovenčiny)
- ❌ Komplikované UI s množstvom funkcií
- ❌ Nie je open source

---

### 2. **Moje dieťa - Dojčenie, spánku**

**Vývojár:** Aleksei Neiman (nezávislý vývojár)  
**Platforma:** iOS, Android  
**Hodnotenie:** 4,9/5 (1 200 hodnotení v SK App Store)  
**Cena:** Zdarma  
**Web:** [https://apps.apple.com/sk/app/moje-die%C5%A5a-doj%C4%8Denie-sp%C3%A1nku/id1439575933](https://apps.apple.com/sk/app/moje-die%C5%A5a-doj%C4%8Denie-sp%C3%A1nku/id1439575933)

**Popis:**  
Jednoduchá aplikácia od nezávislého vývojára zameraná na sledovanie základných aktivít dieťaťa - kŕmenie, spánok, plienky, odsávanie, zdravie. Nedávno pridaná synchronizácia cez iCloud a export do CSV.

**Výhody:**
- ✅ Najvyššie hodnotenie (4,9/5)
- ✅ Jednoduchosť a prehľadnosť UI
- ✅ Údaje uložené lokálne na zariadení
- ✅ Export do CSV formátu
- ✅ Synchronizácia medzi zariadeniami (iCloud)
- ✅ Sledovanie podľa WHO percentíl
- ✅ Minimálny zber dát - vývojár nezbiera osobné údaje
- ✅ Žiadne reklamy v platenej verzii

**Nevýhody:**
- ❌ Základné grafické zobrazenia
- ❌ Limitované analytické funkcie
- ❌ Nie je open source
- ❌ Žiadny export do PDF
- ❌ Minimálna dokumentácia/podpora
- ❌ Používa služby tretích strán (AdMob, Crashlytics)

---

### 3. **Moje dieťa - BabyCare App**

**Vývojár:** Wachanga LTD  
**Platforma:** iOS, Android, Apple Watch  
**Hodnotenie:** 4,7/5 (332 hodnotení v SK App Store)  
**Cena:** Zdarma (In-app purchases: $2.49/mesiac, $11.49/rok, $9.99 lifetime)  
**Web:** [https://apps.apple.com/sk/app/moje-die%C5%A5a-babycare-app/id1259448817](https://apps.apple.com/sk/app/moje-die%C5%A5a-babycare-app/id1259448817)

**Popis:**  
Komplexná aplikácia od Wachanga (tím 32 zamestnancov) s podporou Apple Watch. Poskytuje sledovanie kŕmenia, spánku, plienok, rastu, časovače, pripomienky a podporu pre viacero detí vrátane dvojčiat. Dostupná v 52 jazykoch.

**Výhody:**
- ✅ Podpora Apple Watch
- ✅ Podpora viacerých detí a dvojčiat simultánne
- ✅ Časovač na notifikačnej lište
- ✅ Periodické pripomienky
- ✅ Cloud zálohovanie a synchronizácia
- ✅ Zdieľanie s príbuznými
- ✅ 52 jazykov
- ✅ Lokálni lekári v 20 krajinách ako konzultanti

**Nevýhody:**
- ❌ Veľa funkcií uzamknutých za paywall
- ❌ Predplatné je relatívne drahé
- ❌ Agresívne zbieranie dát (zdravie, nákupy, poloha, identifikátory, dôverné údaje)
- ❌ Sledovanie používateľov pre reklamné účely
- ❌ Problémy s obnovením platby podľa recenzií
- ❌ Vyžaduje cloud pripojenie pre premium funkcie
- ❌ Nie je open source

---

### 4. **Denník Bábätka**

**Vývojár:** Amila Tech Limited  
**Platforma:** iOS, Android  
**Hodnotenie:** 4,9/5 (45 hodnotení v SK App Store)  
**Cena:** Zdarma  
**Web:** [https://apps.apple.com/sk/app/denn%C3%ADk-b%C3%A1b%C3%A4tka/id1444238371](https://apps.apple.com/sk/app/denn%C3%ADk-b%C3%A1b%C3%A4tka/id1444238371)

**Popis:**  
Jednoduchá a bezplatná aplikácia od Amila Tech zameraná na sledovanie kŕmenia, spánku, plienok a zdravia dieťaťa. Nedávno aktualizovaný dizajn aplikácie.

**Výhody:**
- ✅ Úplne zdarma bez in-app purchases
- ✅ Prehľadné a jednoduché UI
- ✅ Minimálne zbieranie dát
- ✅ Sledovanie zdravia (teplota, lieky, očkovanie)
- ✅ Kalendár a poznámky
- ✅ Štatistiky kŕmenia, spánku a plienok
- ✅ Porovnanie s WHO štandardami

**Nevýhody:**
- ❌ Malá používateľská základňa (len 45 hodnotení)
- ❌ Základné funkcie bez pokročilých analýz
- ❌ Zbiera identifikátory pre sledovanie
- ❌ Žiadny export dát
- ❌ Minimálna dokumentácia
- ❌ Nie je open source
- ❌ Žiadna cloudová synchronizácia

---

### Komparatívna tabuľka

| Kritérium | Baby+ (Philips) | Moje dieťa (Neiman) | BabyCare (Wachanga) | Denník Bábätka (Amila) | **BabyCare SK** |
|-----------|----------------|---------------------|---------------------|------------------------|-----------------|
| **Hodnotenie** | 4.7/5 | 4.9/5 | 4.7/5 | 4.9/5 | - |
| **Počet recenzií (SK)** | 85 | 1 200 | 332 | 45 | - |
| **Cena** | Zdarma | Zdarma | Freemium | Zdarma | Zdarma |
| **Ochrana súkromia** | ⚠️ Nízka | ✅ Stredná | ❌ Nízka | ⚠️ Stredná | ✅ Vysoká |
| **Offline funkčnosť** | ❌ Čiastočná | ✅ Áno | ❌ Čiastočná | ✅ Áno | ✅ Plná |
| **Export PDF** | ❌ Nie | ❌ Nie | ❌ Nie | ❌ Nie | ✅ Áno |
| **Export CSV** | ❌ Nie | ✅ Áno | ❌ Nie | ❌ Nie | ✅ Áno |
| **Slovenská lokalizácia** | ⚠️ Auto-preklad | ⚠️ Auto-preklad | ⚠️ Auto-preklad | ⚠️ Auto-preklad | ✅ Natívna |
| **Open source** | ❌ Nie | ❌ Nie | ❌ Nie | ❌ Nie | ✅ Áno |
| **Registrácia** | ❌ Vyžaduje | ❌ Vyžaduje | ❌ Vyžaduje | ❌ Vyžaduje | ✅ Nie je nutná |
| **Zbieranie dát** | ❌ Rozsiahle | ✅ Minimálne | ❌ Rozsiahle | ⚠️ Stredné | ✅ Žiadne |
| **Reklamy** | ⚠️ Áno | ⚠️ Áno | ⚠️ Áno | ⚠️ Áno | ✅ Nie |

---

### Identifikované trhové medzery

Na základe analýzy konkurencie boli identifikované nasledujúce medzery na trhu:

1. **Žiadna aplikácia nemá natívnu slovenskú lokalizáciu** - všetky používajú automatický preklad, čo vedie k neprirodzeným a neadekvátnym formuláciám.

2. **Ochrana súkromia je zanedbávaná** - všetky analyzované aplikácie zbierajú osobné údaje, používajú analytiku a zobrazujú reklamy.

3. **Žiadna aplikácia neponúka export do PDF** - rodičia nemajú jednoduchý sposob priniesť prehľadný report pediatrovi.

4. **Registrácia je všade povinná** - predstavuje bariéru vstupu pre rodičov, ktorí chcú len rýchlo začať sledovať aktivity.

5. **Open source riešenie chýba** - neexistuje dôveryhodné riešenie s otvoreným kódom, kde by rodičia mohli overiť bezpečnosť.

6. **Nie sú prispôsobené slovenským podmienkam** - očkovacie kalendáre, percently rastu a iné metriky nie sú podľa slovenských/európskych štandardov.

**BabyCare SK** má ambíciu zaplniť tieto medzery a ponúknuť jednoduchú, bezpečnú a skutočne slovenskú alternatívu existujúcim riešeniam.

---

## Návrh architektúry riešenia

### Prehľad architektúry

BabyCare SK je postavená na **offline-first architektúre** s dôrazom na ochranu súkromia a jednoduchosť. Celé riešenie pozostává výhradne z **mobilnej aplikácie** bez potreby backend servera alebo cloudového úložiska.

```
┌─────────────────────────────────────────────────────────┐
│                    MOBILNÁ APLIKÁCIA                     │
│                      (Flutter/Dart)                      │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  ┌─────────────────────────────────────────────────┐    │
│  │         PREZENTAČNÁ VRSTVA (UI Layer)           │    │
│  ├─────────────────────────────────────────────────┤    │
│  │  • Home Screen (Dashboard)                      │    │
│  │  • Breastfeeding Screen (Dojčenie)              │    │
│  │  • Sleep Tracking Screen (Spánok)               │    │
│  │  • Bottle Feeding Screen (Fľaša)                │    │
│  │  • Diaper Tracking Screen (Plienky)             │    │
│  │  • Statistics Screen (Štatistiky)               │    │
│  │  • Settings Screen (Nastavenia)                 │    │
│  │  • PDF Export Screen (Export)                   │    │
│  └─────────────────────────────────────────────────┘    │
│                          │                               │
│                          ▼                               │
│  ┌─────────────────────────────────────────────────┐    │
│  │      BIZNIS LOGIKA (Business Logic Layer)       │    │
│  ├─────────────────────────────────────────────────┤    │
│  │  • State Management (Provider/Riverpod)         │    │
│  │  • Timer Controller (Časovače)                  │    │
│  │  • Statistics Calculator (Výpočet štatistík)    │    │
│  │  • Data Validator (Validácia údajov)            │    │
│  │  • PDF Generator (Generovanie PDF)              │    │
│  │  • Export/Import Logic (CSV export)             │    │
│  └─────────────────────────────────────────────────┘    │
│                          │                               │
│                          ▼                               │
│  ┌─────────────────────────────────────────────────┐    │
│  │         DÁTOVÁ VRSTVA (Data Layer)              │    │
│  ├─────────────────────────────────────────────────┤    │
│  │  • Data Models (Dátové modely)                  │    │
│  │    - FeedingSession                             │    │
│  │    - SleepSession                               │    │
│  │    - BottleFeeding                              │    │
│  │    - DiaperChange                               │    │
│  │  • Repository Pattern (Abstrakcia dát)          │    │
│  │  • Local Storage Service (Lokálne úložisko)    │    │
│  └─────────────────────────────────────────────────┘    │
│                          │                               │
│                          ▼                               │
│  ┌─────────────────────────────────────────────────┐    │
│  │      PERSISTENCIA (Persistence Layer)           │    │
│  ├─────────────────────────────────────────────────┤    │
│  │  • Hive Database (NoSQL lokálna databáza)       │    │
│  │  • Shared Preferences (Nastavenia)              │    │
│  │  • File System (Export súborov)                 │    │
│  └─────────────────────────────────────────────────┘    │
│                                                           │
└───────────────────────────────────────────────────────────┘
                          │
                          ▼
              ┌───────────────────────┐
              │   ZARIADENIE          │
              │   (Lokálne úložisko)  │
              └───────────────────────┘
```

### Súčasti riešenia

#### 1. **Mobilná aplikácia (Flutter)**

##### 1.1 Frontend - Prezentačná vrstva
- **Framework:** Flutter 3.x s Dart
- **UI Design:** Material Design 3 (Material You)
- **Navigácia:** Flutter Navigator 2.0 / go_router
- **Komponenty:**
  - Hlavný dashboard s prehľadom aktivít
  - Špecializované obrazovky pre každý typ aktivity
  - Štatistický prehľad s grafmi (fl_chart)
  - Exportovacia obrazovka
  - Nastavenia aplikácie

##### 1.2 State Management
- **Provider** alebo **Riverpod** pre reaktívny state management
- Separate controllers pre každú doménu (feeding, sleep, diaper)
- Centralizovaný application state

##### 1.3 Business Logic
- **Timer Service:** Ovládanie časovačov pre dojčenie a spánok
- **Statistics Engine:** Výpočet denných/týždenných/mesačných štatistík
- **PDF Generator:** Tvorba prehľadného PDF reportu pre pediatra (pdf package)
- **CSV Exporter:** Export surových dát do CSV formátu
- **Validation Layer:** Validácia užívateľských vstupov

#### 2. **Lokálne úložisko dát**

##### 2.1 Hive Database
- **NoSQL lokálna databáza** optimalizovaná pre Flutter
- **Boxes (kolekcie):**
  - `feeding_box` - záznamy o dojčení
  - `sleep_box` - záznamy o spánku
  - `bottle_box` - záznamy o kŕmení z fľaše
  - `diaper_box` - záznamy o plienkovní
- **TypeAdapter** pre vlastné dátové modely
- **Šifrovanie:** Voliteľné šifrovanie citlivých dát

##### 2.2 Shared Preferences
- Užívateľské nastavenia (theme mode, jazyk)
- Aplikačné preferencie
- Posledný použitý prsník (pre dojčenie)

##### 2.3 File System
- Dočasné úložisko pre export PDF/CSV súborov
- Správa cache súborov

#### 3. **Dátové modely**

```dart
// Príklad štruktúry dátových modelov

FeedingSession {
  - id: String
  - timestamp: DateTime
  - duration: Duration
  - breast: Enum (left/right/both)
  - notes: String?
}

SleepSession {
  - id: String
  - startTime: DateTime
  - endTime: DateTime?
  - duration: Duration?
  - quality: Enum?
  - notes: String?
}

BottleFeeding {
  - id: String
  - timestamp: DateTime
  - amountMl: int
  - feedingType: Enum (formula/breastmilk)
  - notes: String?
}

DiaperChange {
  - id: String
  - timestamp: DateTime
  - type: Enum (wet/dirty/both)
  - notes: String?
}
```

#### 4. **Externé závislosti**

Aplikácia využíva minimálny počet externých balíčkov:
- `hive` + `hive_flutter` - lokálna databáza
- `provider` / `riverpod` - state management
- `fl_chart` - vizualizácia grafov
- `pdf` - generovanie PDF dokumentov
- `path_provider` - prístup k súborovému systému
- `share_plus` - zdieľanie exportovaných súborov
- `intl` - lokalizácia a formátovanie

### Bezpečnosť a ochrana súkromia

#### Princípy:
1. **Zero-knowledge prístup** - žiadne dáta neopúšťajú zariadenie
2. **Žiadna analytika** - žiadne sledovanie používateľského správania
3. **Žiadna registrácia** - žiadne osobné údaje
4. **Lokálne šifrovanie** - voliteľné šifrovanie Hive databázy
5. **Open source** - transparentnosť kódu

### Výkonnostné požiadavky

- **Startup time:** < 2 sekundy
- **Responsiveness:** < 100ms na interakciu
- **Memory footprint:** < 100MB RAM
- **Storage:** < 50MB aplikácia, < 10MB/rok dát
- **Battery impact:** Minimálny (žiadne background services)

### Škálovateľnosť

Aplikácia je navrhnutá pre:
- **1-3 deti** na rodinu
- **Unlimited záznamy** (obmedzené len úložiskom zariadenia)
- **Multi-year history** s archivačnými funkciami

### Budúce rozšírenia (out of scope pre MVP)

- Cloud backup (voliteľný, end-to-end encrypted)
- Zdieľanie medzi rodičmi cez P2P
- Apple Watch / Wear OS companion app
- Widget pre home screen
- Hlasové ovládanie
- Integrácia s Health Kit / Google Fit
- Push notifikácie a pripomienky

---

## Návrh obrazoviek

Používateľské rozhraní aplikácie bolo navrhnuté vo Figme s dôrazom na jednoduchosť, intuitívnosť a Material Design 3 princípy. Návrhy zahŕňajú svetlý aj tmavý režim pre všetky kľúčové obrazovky.

### Figma prototypy

> **Poznámka:** Návrhy obrazoviek sú dostupné vo Figme (free verzia):
> - 🎨 **Figma link:** [Tu doplň link na tvoj Figma projekt]
> 
> Všetky obrazovky sú umiestnené na jednej page pre jednoduchosť a prehľadnosť.

### Minimálne požadované obrazovky pre MVP

Pre školský projekt postačuje navrhnúť **5 hlavných obrazoviek**:

1. **Dashboard / Home Screen** - hlavný prehľad všetkých aktivít
2. **Breastfeeding Screen** - obrazovka pre dojčenie s časovačom
3. **Sleep Tracking Screen** - sledovanie spánku dieťaťa
4. **Bottle Feeding Screen** - kŕmenie z fľaše
5. **Diaper Tracking Screen** - evidencia výmeny plienok

**Voliteľne (ak máš čas):**
- **Statistics Screen** - štatistiky a grafy
- **Settings Screen** - nastavenia aplikácie

### Praktické tipy pre Figmu (free verzia)

#### Použitie iOS UI Kit z Figma Community
1. Otvor Figma Community (ikona vľavo dole)
2. Vyhľadaj **"iOS UI Kit"** alebo **"iOS 17 UI Kit"**
3. Duplikuj do svojho projektu (zadarmo)
4. Používaj ready-made komponenty:
   - Navigation bars
   - Tab bars
   - Buttons
   - Text fields
   - Cards
   - Lists

**Odporúčané kity (všetky free):**
- **iOS 17 UI Kit** by Apple Design Resources
- **Material Design 3 Kit** (ak preferuješ Material Design)
- **SF Symbols** - ikony pre iOS

#### Jednoduchá štruktúra Figma projektu

**1 Page = Celý projekt**

Usporiadanie na page (zľava doprava):
```
[Dashboard] → [Breastfeeding] → [Sleep] → [Bottle] → [Diaper]
```

Pod každou obrazovkou môžeš mať:
```
[Hlavná obrazovka]
     ↓
[Empty state]
     ↓
[Filled state s dátami]
```

#### Čo stačí pre školský projekt

✅ **Potrebuješ:**
- Statické mockupy (nie interaktívny prototyp)
- Základné iOS/Material komponenty
- 5 hlavných obrazoviek
- Svetlý režim (tmavý je voliteľný)
- Jednoduchý layout s textom, tlačidlami, ikonami

❌ **Nepotrebuješ:**
- Vlastný design system
- Auto-layout (môžeš, ale nie musíš)
- Komponenty s variantmi
- Interaktívne prototypy s animáciami
- Pixel-perfect dizajn

### Rýchly postup (30-60 minút na všetko)

#### Krok 1: Setup (5 min)
1. Vytvor nový Figma file
2. Premenuj page na "BabyCare SK Screens"
3. Nastav frame: **iPhone 14 Pro** (393 x 852 px)

#### Krok 2: Duplikuj iOS UI Kit (5 min)
1. Community → hľadaj "iOS 17 UI Kit"
2. Duplicate to your drafts
3. Copy komponenty ktoré potrebuješ

#### Krok 3: Dashboard (10 min)
- App bar (iOS navigation bar) s názvom "BabyCare SK"
- 4 card komponenty pre štatistiky (Dojčenie, Spánok, Fľaša, Plienky)
- Bottom navigation bar s 4 ikonami
- FAB tlačidlo vpravo dole

#### Krok 4: Breastfeeding Screen (10 min)
- App bar s back button
- Veľký časovač uprostred (00:00:00)
- 3 tlačidlá: [Ľavé] [Obidve] [Pravé]
- START/STOP tlačidlá
- Posledných 5 záznamov v liste

#### Krok 5: Sleep Screen (10 min)
- Kópia Breastfeeding, ale:
- Zmeň nadpis na "Spánok"
- Len 1 tlačidlo START SLEEP
- Lista spánkových periód

#### Krok 6: Bottle & Diaper (10 min každá)
- Bottle: Input field pre ml + Save button
- Diaper: Jednoduchý counter + ADD button

#### Krok 7: Export (5 min)
- File → Export
- PNG alebo PDF
- Alebo len pošli Figma link

### Minimálne farby (stačí použiť tieto)

```
Primary: #007AFF (iOS Blue)
Background: #FFFFFF (White)
Text: #000000 (Black)
Secondary Text: #8E8E93 (Gray)
Divider: #E5E5EA (Light Gray)
```

### Základné komponenty ktoré použiť

Z iOS UI Kit vezmi len:
- ✅ Navigation Bar (top bar)
- ✅ Tab Bar (bottom navigation)
- ✅ Buttons (primary, secondary)
- ✅ List items (pre históriu)
- ✅ Text fields (pre input)
- ✅ SF Symbols ikony

**Nemusíš:**
- ❌ Vytvárať vlastné komponenty
- ❌ Riešiť responsive
- ❌ Robiť auto-layout
- ❌ Prototypovať interakcie

---

## Popis obrazoviek

Táto sekcia obsahuje detailný popis každej obrazovky vrátane user stories a use cases, ktoré definujú funkcionalitu a správanie aplikácie.

---

### 1. Dashboard / Home Screen

**Účel:** Hlavná obrazovka poskytujúca prehľad o nedávnych aktivitách a rýchly prístup ku všetkým funkciám.

#### User Stories

**US-01: Zobrazenie denného prehľadu**
```
Ako rodič
chcem vidieť prehľad dnešných aktivít
aby som mal okamžitý náhľad na to, čo sa dnes udialo s mojím dieťaťom.

Acceptance Criteria:
- Dashboard zobrazuje počet kŕmení dnes
- Dashboard zobrazuje celkový čas spánku dnes
- Dashboard zobrazuje počet výmen plienok dnes
- Dashboard zobrazuje čas poslednej aktivity
- Údaje sa aktualizujú real-time
```

**US-02: Rýchle spustenie aktivity**
```
Ako rodič v stresovej situácii
chcem rýchlo spustiť sledovanie aktivity jedným kliknutím
aby som nemusel navigovať cez viacero obrazoviek.

Acceptance Criteria:
- FAB umožňuje spustiť novú aktivitu
- Bottom sheet ponúka všetky typy aktivít
- Časovač sa spustí okamžite po výbere
- Aplikácia poskytne vizuálny a hmatový feedback
```

#### Use Cases

**UC-01: Zobrazenie Dashboard**

| Položka | Popis |
|---------|-------|
| **Use Case ID** | UC-01 |
| **Názov** | Zobrazenie Dashboard |
| **Aktér** | Rodič |
| **Predpoklad** | Aplikácia je nainštalovaná a spustená |
| **Hlavný tok** | 1. Rodič spustí aplikáciu<br>2. Systém načíta dnešné záznamy<br>3. Systém zobrazí Dashboard s prehľadom<br>4. Rodič vidí posledné 5 aktivít<br>5. Rodič vidí denné štatistiky |
| **Alternatívny tok** | 3a. Ak nie sú žiadne záznamy, systém zobrazí prázdny stav s výzvou na pridanie prvej aktivity |
| **Výsledok** | Rodič má prehľad o dnešných aktivitách |

**UC-02: Spustenie novej aktivity**

| Položka | Popis |
|---------|-------|
| **Use Case ID** | UC-02 |
| **Názov** | Rýchle spustenie aktivity |
| **Aktér** | Rodič |
| **Predpoklad** | Rodič je na Dashboard obrazovke |
| **Hlavný tok** | 1. Rodič klikne na FAB<br>2. Systém zobrazí bottom sheet s typmi aktivít<br>3. Rodič vyberie typ aktivity<br>4. Systém naviguje na príslušnú obrazovku<br>5. Aktivita sa automaticky spustí |
| **Alternatívny tok** | 3a. Rodič klikne mimo bottom sheet - zruší sa akcia |
| **Výsledok** | Nová aktivita je spustená |

---

### 2. Breastfeeding Screen (Obrazovka dojčenia)

**Účel:** Sledovanie kŕmenia materským mliekom s časovačom a pamätaním posledného prsníka.

#### User Stories

**US-03: Sledovanie dojčenia**
```
Ako matka
chcem sledovať z ktorého prsníka a ako dlho som dojčila
aby som mohla striedať prsníky a evidovať kŕmenie.

Acceptance Criteria:
- Obrazovka zobrazuje tlačidlá pre ľavé/pravé/obidve prsia
- Posledný použitý prsník je zvýraznený
- Časovač zobrazuje uplynulý čas
- Časovač možno pozastaviť a pokračovať
- Po ukončení sa záznam uloží s časom a prsníkom
```

**US-04: Automatické odporúčanie prsníka**
```
Ako matka
chcem vidieť odporúčanie ktorý prsník použiť
aby som automaticky striedala prsníky.

Acceptance Criteria:
- Aplikácia pamätá posledný použitý prsník
- Odporúčaný prsník je vizuálne zvýraznený
- Rodič môže ignorovať odporúčanie a vybrať iný
- História zobrazuje striedanie prsníkov
```

#### Use Cases

**UC-03: Spustenie časovača dojčenia**

| Položka | Popis |
|---------|-------|
| **Use Case ID** | UC-03 |
| **Názov** | Spustenie časovača dojčenia |
| **Aktér** | Matka |
| **Predpoklad** | Matka je na obrazovke dojčenia |
| **Hlavný tok** | 1. Matka vyberie prsník (ľavé/pravé/obidve)<br>2. Systém spustí časovač<br>3. Systém zobrazuje uplynulý čas<br>4. Matka klikne na STOP po dokončení<br>5. Systém uloží záznam s časom a prsníkom<br>6. Systém zobrazí potvrdenie |
| **Alternatívny tok** | 3a. Matka pozastaví časovač - čas sa zastaví<br>3b. Matka pokračuje v časovači - čas beží ďalej<br>4a. Matka zruší - záznam sa neuloží |
| **Výsledok** | Záznam o dojčení je uložený |

---

### 3. Sleep Tracking Screen (Obrazovka spánku)

**Účel:** Evidencia spánkových periód dieťaťa pre analýzu spánkového režimu.

#### User Stories

**US-05: Sledovanie spánku**
```
Ako rodič
chcem zaznamenať kedy dieťa zaspalo a zobudilo sa
aby som mohol analyzovať spánkový režim.

Acceptance Criteria:
- Tlačidlo START spustí spánkový časovač
- Zobrazuje sa čas od začiatku spánku
- Tlačidlo STOP ukončí spánok a uloží záznam
- Záznam obsahuje začiatok, koniec a trvanie
- História zobrazuje všetky spánkové periody
```

**US-06: Vizualizácia spánkového vzoru**
```
Ako rodič
chcem vidieť grafické zobrazenie spánku za deň/týždeň
aby som identifikoval spánkové vzory dieťaťa.

Acceptance Criteria:
- Graf zobrazuje spánkové bloky na časovej osi
- Možnosť prepnúť medzi denným/týždenným zobrazením
- Farebné rozlíšenie denných a nočných spánkov
- Zobrazenie celkového času spánku
```

#### Use Cases

**UC-04: Zaznamenanie spánku**

| Položka | Popis |
|---------|-------|
| **Use Case ID** | UC-04 |
| **Názov** | Zaznamenanie spánkovej periódy |
| **Aktér** | Rodič |
| **Predpoklad** | Dieťa ide spať |
| **Hlavný tok** | 1. Rodič klikne na START SLEEP<br>2. Systém zaznamená čas začiatku<br>3. Časovač beží na pozadí<br>4. Rodič klikne STOP SLEEP po prebudení<br>5. Systém vypočíta trvanie<br>6. Systém uloží záznam<br>7. Systém aktualizuje štatistiky |
| **Alternatívny tok** | 3a. Aplikácia môže bežať na pozadí<br>4a. Rodič môže editovať časy manuálne |
| **Výsledok** | Spánková perióda je zaznamenaná |

---

### 4. Bottle Feeding Screen (Obrazovka kŕmenia z fľaše)

**Účel:** Evidencia kŕmenia umelou výživou alebo odsatým materským mliekom.

#### User Stories

**US-07: Zaznamenanie kŕmenia z fľaše**
```
Ako rodič
chcem zaznamenať koľko ml dieťa vypilo z fľaše
aby som sledoval príjem stravy.

Acceptance Criteria:
- Formulár umožňuje zadať množstvo v ml
- Možnosť vybrať typ (materské mlieko/umelá výživa)
- Automatické doplnenie aktuálneho času
- Možnosť upraviť čas manuálne
- Po uložení sa záznam zobrazí v histórii
```

**US-08: Štatistika príjmu stravy**
```
Ako rodič
chcem vidieť celkové množstvo prijatej stravy za deň
aby som mal istotu že dieťa prijalo dostatok výživy.

Acceptance Criteria:
- Zobrazenie celkového počtu ml za deň
- Zobrazenie počtu kŕmení za deň
- Priemer ml na jedno kŕmenie
- Graf príjmu stravy v čase
```

#### Use Cases

**UC-05: Pridanie záznamu o kŕmení z fľaše**

| Položka | Popis |
|---------|-------|
| **Use Case ID** | UC-05 |
| **Názov** | Zaznamenanie kŕmenia z fľaše |
| **Aktér** | Rodič |
| **Predpoklad** | Dieťa bolo nakŕmené z fľaše |
| **Hlavný tok** | 1. Rodič otvorí Bottle Feeding screen<br>2. Systém zobrazí formulár<br>3. Rodič zadá množstvo v ml<br>4. Rodič vyberie typ stravy<br>5. Rodič klikne SAVE<br>6. Systém validuje údaje<br>7. Systém uloží záznam<br>8. Systém zobrazí potvrdenie |
| **Alternatívny tok** | 6a. Neplatné množstvo - zobrazí chybu<br>5a. Rodič klikne CANCEL - záznam sa neuloží |
| **Výsledok** | Záznam o kŕmení je uložený |

---

### 5. Diaper Tracking Screen (Obrazovka plienok)

**Účel:** Jednoduchá evidencia výmeny plienok.

#### User Stories

**US-09: Evidencia výmeny plienok**
```
Ako rodič
chcem rýchlo zaznamenať výmenu plienky
aby som sledoval frekvenciu výmeny.

Acceptance Criteria:
- Jedno tlačidlo pre pridanie záznamu
- Možnosť vybrať typ (mokrá/špinavá/oboje)
- Automatické uloženie s aktuálnym časom
- Zobrazenie počtu výmen za deň
- História všetkých výmen
```

**US-10: Sledovanie frekvencii výmeny**
```
Ako rodič
chcem vidieť koľko plienok som vymenil za deň
aby som mal prehľad o zdraví tráviaceho systému dieťaťa.

Acceptance Criteria:
- Counter zobrazuje počet výmen dnes
- Rozdelenie podľa typu (mokrá/špinavá)
- Čas poslednej výmeny
- Denný/týždenný prehľad
```

#### Use Cases

**UC-06: Zaznamenanie výmeny plienky**

| Položka | Popis |
|---------|-------|
| **Use Case ID** | UC-06 |
| **Názov** | Zaznamenanie výmeny plienky |
| **Aktér** | Rodič |
| **Predpoklad** | Rodič vymenil plienku |
| **Hlavný tok** | 1. Rodič otvorí Diaper screen<br>2. Rodič klikne na ADD DIAPER CHANGE<br>3. Systém zobrazí bottom sheet<br>4. Rodič vyberie typ plienky<br>5. Rodič klikne SAVE<br>6. Systém uloží záznam<br>7. Systém inkrementuje counter<br>8. Systém zobrazí aktualizovaný počet |
| **Alternatívny tok** | 4a. Rodič klikne CANCEL - záznam sa neuloží |
| **Výsledok** | Výmena plienky je zaznamenaná |

---

### 6. Statistics Screen (Obrazovka štatistík)

**Účel:** Vizualizácia a analýza zhromaždených dát.

#### User Stories

**US-11: Zobrazenie štatistík**
```
Ako rodič
chcem vidieť grafické zobrazenie všetkých aktivít
aby som identifikoval vzory a trendy.

Acceptance Criteria:
- Graf dojčenia (frekvencia, trvanie)
- Graf spánku (denné/nočné)
- Graf kŕmenia z fľaše (množstvo)
- Graf plienok (počet, typ)
- Možnosť filtrovať podľa obdobia (deň/týždeň/mesiac)
```

**US-12: Porovnanie období**
```
Ako rodič
chcem porovnať tento týždeň s minulým týždňom
aby som videl zlepšenie alebo zhoršenie.

Acceptance Criteria:
- Zobrazenie týždenného trendu
- Farebné zvýraznenie zlepšenia/zhoršenia
- Percentuálna zmena
```

#### Use Cases

**UC-07: Zobrazenie štatistík**

| Položka | Popis |
|---------|-------|
| **Use Case ID** | UC-07 |
| **Názov** | Zobrazenie grafických štatistík |
| **Aktér** | Rodič |
| **Predpoklad** | Existujú uložené záznamy |
| **Hlavný tok** | 1. Rodič naviguje na Statistics screen<br>2. Systém načíta dáta<br>3. Systém vypočíta štatistiky<br>4. Systém vygeneruje grafy<br>5. Rodič scrolluje cez štatistiky<br>6. Rodič môže zmeniť časové obdobie |
| **Alternatívny tok** | 2a. Žiadne dáta - zobrazí prázdny stav |
| **Výsledok** | Rodič vidí prehľad štatistík |

---

### 7. Export Screen (Obrazovka exportu)

**Účel:** Export dát do PDF alebo CSV formátu.

#### User Stories

**US-13: Export do PDF pre pediatra**
```
Ako rodič pred návštevou pediatra
chcem vygenerovať prehľadný PDF report
aby som mohol ukázať údaje lekárovi.

Acceptance Criteria:
- Možnosť vybrať časové obdobie
- PDF obsahuje všetky aktivity
- PDF obsahuje grafy a štatistiky
- PDF je prehľadne formátovaný
- Možnosť zdieľať cez share sheet
```

**US-14: Export surových dát do CSV**
```
Ako technicky zdatný rodič
chcem exportovať surové dáta do CSV
aby som mohl robiť vlastné analýzy.

Acceptance Criteria:
- CSV obsahuje všetky záznamy
- CSV je štandardne formátovaný
- Možnosť otvoriť v Excel/Numbers
- Možnosť zdieľať súbor
```

#### Use Cases

**UC-08: Generovanie PDF reportu**

| Položka | Popis |
|---------|-------|
| **Use Case ID** | UC-08 |
| **Názov** | Export dát do PDF |
| **Aktér** | Rodič |
| **Predpoklad** | Existujú dáta na export |
| **Hlavný tok** | 1. Rodič otvorí Export screen<br>2. Rodič vyberie obdobie (týždeň/mesiac)<br>3. Rodič klikne GENERATE PDF<br>4. Systém načíta dáta<br>5. Systém vygeneruje PDF<br>6. Systém zobrazí náhľad PDF<br>7. Rodič klikne SHARE<br>8. Systém otvorí share sheet |
| **Alternatívny tok** | 4a. Žiadne dáta - zobrazí chybovú hlášku<br>5a. Chyba generovania - zobrazí error |
| **Výsledok** | PDF je vygenerované a zdieľané |

---

### 8. Settings Screen (Obrazovka nastavení)

**Účel:** Konfigurácia aplikácie a správa dát.

#### User Stories

**US-15: Zmena témy**
```
Ako rodič
chcem prepnúť medzi svetlým a tmavým režimom
aby som prispôsobil aplikáciu prostrediu.

Acceptance Criteria:
- Možnosť vybrať Light/Dark/System
- Okamžité prepnutie témy
- Nastavenie sa uloží
```

**US-16: Správa dát**
```
Ako rodič
chcem mať kontrolu nad svojimi dátami
aby som ich mohol vymazať alebo exportovať.

Acceptance Criteria:
- Možnosť vymazať všetky dáta
- Potvrdzovacie dialógy pred vymazaním
- Export všetkých dát
- Zobrazenie veľkosti uložených dát
```

#### Use Cases

**UC-09: Zmena nastavení**

| Položka | Popis |
|---------|-------|
| **Use Case ID** | UC-09 |
| **Názov** | Konfigurácia aplikácie |
| **Aktér** | Rodič |
| **Predpoklad** | Rodič chce zmeniť nastavenia |
| **Hlavný tok** | 1. Rodič otvorí Settings screen<br>2. Systém zobrazí všetky nastavenia<br>3. Rodič zmení požadované nastavenia<br>4. Systém okamžite aplikuje zmeny<br>5. Systém uloží preferencie |
| **Alternatívny tok** | - |
| **Výsledok** | Nastavenia sú zmenené |

---

### 9. Navigačné vzory

#### Bottom Navigation
- **Dashboard** (ikona: home)
- **Add Activity** (ikona: FAB - add_circle)
- **Statistics** (ikona: bar_chart)
- **Settings** (ikona: settings)

#### Gesture navigácia
- **Swipe left/right** - prepínanie medzi obrazovkami
- **Pull to refresh** - obnovenie dát na Dashboard
- **Long press** - editácia/vymazanie záznamu v histórii

---

### 10. Empty States a Error Handling

**Empty State Messages:**
- "Ešte žiadne záznamy. Začni sledovať aktivity dieťaťa!"
- "História je prázdna. Pridaj prvý záznam pomocou + tlačidla."
- "Žiadne dáta na zobrazenie za vybrané obdobie."

**Error Messages:**
- "Nepodarilo sa uložiť záznam. Skús to prosím znova."
- "Neplatné množstvo. Zadaj hodnotu medzi 0 a 500 ml."
- "Chyba pri generovaní PDF. Skontroluj dostupné úložisko."

---

## Technologický stack

| Vrstva | Technológia |
|--------|-------------|
| **Frontend Framework** | Flutter 3.x |
| **Programovací jazyk** | Dart 3.x |
| **UI Design System** | Material Design 3 |
| **State Management** | Provider / Riverpod |
| **Lokálna databáza** | Hive |
| **Grafické zobrazenia** | FL Chart |
| **PDF generovanie** | pdf package |
| **Lokalizácia** | flutter_localizations |
| **Testing** | flutter_test, mockito |
| **CI/CD** | GitHub Actions |
| **Version Control** | Git + GitHub |

---

## Vývojové prostredie

- **IDE:** Visual Studio Code / Android Studio
- **Emulátor:** Android Emulator, iOS Simulator
- **Testovanie:** Fyzické zariadenia (Android & iOS)
- **Version:** Flutter 3.24+ (stable channel)

---

*Dokumentácia vytvorená: December 2025*  
*Verzia: 1.0*  
*Autor: Eduard Jánský*
