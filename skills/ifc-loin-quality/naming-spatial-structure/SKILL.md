# Naming & Spatial Structure

Verifica nomenclatura file/oggetti e struttura spaziale IFC.

## Scope

- Controllo convenzione nomenclatura file e oggetti IFC
- Verifica struttura spaziale (IfcSite/IfcBuilding/IfcBuildingStorey)
- Allineamento a UNI 11337-5 e protocollo informativo di progetto
- Generazione report non conformita nomenclatura

## Normativa

- **UNI 11337-5** — Nomenclatura e codifica contenitori informativi
- **ISO 19650-2** — Information container naming convention
- **ISO 16739-1** — Struttura spaziale IFC

## Workflow

1. Acquisisci: modello IFC, convenzione nomenclatura dal CI/protocollo
2. Verifica nomenclatura file: pattern `[Prog]-[Disc]-[Zona]-[Tipo]-[Num]-[Rev]`
3. Verifica nomenclatura oggetti IFC: Name, Description non vuoti
4. Verifica struttura spaziale completa e coerente
5. Genera report con elenco non conformita e suggerimenti di correzione

## Relazioni spaziali IFC (schema)

La gerarchia spaziale non e implicita nell'ordine degli elementi nel file: e espressa da relazioni oggettificate esplicite che vanno verificate una per una.

```
IfcProject
  └─ IfcRelAggregates ─→ IfcSite
       └─ IfcRelAggregates ─→ IfcBuilding
            └─ IfcRelAggregates ─→ IfcBuildingStorey
                 └─ IfcRelAggregates ─→ IfcSpace (opzionale)
                 └─ IfcRelContainedInSpatialStructure ─→ [IfcWall, IfcDoor, IfcSlab, ...]
```

- **IfcRelAggregates**: decompone la struttura spaziale stessa (Project→Site→Building→Storey→Space). E' la stessa relazione usata anche per assembly/parti di un elemento, quindi va filtrata sul tipo di RelatingObject.
- **IfcRelContainedInSpatialStructure**: assegna gli elementi fisici (muri, porte, impianti) al loro contenitore spaziale (tipicamente l'IfcBuildingStorey, a volte l'IfcSpace).
- Un elemento "orfano" e un elemento che non compare come RelatedElement in nessuna IfcRelContainedInSpatialStructure.

Verifica con ifcopenshell (API verificata 0.7.x/0.8.x):

```python
import ifcopenshell
import ifcopenshell.util.element

model = ifcopenshell.open("modello.ifc")


def find_orphan_elements(model, element_types=("IfcWall", "IfcDoor", "IfcWindow", "IfcSlab")):
    """Elementi fisici privi di contenitore spaziale (IfcRelContainedInSpatialStructure)."""
    orphans = []
    for element_type in element_types:
        for element in model.by_type(element_type):
            container = ifcopenshell.util.element.get_container(element)
            if container is None:
                orphans.append(element)
    return orphans


def check_storeys(model):
    """Ogni IfcBuildingStorey deve avere un nome e un'elevazione definiti."""
    issues = []
    for storey in model.by_type("IfcBuildingStorey"):
        if not storey.Name or not storey.Name.strip():
            issues.append(("ALTA", f"IfcBuildingStorey senza nome (GUID {storey.GlobalId})"))
        if storey.Elevation is None:
            issues.append(("ALTA", f"Elevation mancante su piano '{storey.Name}'"))
    return issues


def list_storey_contents(model, storey):
    """Elenco degli elementi contenuti in un piano, inclusi quelli nidificati negli IfcSpace."""
    return ifcopenshell.util.element.get_decomposition(storey)
```

`get_container()` risale la gerarchia tramite `IfcRelContainedInSpatialStructure` (e, se assente, tramite `IfcRelAggregates`) restituendo il contenitore spaziale piu vicino; `get_decomposition()` fa il percorso inverso, elencando ricorsivamente tutto cio che e aggregato o contenuto in un elemento spaziale.

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Nomi generici ("Wall 001") | Nome descrittivo con codifica da protocollo |
| IfcBuildingStorey senza elevazione | SEMPRE definire Elevation |
| Elementi senza assegnazione spaziale | Ogni elemento deve appartenere a un piano |
| Navigare `IsDecomposedBy`/`ContainsElements` a mano con cicli annidati | Usare `ifcopenshell.util.element.get_container()` e `get_decomposition()`, che gestiscono i casi limite (elementi contenuti in IfcSpace, assembly nidificati) |
| Confondere `IfcRelAggregates` di struttura spaziale con quella di assembly di parti (es. un IfcElementAssembly) | Filtrare sempre sul tipo IFC del `RelatingObject` prima di interpretare la relazione come gerarchia di piani |
| Assumere che ogni progetto abbia un solo IfcBuilding o un solo IfcSite | Un modello federato puo avere piu IfcBuilding sotto lo stesso IfcSite (es. lotti multipli): verificare tutti, non solo il primo di `by_type()` |
