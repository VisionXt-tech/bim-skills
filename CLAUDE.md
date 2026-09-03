# BIM Skills Italia

Repository di skill e agenti AI per workflow BIM nel contesto normativo italiano.

## Struttura

- `skills/` — skill organizzate per famiglia (pa-appointing, delivery-team, cde-acdat, ifc-loin-quality, 4d-5d-costs, asset-digital-twin, bim-tools)
- `agents/` — definizioni agenti multi-skill
- `scripts/` — installer (install.ps1, install.sh)
- `docs/` — template e documentazione

## Convenzioni

- Ogni skill e un `SKILL.md` dentro la sua directory con frontmatter YAML (name e description obbligatori)
- Nomi directory in kebab-case
- Contenuti in italiano, codice in inglese
- Nessuna dipendenza esterna nelle skill (solo istruzioni testuali)
- Riferimenti normativi con articolo/comma specifico

## Normativa principale

- D.Lgs. 36/2023 + Allegato I.9
- D.Lgs. 209/2024 (correttivo)
- UNI 11337 (parti 1-7)
- UNI/PdR 78:2020
- ISO 19650 (parti 1-3)
- ISO 16739-1 (IFC)
