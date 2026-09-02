# Clash Detection & Issue Management

Gestione clash detection e issue tracking per coordinamento BIM.

## Scope

- Analisi report clash da software dedicati (Navisworks, BIMcollab, Solibri)
- Aggregazione, categorizzazione e prioritizzazione clash
- Assegnazione ticket e tracking risoluzione
- Report di stato per riunioni di coordinamento
- Verifica chiusura issue in linea con procedure BIM

## NON fa

- Non esegue clash detection direttamente (richiede software specializzato)
- Non modifica modelli per risolvere clash
- Non sostituisce il coordinamento BIM meeting

## Workflow

1. Acquisisci report clash (BCF, HTML, CSV da Navisworks/Solibri)
2. Categorizza: hard clash, soft clash, clearance violation
3. Aggrega: raggruppa clash simili per ridurre rumore
4. Prioritizza: critica (strutturale), alta (impiantistica), media, bassa
5. Assegna: disciplina e responsabile per ogni gruppo
6. Genera report coordinamento con stato, trend, azioni

## Formato BCF

Preferire BCF (BIM Collaboration Format) per interoperabilita — specifica ufficiale buildingSMART (`BCF-XML`), versioni correnti 2.1 e 3.0. Integrabile con BIMcollab, Solibri, Navisworks, Revit, Tekla.

### Struttura di un file .bcfzip

Un file BCF e un archivio ZIP con un topic per sottocartella (nome = GUID del topic):

```
progetto.bcfzip
├── bcf.version                          (versione BCF, es. "2.1")
├── <topic-guid-1>/
│   ├── markup.bcf                       (dati del topic: titolo, stato, commenti, viewpoint)
│   ├── viewpoint.bcfv                   (camera, componenti selezionati/nascosti, clipping plane)
│   ├── snapshot.png                     (screenshot obbligatorio del viewpoint)
│   └── <altri file di viewpoint aggiuntivi>
└── <topic-guid-2>/
    └── ...
```

### Contenuto di markup.bcf (elementi principali)

- `Topic` (nodo radice): attributi `Guid` e `TopicType` (es. "Clash", "Issue", "Request"); figli tipici — `Title`, `Priority`, `Status` (es. Open/In Progress/Closed, valori configurabili per progetto), `Labels`, `CreationDate`, `CreationAuthor`, `AssignedTo`, `DueDate`, `Description`
- `Header`: elenco `File` con riferimento agli IFC coinvolti (nome file, opzionale `IfcProject`/`IfcGuid` di riferimento)
- `Comment` (0..n): `Guid`, `Date`, `Author`, `Comment`, opzionale riferimento a un `Viewpoint` specifico
- `Viewpoints` (0..n): riferimento ai file `.bcfv`/`.png` associati

Il file `.bcfv` (formato XML separato) contiene la vera geometria del viewpoint: `PerspectiveCamera`/`OrthogonalCamera`, `Components` con `Selection` (GUID IFC selezionati), `Visibility` (componenti nascosti/visibili), `ClippingPlanes`.

### Differenze principali BCF 2.1 vs 3.0

- BCF 3.0 aggiunge la cartella `Documents` per allegare documenti di riferimento al topic (non solo screenshot)
- BCF 3.0 e allineato con la specifica **BCF-API** per l'integrazione con Common Data Environment via REST (autenticazione OAuth2, endpoint per progetti/topic/commenti)
- BCF 2.1 resta il piu diffuso lato client (Solibri, BIMcollab, Navisworks-plugin); usarlo come default salvo requisito esplicito di integrazione CDE via API

### Lettura/scrittura programmatica

La libreria di riferimento e `bcf-client` (`pip install bcf-client`, distribuita nel progetto IfcOpenShell — documentazione su docs.ifcopenshell.org/bcf.html). Verificare sempre la versione installata prima di assumere metodi disponibili; esempio di lettura verificato:

```python
from bcf.bcfxml import load

with load("clash_report.bcfzip") as bcfxml:
    print(bcfxml.project.name)

    for topic_guid, topic_handler in bcfxml.topics.items():
        topic = topic_handler.topic
        print(topic.guid, topic.title)

        for comment in topic_handler.comments:
            print(comment.author, comment.comment)
```

Per la generazione di nuovi topic/commenti/viewpoint verificare la classe corrispondente (`bcf.v2` o `bcf.v3`) nella versione installata, poiche l'API di scrittura e cambiata tra le minor release della libreria — non assumere nomi di metodo non confermati nella documentazione locale (`python -c "import bcf; help(bcf)"`).

## Anti-pattern

| Errore | Correzione |
|--------|------------|
| Trattare ogni clash del report come issue singola | Aggregare per causa comune (es. stesso impianto che attraversa piu muri) prima di creare i ticket |
| Ignorare i clearance violation (interferenze di spazio minimo, non intersezione geometrica) | Categorizzarli separatamente: spesso sono normativi (spazi di manovra, distanze di sicurezza), non solo geometrici |
| Chiudere un topic BCF cambiando solo lo `Status` senza commento | Aggiungere sempre un `Comment` con la motivazione della chiusura — e la sola traccia auditabile nel file BCF |
| Generare uno snapshot.png generico non centrato sul clash | Il viewpoint (.bcfv) deve isolare via `Selection`/`ClippingPlanes` gli elementi coinvolti, altrimenti il destinatario non individua il problema |
| Assumere che tutti i tool esportino BCF nello stesso modo | Verificare la versione (2.1 vs 3.0) prima di importare: alcuni client BCF 3.0-only rifiutano file 2.1 e viceversa |
| Confrontare due modelli senza allineare l'origine condivisa (shared coordinates) | Falsi clash da disallineamento geometrico — verificare `IfcSite.RefLatitude/RefLongitude` o il sistema di coordinate condiviso prima di aggregare i report |
