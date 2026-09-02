# Contributing

Contributi benvenuti da professionisti BIM, sviluppatori e esperti di normativa italiana.

## Come contribuire

1. **Fork** del repository
2. **Crea un branch**: `git checkout -b skill/nome-skill`
3. **Scrivi la skill** seguendo il template in `docs/SKILL_TEMPLATE.md`
4. **Testa** la skill in Claude Code (copia in `~/.claude/skills/` e verifica che funzioni)
5. **Apri una PR** con:
   - Descrizione dello scope della skill
   - Normativa di riferimento coperta
   - Esempio d'uso testato

## Struttura di una skill

Ogni skill e un file `SKILL.md` nella directory appropriata:

```
skills/
├── [famiglia]/
│   └── [nome-skill]/
│       └── SKILL.md
```

### Famiglie disponibili

| Directory | Famiglia |
|-----------|---------|
| `pa-appointing/` | Committente / Appointing Party |
| `delivery-team/` | Team di progetto / Lead Appointed Party |
| `cde-acdat/` | CDE Manager / ACDat |
| `ifc-loin-quality/` | Modelli IFC, LOIN, qualita |
| `4d-5d-costs/` | 4D/5D, costi, tracciabilita |
| `asset-digital-twin/` | Asset Management e Digital Twin |
| `tools/` | Piattaforme e strumenti (Revit, Rhino, pyRevit...) |

## Requisiti per una buona skill

- **Scope chiaro**: cosa fa e cosa NON fa
- **Normativa**: riferimenti precisi (articolo, comma) — niente riferimenti generici
- **Workflow deterministico**: passi concreti, non consigli vaghi
- **Anti-pattern**: errori comuni con correzione — questo e il vero valore
- **Limiti onesti**: dove la skill si ferma e il professionista prende il controllo
- **Niente allucinazioni**: se una norma non esiste, non inventarla

## Stile

- Italiano per contenuti normativi e descrizioni
- Inglese per codice e commenti tecnici
- Niente emoji nei file SKILL.md
- Niente formattazione eccessiva — il contenuto conta piu della presentazione

## Review

Ogni PR viene verificata per:
- Correttezza normativa (riferimenti reali e aggiornati)
- Completezza del template (tutte le sezioni presenti)
- Funzionamento in Claude Code
- Nessuna sovrapposizione con skill esistenti

## Segnalazioni

Per errori normativi, bug o richieste di nuove skill: apri una Issue con label appropriata.
