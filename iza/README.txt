Úvod
Aplikácia Challenger slúži účastníkom brnenského lezeckého centra na zaznamenávanie svojich výkonov, porovnávanie sa s ostatnými súťažiacimi v rámci kategórie a vizualizáciu zmien výkonnosti v jednotlivých mesiacoch.

Pre kontext, aplikácia zaznamenáva výsledky v lezeckej disciplíne "bouldering". Ide o lezenie do nízkej výšky po vyznačenej ceste(trase) a zaznamenávame pri nej iba či športovec danú trasu topoval(vyliezol, dosiahol vyznačený cieľ - Boolean), prípadne koľko pokusov na vylezenie potreboval(Integer). Ak súťažiaci vylezie danú trasu na prvý pokus, tak to označujeme špeciálnym výrazom "flash".


Súťaž
Lezecké centrum organizuje súťaž, v ktorej je každý mesiac stanovených 10 trás. Následne majú súťažiaci celý mesiac čas na skúšanie zadaných problémov. Po každom kole vzniká finálne poradie súťažiacich podľa kritérii uvedených vyššie. Navyše sa súťažiaci delia na dve kategórie - hobby a profi. Celá súťaž je založená na fair play a kategóriu, počet topov aj pokusy si používateľ zadáva sám.
Poradie sa určuje na prvom mieste podľa počtu topov(vylezených bouldrov) a na druhom mieste podľa počtu pokusov potrebných na ich vylezenie. Ak súťažiaci skúšal nejakú trasu ale nevyliezol ju, potom sa takéto pokusy do vyhodnotenia nerátajú.


Popis bouldrov
Problémy sú očíslované od 1 po 10. Každý sa nachádza v nejakom sektore(časť lezeckého centra), jeho chyty(úchyty) majú nejakú farbu a bouldru je udelená obtiažnosť(subjektívne hodnotenie dané tým, kto cestu vytvoril). Obtiažnosť je v tzv. francúzskej stupnici(tzv. font scale), ktorá je štandardom v tejto disciplíne(viď priložený obrázok). Ďalej som ako rozšírenie pridal každej ceste label, ktorý by mal popisovať problematiku trasy alebo inak priblížiť súťažiacemu konkrétnu cestu(napr. jugs-madlá, easy-nápoveda, že je daná cesta vhodná aj pre začiatočníkov atď.)


Uloženie persistentných dát
Na uloženie užívateľských dát a informácií o ich výkonoch som použil riešenie od Googlu -- Firebase Auth a Firestore Database. Dôležitá pre mňa bola prenositeľnosť medzi platformami, keďže by mohla v budúcnosti existovať varianta aplikácie pre Android zariadenia, prípadne pre web.

Firestore Database je NoSQL databáza založená na kolekciách dokumentov. Rozhodol som sa použiť následovné kolekcie:
	- users - uchováva osobné informácie poskytnuté pri registrácii
	- boulders - kolekcia ciest vo všetkých kolách súťaže
	- attempts - zobrazuje vzťah 1:1 medzi súťažiacim a konkrétnou cestou v konkrétnom kole sútaže
	- rounds - kolekcia všetkých kôl, dokument pozostáva z roku a mesiacia


Použitie
Počas vývoja som niekoľko krát dával testovať registračný formulár kamarátom a spolužiakom aby som uistil, že je dostatočne intuitívny. Nakoniec som sa rozhodol pre knižnicu Combine, ktorá kontroluje všetky požiadavky na vyplnenie registračného formulára a uvadza nápovedy pre používateľa v prípade, ak nejaký údaj chýba, nezhodujú sa heslá atď.

Po registrácii je užívateľ automaticky prihlásený a može sa zúčastniť aktuálneho kola v sekcii Current pomocou tlačidla Sign Up. To vytvorí dokument v databáze pre každý z aktuálnych bouldrov(v dokumente je uchované id bouldra, id užívateľa, počet topov, počet pokusov). Po kliknutí na položku listu môže užívateľ postupne zaznamenávať progress na danej ceste. Po návrate je informácia automaticky uložená do DB. 

V sekcii Podium je rebríček súťažiacich v aktuálnom kole podľa vyššie uvedených metrík. V sekcii Previous môžme nájsť rebríčky zo predošlých kôl. Nakoniec, v sekcii Performance nájdeme grafy s metrikami pre jednotlivé mesiace. Tieto údaje budú užitočné až po niekoľkých mesiacoch používanie aplikácie, preto som vytvoril demo užívateľa pre plné zobrazenie grafov(DEMO USER \\TODO).
 










