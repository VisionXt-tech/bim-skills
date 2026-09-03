# BIM Skills Italia — Agent Guidelines

Libreria open-source di skill e agenti AI per workflow BIM conformi al quadro normativo italiano.
Questo file definisce le convenzioni e i vincoli operativi per tutti gli agenti AI (Claude Code, Google Antigravity, Cursor).

---

## 1. Quadro Normativo di Riferimento

Gli agenti devono sempre attenersi al testo vigente della normativa italiana ed europea:

1. **D.Lgs. 36/2023** (Codice dei contratti pubblici):
   - Art. 43 (Metodi e strumenti di gestione informativa digitale delle costruzioni)
   - Allegato I.9 (Metodi e strumenti digitali, requisiti stazione appaltante, CI, oGI, pGI, ACDat)
   - D.Lgs. 209/2024 (Decreto correttivo — soglie di obbligatorietà dal 01/01/2025)
2. **UNI 11337** (Gestione digitale dei processi informativi delle costruzioni):
   - Parte 1: Concetti, principi e requisiti generali
   - Parte 4: Evoluzione e sviluppo informativo (LOIN / LoG / LoI)
   - Parte 5: Flussi informativi (CI, oGI, pGI, ACDat)
   - Parte 7: Profili professionali (BIM Manager, BIM Coordinator, BIM Specialist, CDE Manager)
3. **UNI/PdR 78:2020**: Requisiti di certificazione per le figure professionali BIM
4. **UNI EN ISO 19650** (Serie 1-5):
   - Parte 1: Concetti e principi
   - Parte 2: Fase di consegna dei cespiti immobili (delivery team)
   - Parte 3: Fase gestionale dei cespiti immobili (AIM, operation & maintenance)
   - Parte 5: Approccio alla gestione della sicurezza delle informazioni
5. **UNI EN 17412-1**: Level of Information Need (LOIN)
6. **ISO 16739-1**: Industry Foundation Classes (IFC4 / IFC2x3)

---

## 2. Regole di Rigore Operativo (Anti-Allucinazione)

- **Nessuna norma inventata:** Non inventare mai commi, articoli o schemi IFC inesistenti. Citare solo riferimenti normativi verificabili.
- **Lingua:** I contenuti normativi, procedurali e le spiegazioni sono in **italiano**. Il codice sorgente (C#, Python, C++), i nomi di classi/metodi e i termini tecnici software restano in **inglese**.
- **Limiti espliciti:** Indicare sempre dove si ferma il supporto dell'AI e dove interviene la responsabilità legale e contrattuale del professionista abilitato (timbro, firma, perizia).

---

## 3. Struttura delle Skill e Progressive Disclosure

Tutte le skill in `skills/` seguono lo standard aperto `SKILL.md`:
- **Frontmatter YAML:** Deve includere obbligatoriamente `name` (kebab-case) e `description` (3a persona con trigger espliciti).
- **Sezioni standard:**
  - `Scope` (cosa fa)
  - `NON fa` (limiti e confini espliciti)
  - `Normativa di riferimento` (articoli e norme pertinenti)
  - `Workflow` (fasi operative deterministiche)
  - `Anti-pattern` (tabella con errore tipico e relativa correzione)
  - `Output` (struttura attesa)
  - `Limiti` (avvertenze deontologiche e tecniche)

---

## 4. Agenti Multi-Skill Disponibili

| Agente | File | Ruolo Target | Competenze |
| :--- | :--- | :--- | :--- |
| **BIM Gara** | `agents/bim-gara.md` | BIM Manager SA, RUP | CI drafting, valutazione oGI, consolidamento pGI |
| **BIM Delivery Team** | `agents/bim-delivery-team.md` | Lead Appointed Party | BEP, MIDP/TIDP, protocollo informativo |
| **BIM Quality Gate** | `agents/bim-quality-gate.md` | BIM Coordinator | Validazione LOIN/pset, naming, spatial structure, clash |
| **BIM CDE Manager** | `agents/bim-cde-manager.md` | CDE Manager | Configurazione ACDat, workflow/stati, sicurezza/GDPR |
| **BIM Asset Manager** | `agents/bim-asset-manager.md` | Facility Manager | Costruzione AIM, CMMS/CAFM, digital twin IoT |
| **BIM Revit Dev** | `agents/bim-revit-dev.md` | BIM Specialist, Dev | Revit API (C#), pyRevit, Dynamo, C++ bridge |

---

## 5. Compatibilità Ecosistemi

Gli script in `scripts/install.ps1` e `scripts/install.sh` consentono di installare la libreria per:
- **Claude Code:** in `~/.claude/skills/` e `~/.claude/agents/`
- **Google Antigravity:** in `~/.gemini/config/skills/` (o `.agents/skills/`)
- **Cursor:** in `~/.cursor/skills/` (o `.cursor/skills/`)
