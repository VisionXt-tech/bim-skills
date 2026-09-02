# Digital Twin Analytics

Analisi dati IoT e performance per digital twin di edifici.

## Scope

- Gestione dati da sensori IoT collegati a modello BIM
- Analisi performance energetiche e ambientali
- Supporto decisioni di retrofit e riqualificazione
- Dashboard di monitoraggio continuo

## NON fa

- Non installa o configura sensori fisici
- Non esegue simulazioni energetiche (usa dati reali)
- Non progetta impianti

## Normativa

- **UNI EN ISO 19650-3:2021** (ISO 19650-3:2020) — Fase gestionale dei cespiti immobili. Il digital twin analitico e un consumatore dell'AIM: i dati IoT si aggregano ad esso, non lo sostituiscono, e devono rispondere agli AIR definiti per il monitoraggio prestazionale
- **UNI EN ISO 52000-1:2017** — "Prestazione energetica degli edifici — Valutazione EPB globale — Parte 1: Quadro generale e procedure". E la norma quadro (overarching) della serie EPB che struttura il calcolo/monitoraggio della prestazione energetica; usarla come riferimento per gli indicatori di comfort e consumo, non come norma di dettaglio impiantistico
- **D.Lgs. 48/2020** — Attuazione della direttiva (UE) 2018/844 (EPBD III, che modifica le direttive 2010/31/UE e 2012/27/UE). Introduce, tra l'altro, i requisiti sui sistemi di automazione e controllo degli edifici (building automation) e la strategia di lungo termine per la riqualificazione del patrimonio edilizio: riferimento diretto per giustificare interventi di retrofit basati sui dati del digital twin

## NOTA — Dati IoT non sono un pset COBie standard

I 18 fogli COBie (vedi skill `aim-construction`) descrivono asset statici, non serie temporali di sensori: non esiste un foglio COBie per i dati IoT. Il collegamento corretto e:
- I sensori/dispositivi IoT si registrano come **Component** (con proprio Type "sensore/misuratore")
- Le zone di monitoraggio si mappano su **Space**/**Zone** gia presenti nell'AIM
- Le serie temporali (letture, timeseries) restano in un time-series database o storico esterno, collegato al Component via identificativo (Tag/GlobalId) — MAI dentro il foglio COBie stesso

## Esempio mapping sensore IoT → BIM/AIM

| Dato IoT | Elemento AIM/BIM | Note |
|---|---|---|
| ID dispositivo sensore CO2 | COBie.Component (Type = "Sensore CO2") | Component.Space = ambiente monitorato |
| Timeseries temperatura/umidita | Storico esterno (time-series DB), chiave = Component.Tag | Non in COBie: solo il riferimento all'asset resta nell'AIM |
| Consumo energetico per zona | Aggregato su COBie.Zone o IfcZone | Base per l'indicatore EPB (UNI EN ISO 52000-1) |
| Anomalia rilevata (es. deriva di setpoint) | COBie.Issue collegato al Component | Alimenta il feedback verso `maintenance-cmms` (apertura ticket) |

## Workflow

1. Acquisisci: AIM (con anagrafica Space/Zone/Component), sorgenti dati IoT (temperatura, umidita, consumo, CO2)
2. Mappa sensori a zone/spazi del modello BIM, registrando ogni dispositivo come Component con Tag univoco
3. Analizza trend: consumi, comfort, anomalie — confrontando con gli indicatori EPB (UNI EN ISO 52000-1) e gli obiettivi di riqualificazione (D.Lgs. 48/2020)
4. Genera report con raccomandazioni per ottimizzazione e retrofit, tracciando le anomalie ricorrenti come Issue collegate all'AIM
5. Identifica interventi con miglior rapporto costo/beneficio, coordinandoti con la skill `maintenance-cmms` per la generazione dei ticket correttivi

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Provare a forzare le timeseries IoT dentro i fogli COBie | COBie descrive asset statici, non serie temporali: i dati IoT vanno in uno storico esterno collegato via Tag/GlobalId al Component |
| Citare "ISO 19650-3" come norma generica su IoT/digital twin | La 19650-3 riguarda la gestione informativa in fase gestionale (AIR/AIM), non prescrive protocolli o architetture IoT: usarla per il collegamento AIM↔dati, non come fonte tecnica sui sensori |
| Confondere UNI EN ISO 52000-1 con una norma di dimensionamento impianti | E la norma quadro (overarching) della serie EPB: definisce framework e procedure di valutazione, i dettagli di calcolo sono nelle norme EPB specifiche (es. UNI EN ISO 52016 per fabbisogno termico) |
| Presentare raccomandazioni di retrofit senza collegarle a un asset/Component tracciabile nell'AIM | Ogni raccomandazione deve referenziare lo Space/Zone/Component interessato, altrimenti non e azionabile dal team di manutenzione |
| Usare D.Lgs. 48/2020 come riferimento per l'attestazione energetica (APE) | Il decreto riguarda prevalentemente automazione, controllo e strategia di riqualificazione: per l'APE il riferimento e la normativa nazionale/regionale sulla certificazione energetica |
