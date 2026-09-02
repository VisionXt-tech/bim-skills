# Agenti BIM

Agenti multi-skill per workflow BIM end-to-end. Ogni agente combina piu skill per gestire un processo completo.

## Installazione

Copia gli agenti nella directory `.claude/agents/` del tuo progetto:

```bash
cp agents/*.md /path/to/progetto/.claude/agents/
```

## Agenti disponibili

| Agente | File | Skill combinate | Ruolo target |
|--------|------|----------------|-------------|
| **Gara BIM** | `gara-bim.md` | ci-drafting, ogi-evaluation, pgi-consolidation | BIM Manager SA, RUP |
| **Delivery Team** | `delivery-team.md` | bim-execution, info-delivery-planning, info-protocol | Lead Appointed Party |
| **Quality Gate** | `quality-gate.md` | ifc-loin-validator, naming-spatial, clash-detection | BIM Coordinator, CDE Manager |
| **CDE Manager** | `cde-manager.md` | cde-configuration, cde-workflow, cde-cybersecurity | CDE Manager |
| **Asset Manager** | `asset-manager.md` | aim-construction, maintenance-cmms, digital-twin-analytics | Facility Manager |
| **Revit Developer** | `revit-dev.md` | revit-api, pyrevit, revit-dynamo, revit-cpp-plugin | BIM Specialist, Developer |

## Uso

In Claude Code, usa l'Agent tool specificando il tipo:

```
Usa l'agente gara-bim per redigere il CI di questo appalto.
```

Oppure, se installati in `.claude/agents/`, sono disponibili come agent type nel tool Agent.
