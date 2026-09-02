# AIM Construction & Update

Costruzione e aggiornamento dell'Asset Information Model (AIM).

## Scope

- Aggregazione modelli as-built e documentazione in AIM strutturato
- Verifica completezza informativa per O&M
- Mapping pset manutentivi (COBie, pset gestione)
- Controllo aggiornamenti nel tempo e allineamento modello-stato reale

## NON fa

- Non gestisce fisicamente il CMMS/CAFM (vedi skill `maintenance-cmms`)
- Non esegue rilievi o verifiche in campo
- Non modifica modelli IFC sorgente

## Normativa

- **UNI EN ISO 19650-3:2021** (ISO 19650-3:2020) — "Organizzazione e digitalizzazione delle informazioni relative all'edilizia e alle opere di ingegneria civile, incluso il BIM — Gestione informativa mediante il BIM — Parte 3: Fase gestionale dei cespiti immobili". Introduce i due concetti cardine dell'AIM:
  - **AIR (Asset Information Requirements)** — requisiti informativi definiti dall'Asset Owner/Appointing Party per la fase gestionale, analoghi agli EIR ma riferiti all'esercizio, non alla costruzione
  - **AIM (Asset Information Model)** — il modello informativo aggregato (geometria + dati alfanumerici + documenti) che deve soddisfare gli AIR; si forma aggregando il PIM (Project Information Model) di consegna con i dati operativi
- **UNI 11337-5:2017** — Gestione digitale dei processi informativi delle costruzioni, Parte 5: Flussi informativi nei processi digitalizzati (capitolato informativo, ruoli PIM→AIM)
- **BS 8536-1:2015** — Briefing for design and construction — Code of practice for facilities management (buildings infrastructure) (Soft Landings)
- **COBie** (NBIMS-US V3 / BS 1192-4:2014) — Construction Operations Building Information Exchange, formato di scambio strutturato in 18 fogli per il trasferimento dati costruzione→gestione

## Struttura COBie (18 fogli)

Il workbook COBie e organizzato in 18 fogli correlati da chiavi esterne (Name/ExtIdentifier). Ai fini della verifica di completezza AIM sono rilevanti tutti, raggruppabili cosi:

| Gruppo | Fogli | Contenuto |
|--------|-------|-----------|
| Anagrafica spaziale | Facility, Floor, Space, Zone | Gerarchia edificio → piano → ambiente → raggruppamento funzionale (es. zona antincendio, zona HVAC) |
| Catalogo asset | Type, Component, System, Assembly, Connection | Type = modello/prodotto (dati produttore, garanzia, vita utile); Component = istanza fisica singola (matricola, ubicazione); System = raggruppamento funzionale di Component; Assembly = composizione gerarchica; Connection = topologia/collegamenti tra Component |
| Manutenzione | Spare, Resource, Job | Ricambi collegati ai Type, risorse (materiali/competenze), piani di manutenzione programmata |
| Supporto e governance | Document, Attribute, Coordinate, Issue, Contact, PickLists | Allegati (manuali, certificati, garanzie), proprieta estese non tabellate altrove, coordinate puntuali, non conformita/azioni aperte, anagrafica soggetti, liste di valori ammessi per la validazione |

## Esempio mapping IFC → COBie

| Elemento/Pset IFC | Foglio COBie | Campo | Note |
|---|---|---|---|
| `IfcBuildingStorey` | Floor | Name, Elevation | |
| `IfcSpace` | Space | Name, Category (da Pset_SpaceCommon), FloorName | GlobalId → ExtSystem/ExtObject per tracciabilita |
| `IfcTypeObject` (es. `IfcPumpType`) + `Pset_ManufacturerTypeInformation` | Type | Name, Model, Manufacturer, WarrantyDurationParts, ExpectedLife | Un solo Type per ogni famiglia/tipo Revit esportata |
| Istanza IFC (es. `IfcPump`) | Component | Name (= Tag IFC), TypeName, Space, SerialNumber, InstallationDate | Tag deve essere univoco nel progetto |
| `IfcSystem` / `IfcDistributionSystem` | System | Name, ComponentNames | Un Component puo appartenere a piu System |
| `Pset_Warranty` | Type/Component | WarrantyStartDate, WarrantyGuarantorParts | Alimenta direttamente il piano di manutenzione in skill `maintenance-cmms` |

## Workflow

1. Acquisisci modelli as-built IFC e documentazione (schede, manuali, certificati)
2. Verifica completezza AIM rispetto agli AIR definiti dal committente:
   - Ogni asset ha: identificativo univoco (Tag), ubicazione (Space), Type di riferimento, produttore, data installazione
   - Schede manutentive e ricambi collegati (Job, Spare)
   - Certificati e garanzie allegati (Document, Attribute)
3. Verifica i 18 fogli COBie per copertura e coerenza referenziale (ogni Component referenzia un TypeName esistente, ogni riga ha un CreatedBy valido in Contact)
4. Genera report gap con azioni correttive, evidenziando i campi obbligatori per il CMMS (warranty, expected life, spare) ancora vuoti

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Considerare l'AIM come il solo modello IFC as-built | L'AIM e IFC + dataset strutturato (COBie o pset equivalenti) che risponde agli AIR — la sola geometria non basta |
| Definire gli AIR dopo la consegna del modello finale | Gli AIR vanno definiti dall'Asset Owner PRIMA dell'appalto, insieme a OIR/EIR (ISO 19650-3 §5) |
| Compilare COBie.Component senza un TypeName corrispondente nel foglio Type | Ogni Component deve referenziare un Type esistente, altrimenti il file non valida e il CMMS non puo importarlo |
| Duplicare lo stesso asset fisico in piu Space | Un Component appartiene a UNA Space; per asset condivisi tra ambienti usare Zone, non righe duplicate |
| Lasciare vuoti i campi Warranty/ExpectedLife/Spare | Sono i campi piu usati dal CMMS per pianificare la manutenzione preventiva — obbligatori per un AIM considerato completo |
