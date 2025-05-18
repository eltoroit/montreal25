```Mermaid
flowchart LR;
    Design
    Setup["Initialize
    Org"]
    Test
    Configure
    Deploy
    Monitor

    subgraph Build
        direction TB
        Test-->Configure
        Configure-->Test
    end

    Design-->Setup
    Setup-->Build
    Build-->Deploy
    Deploy-->Monitor
```
