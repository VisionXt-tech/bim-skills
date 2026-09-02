# Setup MCP Servers per BIM Skills

Gli agenti funzionano con i tool built-in di Claude Code (Read, Write, Bash, etc.). Per sbloccare funzionalita avanzate — interazione live con Revit, validazione IFC, modellazione Rhino — puoi installare MCP server pubblici opzionali.

## MCP Server per categoria

---

### Revit (interazione live con il modello)

#### Autodesk Revit MCP Server (ufficiale — consigliato dove disponibile)
Server MCP **ufficiale Autodesk**, integrato nell'Autodesk Assistant dentro Revit. Piu affidabile delle alternative community perche mantenuto direttamente da Autodesk, ma attualmente in **Tech Preview** e disponibile **solo per Revit 2027**.

Capacita verificate: interrogazione e reporting del modello, ricerca elementi, controllo parametri e conteggi, editing bulk di parametri, acquisizione snapshot visivi delle viste.

- **Documentazione**: [Revit Public MCP Server (Tech Preview)](https://help.autodesk.com/cloudhelp/2027/ENU/Revit-WhatsNew/files/GUID-97697CBF-0E11-484E-96E5-4277E3E8D61F.htm) — setup dettagliato: [ADSKMCP setup guide](https://help.autodesk.com/view/ADSKMCP/ENU/?guid=ADSKMCP_RevitMcp_setting_up_revit_mcp_server_html)
- **Requisiti**: Revit 2027, accesso all'Autodesk Assistant. La pagina di setup non specifica sistema operativo/hardware oltre ai requisiti standard di Revit 2027
- **Stato**: Tech Preview — funzionalita e disponibilita possono cambiare; non usarlo per workflow di produzione critici finche non esce dalla fase preview
- **Limiti per questo repo**: essendo integrato nell'Autodesk Assistant (non un server MCP esterno con config JSON standard come `claude_desktop_config.json`), l'attivazione segue il flusso Autodesk, non la configurazione `mcpServers` di Claude Code — verificare la guida ufficiale per i passaggi correnti
- **Usato da**: agenti `revit-dev`, `quality-gate` (quando disponibile su Revit 2027; per versioni precedenti vedi le alternative community sotto)

Per Revit 2023-2026, dove il server ufficiale non e ancora disponibile, usa una delle alternative community verificate:

#### RevitCortex (alternativa community, Revit 2023-2027)
173 tool, C# puro. IFC reconstruction, Power BI integration.

```json
// claude_desktop_config.json o .claude/settings.json
{
  "mcpServers": {
    "revit-cortex": {
      "command": "dotnet",
      "args": ["run", "--project", "path/to/RevitCortex"]
    }
  }
}
```

- **Repo**: https://github.com/LuDattilo/RevitCortex
- **Requisiti**: Revit 2023+, .NET 8 SDK
- **Usato da**: agenti `revit-dev`, `quality-gate`

#### Demolinator Revit MCP (alternativa via pyRevit)
48 tool via pyRevit. Piu leggero, buona copertura base.

```json
{
  "mcpServers": {
    "revit-mcp": {
      "command": "npx",
      "args": ["-y", "@anthropic/revit-mcp-server"]
    }
  }
}
```

- **Repo**: https://github.com/Demolinator/revit-mcp-server
- **Requisiti**: Revit 2024+, pyRevit, Node.js 18+
- **Usato da**: agente `revit-dev`

#### UV-Tech Revit Claude MCP (bridge minimale)
Bridge open-source leggero per Claude.

- **Repo**: https://github.com/UV-Tech/revit-claude-mcp
- **Requisiti**: Revit 2026+

---

### IFC / OpenBIM (validazione modelli)

#### ifcMCP (consigliato)
LLM parla direttamente con file IFC via ifcopenshell e FastMCP.

```bash
pip install ifcmcp
```

```json
{
  "mcpServers": {
    "ifcmcp": {
      "command": "python",
      "args": ["-m", "ifcmcp"]
    }
  }
}
```

- **Repo**: https://github.com/smartaec/ifcmcp
- **Requisiti**: Python 3.10+, ifcopenshell
- **Usato da**: agenti `quality-gate`, `asset-manager`

#### IFC-MCP (Flinker)
Ispezione IFC, creazione report, viewer, BCF viewpoints. Runtime Pyodide locale.

```json
{
  "mcpServers": {
    "ifc-mcp": {
      "command": "npx",
      "args": ["-y", "ifc-mcp"]
    }
  }
}
```

- **Repo**: https://github.com/flinker-app/ifc-mcp
- **Requisiti**: Node.js 18+
- **Usato da**: agenti `quality-gate`, `asset-manager`

#### Bonsai MCP (IFC via Blender/Bonsai)
11 tool IFC tramite Bonsai BIM (addon Blender). Utile se usi gia Blender per openBIM.

- **Repo**: https://github.com/JotaDeRodriguez/Bonsai_mcp
- **Requisiti**: Blender 4.x, Bonsai BIM addon

---

### Rhino / Grasshopper (modellazione 3D parametrica)

#### RhinoMCP (consigliato)
Connette Rhino + Grasshopper a Claude. Modellazione, lettura documenti, definizioni GH.

```bash
pip install rhinomcp
```

```json
{
  "mcpServers": {
    "rhinomcp": {
      "command": "python",
      "args": ["-m", "rhinomcp"]
    }
  }
}
```

- **Repo**: https://github.com/jingcheng-chen/rhinomcp
- **Requisiti**: Rhino 7/8, Python 3.10+
- **Usato da**: agenti `revit-dev` (per workflow Rhino.Inside.Revit)

#### GH MCP Server (alternativa con focus Grasshopper)
Interazione diretta con Rhino e Grasshopper, generazione GHPython automatica.

- **Repo**: https://github.com/veoery/GH_mcp_server
- **Requisiti**: Rhino 7/8, Grasshopper

#### AI-Architecture (Rhino + GH unificato)
Server MCP unificato Rhino + Grasshopper per design parametrico AI-driven.

- **Repo**: https://github.com/Xiaohu1009/AI-architecture
- **Requisiti**: Rhino 8+

---

### Blender (visualizzazione e openBIM)

#### Blender MCP Ufficiale (consigliato)
Server MCP ufficiale di Blender Lab.

- **Sito**: https://www.blender.org/lab/mcp-server/
- **Requisiti**: Blender 4.x

#### Blender MCP Community
Plugin community per controllare Blender da qualsiasi LLM.

```bash
pip install blender-mcp
```

- **Repo**: https://github.com/ahujasid/blender-mcp
- **Requisiti**: Blender 4.0+, Python 3.10+

---

### Autodesk Platform Services (cloud AEC)

#### APS MCP Server (ufficiale Autodesk)
Accesso alle API Autodesk Platform Services (ex Forge). Modelli cloud, viewer, data management.

```json
{
  "mcpServers": {
    "aps": {
      "command": "npx",
      "args": ["-y", "@anthropic/aps-mcp-server"],
      "env": {
        "APS_CLIENT_ID": "your-client-id",
        "APS_CLIENT_SECRET": "your-client-secret"
      }
    }
  }
}
```

- **Repo**: https://github.com/autodesk-platform-services/aps-mcp-server-nodejs
- **Requisiti**: Node.js 18+, account APS con credenziali

---

## Configurazione in Claude Code

### Globale (per tutti i progetti)

Aggiungi i server MCP in `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "ifcmcp": { "command": "python", "args": ["-m", "ifcmcp"] },
    "rhinomcp": { "command": "python", "args": ["-m", "rhinomcp"] }
  }
}
```

### Per progetto

Aggiungi in `.claude/settings.json` nella root del progetto:

```json
{
  "mcpServers": {
    "revit-cortex": {
      "command": "dotnet",
      "args": ["run", "--project", "./tools/RevitCortex"]
    }
  }
}
```

## Setup minimo consigliato

| Ruolo | MCP consigliati |
|-------|----------------|
| BIM Manager (gara/CI) | Nessuno (solo tool built-in) |
| BIM Coordinator (qualita IFC) | ifcMCP o IFC-MCP |
| CDE Manager | Nessuno (solo tool built-in) |
| Sviluppatore Revit | RevitCortex + ifcMCP |
| Sviluppatore Rhino/GH | RhinoMCP |
| Facility Manager | ifcMCP |
