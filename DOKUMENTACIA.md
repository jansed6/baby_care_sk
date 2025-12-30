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
