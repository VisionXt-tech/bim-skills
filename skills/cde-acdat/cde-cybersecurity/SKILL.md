# CDE Cybersecurity & Compliance

Verifica sicurezza e compliance dell'architettura CDE.

## Scope

- Audit di sicurezza dell'architettura CDE
- Verifica compliance GDPR per dati personali nel CDE
- Allineamento con ISO 27001 per information security
- Verifica requisiti di resilienza e disaster recovery
- Controllo tracciabilita accessi e operazioni

## Normativa

- **ISO/IEC 27001:2022, Annex A** — 93 controlli in 4 temi (Organizzativi 37, Persone 8, Fisici 14, Tecnologici 34); i piu rilevanti per un CDE sono elencati nella checklist sotto
- **GDPR (Reg. UE 2016/679)**:
  - **Art. 5** — 6 principi del trattamento: liceita/correttezza/trasparenza, limitazione della finalita, minimizzazione dei dati, esattezza, limitazione della conservazione, integrita e riservatezza; piu il principio di accountability (art. 5.2, onere della prova in capo al titolare)
  - **Art. 25** — Privacy by design (misure tecniche/organizzative fin dalla progettazione del CDE) e by default (accessibilita/conservazione/diffusione dei dati limitate al minimo necessario di default)
  - **Art. 32** — Sicurezza del trattamento: pseudonimizzazione e cifratura; capacita di assicurare riservatezza, integrita, disponibilita e resilienza dei sistemi; capacita di ripristinare la disponibilita e l'accesso ai dati in caso di incidente; procedura di test/verifica/valutazione periodica dell'efficacia delle misure
- **ISO 19650-5** — Security-minded approach: definisce il "security triage process" (valutazione se il progetto richiede un approccio orientato alla sicurezza), la sensitivity assessment (valutazione della sensibilita delle informazioni, non solo geometria ma anche dati su prodotti/servizi/tecnologie/risorse), la security strategy (minacce, vulnerabilita, probabilita, misure di mitigazione) e il security management plan (processi e responsabilita operative per proteggere le informazioni sensibili)
- **Allegato I.9, art. 1, D.Lgs. 36/2023** — richiede che il Capitolato Informativo definisca condizioni di proprieta, accesso e validita dei dati "anche con riferimento alla protezione e sicurezza dei dati e alla riservatezza"; le soluzioni di cyber security nella gestione dell'ACDat sono tra i criteri premiali valutabili

## Workflow

1. Acquisisci architettura CDE (on-premise/cloud, provider, configurazione, localizzazione dei server)
2. Verifica checklist operativa (con controllo ISO 27001:2022 Annex A di riferimento):

| Area | Controllo | Rif. Annex A | Cosa verificare |
|------|-----------|--------------|-------------------|
| Autenticazione | Secure authentication | A.8.5 | MFA attiva per tutti gli utenti, SSO se disponibile, policy password |
| Autorizzazione | Access control / Privileged access rights | A.5.15, A.8.2 | RBAC, least privilege, revoca accessi tempestiva a fine incarico |
| Restrizione accesso | Information access restriction | A.8.3 | Accesso ai container limitato per ruolo/disciplina/area (need-to-know) |
| Crittografia | Use of cryptography | A.8.24 | Cifratura at rest e in transit (TLS), gestione chiavi |
| Backup | Information backup | A.8.13 | Frequenza, test di ripristino periodici, backup offsite/immutabili |
| Log e audit | Logging / Monitoring activities | A.8.15, A.8.16 | Log di accesso e transizione stato container, protezione dei log da alterazione, retention del log |
| Continuita operativa | ICT readiness for business continuity | A.5.30 | Piano di disaster recovery testato, RTO/RPO definiti |
| Cancellazione dati | Information deletion | A.8.10 | Procedura di cancellazione sicura a fine retention/contratto |
| Fornitori/terze parti | Supplier relationships | A.5.19-A.5.22 | Clausole di sicurezza nei contratti con il provider CDE, subfornitori inclusi |
| Conformita | Compliance with legal/contractual requirements | A.5.31 | Localizzazione dati conforme a GDPR (server in UE o garanzie equivalenti, es. SCC) |

3. Verifica conformita GDPR specifica:
   - Base giuridica del trattamento e informativa agli utenti del CDE (art. 5.1.a)
   - Minimizzazione: solo i dati personali necessari (nominativi, ruoli) sono presenti nei metadati dei container (art. 5.1.c)
   - Misure tecniche/organizzative documentate fin dalla configurazione del CDE, non aggiunte a posteriori (art. 25.1)
   - Configurazione di default restrittiva: nuovi utenti/aree partono con permessi minimi, non "tutti possono tutto" (art. 25.2)
   - Cifratura e controllo accessi documentati come misure ex art. 32; registro dei test di efficacia periodici (art. 32.1.d)
   - Registro dei trattamenti e DPIA se il CDE tratta dati che possono comportare rischio elevato (es. dati di cantiere con immagini di persone, dati di sicurezza fisica)
4. Applica ISO 19650-5 quando il progetto tratta informazioni sensibili (infrastrutture critiche, sicurezza fisica, dati riservati del committente):
   - Esegui il security triage process per stabilire se serve un approccio security-minded
   - Se si, richiedi la sensitivity assessment e la produzione di security strategy e security management plan da parte del team di progetto
5. Genera report con: conformita (per controllo Annex A e per articolo GDPR), rischi, raccomandazioni prioritizzate

### Esempio matrice permessi orientata alla sicurezza (ruolo x area x azione)

R = lettura, W = scrittura, A = amministrazione (gestione permessi/utenti)

| Ruolo | WIP | Shared | Published | Archived | Log/Audit |
|-------|-----|--------|-----------|----------|-----------|
| Task Team (disciplina) | R/W propria area | R | R | R | — |
| Information Manager | R (tutte le discipline) | R/W | R/W | R | R |
| CDE Administrator | A (gestione permessi) | A | A | A | R/W |
| Security/DPO Officer | — | — | — | — | R (sola lettura, nessuna scrittura sui contenuti) |
| Fornitore esterno/consulente | R su invito, area assegnata | R su invito | R su invito | — | — |

Principio guida: segregazione dei compiti (chi amministra i permessi non pubblica contenuti; chi verifica i log non modifica i container) e need-to-know per ogni ruolo esterno.

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| MFA solo per amministratori | MFA obbligatoria per tutti gli utenti con accesso a dati sensibili (A.8.5) |
| Log non protetti da modifica | I log di audit devono essere append-only o su sistema separato (A.8.15) |
| Backup mai testati | Test di ripristino periodico documentato, non solo backup schedulato (A.8.13) |
| "Privacy by design" citata ma non documentata | Documentare le misure tecniche/organizzative adottate in fase di progettazione del CDE, non solo dichiararle (art. 25 GDPR) |
| Permessi di amministrazione e di pubblicazione sullo stesso ruolo | Segregare: chi amministra gli accessi non deve poter pubblicare/approvare contenuti |
| Cifratura solo in transito, dati a riposo in chiaro | Cifratura at rest obbligatoria per dati sensibili/personali (A.8.24, art. 32 GDPR) |
| Nessuna verifica sulla localizzazione dei server del provider CDE | Verificare che i dati risiedano in UE o che siano in essere garanzie equivalenti (SCC) prima della firma del contratto |
| Applicare ISO 19650-5 a prescindere, su ogni progetto | Eseguire prima il security triage process: l'approccio va proporzionato al livello di sensibilita reale |
