# Roadmap — prossima sessione

Prompt strutturato per continuare l'implementazione del repo `bim-skills` e per rendere le skill compatibili con Google Antigravity oltre che con Claude Code. Incollabile all'inizio di una nuova sessione Claude Code per riprendere il lavoro senza dover ri-derivare il contesto.

---

## Contesto

Repo: `github.com/VisionXt-tech/bim-skills` (pubblico, MIT). Libreria di skill e agenti AI per workflow BIM nel contesto normativo italiano (D.Lgs. 36/2023, Allegato I.9, UNI 11337, ISO 19650), progettata per Claude Code.

**Stato attuale (completo):**
- 26 skill in 7 famiglie (`skills/pa-appointing`, `delivery-team`, `cde-acdat`, `ifc-loin-quality`, `4d-5d-costs`, `asset-digital-twin`, `tools`)
- 6 agenti multi-skill (`agents/*.md`) con frontmatter YAML `model`/`tools`
- Contenuto normativo e tecnico verificato via ricerca (non generato a memoria): riferimenti UNI/ISO/D.Lgs. controllati, API Revit/Rhino/ifcopenshell verificate contro documentazione corrente, alcuni errori normativi trovati e corretti nel processo
- `docs/mcp-setup.md` con MCP server pubblici (Revit, IFC, Rhino, Blender) incluso il server ufficiale Autodesk (Tech Preview, solo Revit 2027)
- README con banner e social preview costruiti dal vero VisionXt Design System (letto via `/design-login` + tool DesignSync, progetto `0ccd0389-5130-4467-928c-164abb23abe1`)
- Installer PowerShell/bash che copiano `skills/` in `~/.claude/skills/bim/`

**Convenzioni stabilite (rispettare in ogni modifica):**
- Contenuti in italiano, codice/enum in inglese
- Ogni skill: Scope, NON fa, Normativa (con riferimenti verificati, mai inventati), Workflow, Anti-pattern (tabella `| Errore | Correzione |`), Output, Limiti
- Sezione "MCP Server consigliati (opzionali)" dove pertinente, mai un MCP come dipendenza obbligatoria
- Nomi directory kebab-case
- Non toccare `README.md`/`catalog.json` in task paralleli su file diversi (rischio di conflitto se piu agenti lavorano insieme)

---

## Obiettivo 1 — Compatibilita Antigravity (nuovo)

**Fatti verificati (antigravity.google/docs/skills, 2026-09):**
- Antigravity usa lo stesso standard SKILL.md di Claude Code — le skill non necessitano di riscrittura del contenuto
- Frontmatter YAML: `description` **obbligatorio**, `name` opzionale (default: nome cartella)
- Percorso workspace: `<root>/.agents/skills/<nome-skill>/SKILL.md` (default attuale; supporto legacy per `.agent/skills`)
- Percorso globale: `~/.gemini/config/skills/<nome-skill>/`
- Nessun campo `turbo_safe` confermato nella documentazione ufficiale (una fonte secondaria lo citava, ma non e nella doc ufficiale — non usarlo senza riverifica)

**Gap da colmare (importante: riguarda anche Claude Code, non solo Antigravity):**
Le 26 skill attuali **non hanno frontmatter YAML** — iniziano direttamente con `# Titolo`. Senza `description` in frontmatter, ne Antigravity ne la discovery automatica di Claude Code (`/nome-skill`, listing "available skills") possono indicizzarle correttamente: probabilmente vengono lette come contesto ma non compaiono come skill invocabili a comando.

**Task:**
1. Aggiungere frontmatter YAML a tutti i 26 `SKILL.md` (name kebab-case, description one-line che riassume trigger/scope — stile simile agli esempi di skill in questo stesso ambiente)
2. Decidere la struttura repo: o (a) un'unica cartella `skills/` con frontmatter compatibile con entrambi i tool, installata da script diversi in `.claude/skills/` vs `.agents/skills/`, oppure (b) mantenere `skills/` come sorgente unica e generare/copiare durante l'installazione — **preferire (a)**, single source of truth, per non duplicare 26 file
3. Nuovo script `scripts/install-antigravity.ps1` / `.sh` (o flag `-target antigravity|claude|both` sugli script esistenti) che copia in `.agents/skills/` del progetto invece che in `~/.claude/skills/`
4. Verificare se gli agenti (`agents/*.md`, frontmatter `model`/`tools`) hanno un equivalente Antigravity (Antigravity ha un proprio concetto di agent/workflow? verificare prima di assumere compatibilita 1:1 — non e detto che il frontmatter `model`/`tools` di Claude Code funzioni li)
5. Aggiornare `README.md` con sezione "Installazione per Antigravity" e `catalog.json` con un campo di compatibilita (es. `"compatibleWith": ["claude-code", "antigravity"]`)
6. Aggiornare `CONTRIBUTING.md`: chi contribuisce una nuova skill deve includere il frontmatter da subito

**Nota**: verificare PRIMA di scrivere codice se nel frattempo (tra ora e la ripresa) la documentazione Antigravity e cambiata — e un prodotto 2026 in evoluzione attiva, non fidarsi ciecamente di questa nota se sono passate settimane.

---

## Obiettivo 2 — Igiene e maturita del repo (continuazione)

Task non urgenti ma naturali per un repo open-source che cresce:

1. **CI minima** (`.github/workflows/validate.yml`): verifica che ogni path in `catalog.json` esista davvero, che ogni `SKILL.md` abbia le sezioni obbligatorie del template, niente link rotti nel README (`markdown-link-check` o simile) — coerente con la regola ponytail "lazy code without its check is unfinished"
2. **Frontmatter anche per gli agenti**: verificare che i 6 file in `agents/*.md` abbiano frontmatter completo e coerente tra loro (gia fatto per la maggior parte, controllare gli ultimi due non ancora verificati in dettaglio: `asset-manager.md`, `quality-gate.md`)
3. **catalog.json**: aggiungere i 6 agenti (oggi ha solo le skill) per farne un indice machine-readable completo
4. **Versioning**: `catalog.json` ha `"version": "0.1.0"` statico — decidere una policy (SemVer per release del repo, non delle singole skill) prima che diventi debito
5. Il punto 3 della roadmap originale (form di registrazione su visionxt.tech/bim-skills) resta fuori scope finche l'utente non lo definisce — non implementare di iniziativa

---

## Vincoli da rispettare sempre

- **Mai inventare** riferimenti normativi, nomi di classi/API, o campi di frontmatter non verificati — cercare prima
- Se un task tocca >3 file con ricerca web necessaria per ciascuno, valutare la delega a sub-agenti paralleli (pattern gia usato con successo per l'arricchimento delle 26 skill)
- Ogni modifica a skill/agenti esistenti: leggere il file intero prima di editare (i file cambiano tra sessioni)
- Commit con messaggio descrittivo, push solo dopo verifica locale (nessun file temporaneo tipo `_tmp.html` finito nel commit)

---

## Come riprendere

Incolla questo file (o il suo contenuto) come primo messaggio di una nuova sessione, poi specifica quale Obiettivo affrontare per primo (consigliato: Obiettivo 1, e il gap piu concreto e con impatto anche su Claude Code stesso).
