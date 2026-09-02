# BIM Skills Italia

**Skill e agenti AI per workflow BIM italiani — pronti per Claude Code.**

Una raccolta open-source di skill specializzate per professionisti BIM che operano nel contesto normativo italiano (D.Lgs. 36/2023, UNI 11337, ISO 19650). Ogni skill trasforma l'AI assistant in un collaboratore esperto di procedure, normative e strumenti BIM.

> Progetto di [VisionXt](https://visionxt.it) — aperto a contributi della community AEC italiana.

---

## Quick Start

### Installazione completa (tutte le skill)

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.ps1 | iex
```

**macOS / Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/VisionXt-tech/bim-skills/main/scripts/install.sh | bash
```

### Installazione singola skill

Clona il repo e copia solo la skill che ti serve:

```bash
git clone https://github.com/VisionXt-tech/bim-skills.git
cp -r bim-skills/skills/ifc-loin-quality/ifc-loin-validator ~/.claude/skills/bim/ifc-loin-validator
```

### Verifica

In Claude Code, digita `/` e cerca le skill BIM installate. Ogni skill ha il suo slash command.

---

## Catalogo Skill

### Workflow Normativi

Skill basate su D.Lgs. 36/2023, Allegato I.9, UNI 11337 e ISO 19650.

| Famiglia | Skill | Ruolo Target | Descrizione |
|----------|-------|-------------|-------------|
| **PA / Committente** | `ci-drafting` | BIM Manager (SA) | Redazione Capitolato Informativo conforme ad Allegato I.9 |
| | `ogi-evaluation` | Commissione | Valutazione Offerte di Gestione Informativa |
| | `pgi-consolidation` | BIM Manager | Trasformazione oGI in Piano di Gestione Informativa |
| **Delivery Team** | `bim-execution` | Lead Appointed Party | Redazione BEP e piani di mobilizzazione |
| | `information-delivery-planning` | BIM Manager | Costruzione MIDP/TIDP e milestone informative |
| | `information-protocol` | BIM Coordinator | Protocollo informativo ISO 19650 |
| **CDE / ACDat** | `cde-configuration` | CDE Manager | Configurazione ambiente di condivisione dati |
| | `cde-workflow` | CDE Manager | Analisi flussi e stati dei container informativi |
| | `cde-cybersecurity` | CDE Manager | Verifica sicurezza e compliance GDPR/ISO 27001 |
| **Modelli IFC** | `ifc-loin-validator` | BIM Coordinator | Validazione LOIN su modelli IFC (LoG/LoI/pset) |
| | `naming-spatial-structure` | BIM Coordinator | Verifica nomenclatura e struttura spaziale IFC |
| | `clash-detection` | BIM Coordinator | Gestione clash e issue tracking |
| | `normative-code-checking` | BIM Specialist | Controlli parametrici normativi su modelli |
| **4D/5D** | `construction-sequencing` | BIM Specialist | Collegamento modelli IFC con cronoprogrammi (4D) |
| | `quantities-cost-linking` | Cost Planner | Estrazione quantitativi e viste 5D |
| | `materials-traceability` | BIM Specialist | Tracciabilita materiali e sostenibilita |
| **Asset / Digital Twin** | `aim-construction` | Facility Manager | Costruzione Asset Information Model |
| | `maintenance-cmms` | Facility Manager | Integrazione AIM con sistemi CMMS/CAFM |
| | `digital-twin-analytics` | BIM Manager Asset | Analytics IoT e performance energetiche |

### Strumenti e Piattaforme

Skill per sviluppo e automazione con i principali tool BIM.

| Skill | Piattaforma | Cosa fa |
|-------|------------|---------|
| `revit-api` | Revit API (C#) | Sviluppo add-in Revit: transazioni, filtri, famiglie, viste, export |
| `revit-dynamo` | Dynamo for Revit | Script Dynamo: nodi Python, DesignScript, package, data flow |
| `revit-cpp-plugin` | Revit C++ | Plugin nativi C++: IExternalCommand, ribbon, performance-critical ops |
| `rhino` | Rhinoceros | Scripting RhinoCommon, comandi, geometria NURBS |
| `rhino-inside-revit` | Rhino.Inside.Revit | Interop Rhino-Revit: geometria complessa in contesto BIM |
| `grasshopper` | Grasshopper | Definizioni parametriche, componenti custom, data tree |
| `pyrevit` | pyRevit | Estensioni pyRevit: script, UI, hook, engine CPython 3 |

---

## Come Funzionano

Ogni skill e un file `SKILL.md` che istruisce Claude Code su:

1. **Scope** — cosa fa e cosa NON fa
2. **Normativa di riferimento** — norme e articoli specifici
3. **Workflow passo-passo** — procedure deterministiche
4. **Anti-pattern** — errori comuni da evitare
5. **Output atteso** — formato e struttura dei deliverable
6. **Strumenti MCP** — integrazione con tool esterni (ifcopenshell, CDE API, Revit MCP)

Le skill NON sostituiscono il professionista. Supportano il lavoro riducendo errori, accelerando la redazione documentale e automatizzando verifiche ripetitive.

---

## Struttura del Repository

```
bim-skills/
├── skills/
│   ├── pa-appointing/          # Famiglia 1: Committente / Appointing Party
│   ├── delivery-team/          # Famiglia 2: Team di progetto / Lead Appointed Party
│   ├── cde-acdat/              # Famiglia 3: CDE Manager / ACDat
│   ├── ifc-loin-quality/       # Famiglia 4: Modelli IFC, LOIN, qualita
│   ├── 4d-5d-costs/            # Famiglia 5: 4D/5D, costi, tracciabilita
│   ├── asset-digital-twin/     # Famiglia 6: Asset Management e Digital Twin
│   └── tools/                  # Skill per piattaforme (Revit, Rhino, pyRevit...)
├── agents/                     # Definizioni agenti multi-skill
├── scripts/                    # Installer
├── docs/                       # Documentazione architetturale
└── catalog.json                # Indice machine-readable
```

---

## Agenti

Agenti multi-skill che combinano piu competenze per workflow end-to-end. Copia in `.claude/agents/` del tuo progetto.

| Agente | Cosa fa | Ruolo target |
|--------|---------|-------------|
| [`gara-bim`](agents/gara-bim.md) | Ciclo gara completo: CI, valutazione oGI, consolidamento pGI | BIM Manager SA, RUP |
| [`delivery-team`](agents/delivery-team.md) | BEP, MIDP/TIDP, protocollo informativo | Lead Appointed Party |
| [`quality-gate`](agents/quality-gate.md) | Verifica LOIN, nomenclatura, struttura spaziale, clash | BIM Coordinator |
| [`cde-manager`](agents/cde-manager.md) | Setup ACDat, governance flussi, audit sicurezza | CDE Manager |
| [`asset-manager`](agents/asset-manager.md) | AIM, piani manutentivi, CMMS, analytics IoT | Facility Manager |
| [`revit-dev`](agents/revit-dev.md) | Sviluppo Revit: sceglie tra pyRevit/C#/Dynamo/C++/Rhino.Inside | Developer |

---

## MCP Server (opzionali)

Gli agenti funzionano con i tool built-in di Claude Code. Per interazione live con Revit, validazione IFC diretta, o modellazione Rhino, installa MCP server pubblici:

| Server | Cosa fa | Link |
|--------|---------|------|
| **Autodesk Revit MCP Server** (ufficiale) | Query/report modello, editing bulk parametri, snapshot viste — solo Revit 2027, Tech Preview | [Guida ufficiale](https://help.autodesk.com/view/ADSKMCP/ENU/?guid=ADSKMCP_RevitMcp_setting_up_revit_mcp_server_html) |
| **RevitCortex** | 173 tool per Revit 2023-2027 (alternativa community) | [GitHub](https://github.com/LuDattilo/RevitCortex) |
| **ifcMCP** | Query su file IFC via ifcopenshell | [GitHub](https://github.com/smartaec/ifcmcp) |
| **IFC-MCP** | Ispezione IFC, report, BCF viewpoints | [GitHub](https://github.com/flinker-app/ifc-mcp) |
| **RhinoMCP** | Rhino + Grasshopper da Claude | [GitHub](https://github.com/jingcheng-chen/rhinomcp) |
| **Blender MCP** | Blender ufficiale MCP | [Blender Lab](https://www.blender.org/lab/mcp-server/) |
| **APS MCP** | Autodesk Platform Services cloud | [GitHub](https://github.com/autodesk-platform-services/aps-mcp-server-nodejs) |

Vedi **[docs/mcp-setup.md](docs/mcp-setup.md)** per istruzioni di installazione e configurazione dettagliate.

---

## Contribuire

Vedi [CONTRIBUTING.md](CONTRIBUTING.md) per le linee guida.

In breve:
1. Fork del repo
2. Crea la skill seguendo il template in `docs/SKILL_TEMPLATE.md`
3. Testa la skill in Claude Code
4. Apri una PR con descrizione di scope e normativa coperta

Cerchiamo contributi da: BIM Manager, BIM Coordinator, CDE Manager, sviluppatori Revit/Rhino/Dynamo, esperti di normativa italiana BIM.

---

## Accesso e Registrazione

Per accedere alla suite completa, aggiornamenti prioritari e supporto:

**[Registrati su visionxt.it/bim-skills](https://visionxt.it/bim-skills)**

La registrazione e gratuita e ti da accesso a:
- Notifiche su nuove skill e aggiornamenti
- Canale community per discussioni e supporto
- Accesso anticipato a skill premium e integrazioni MCP avanzate

---

## Normativa di Riferimento

- **D.Lgs. 36/2023** — Codice dei Contratti Pubblici
- **Allegato I.9** — Metodi e strumenti di gestione informativa digitale
- **D.Lgs. 209/2024** — Correttivo, soglia 2M EUR dal 01/01/2025
- **UNI 11337** (parti 1-7) — Gestione digitale dei processi informativi
- **UNI/PdR 78:2020** — Certificazione professionisti BIM
- **ISO 19650** (parti 1-3) — Information management using BIM
- **ISO 16739-1** — Industry Foundation Classes (IFC)

---

## Licenza

MIT — vedi [LICENSE](LICENSE).

---

*Costruito da professionisti BIM, per professionisti BIM.*
