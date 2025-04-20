```Mermaid
flowchart LR;
    subgraph Agent[Agentforce Agent]
        direction TB
        subgraph Topic1[Topic]
            direction TB
            Instruction11[Instruction]-->Action11[Action]
            Instruction12[Instruction]-->Action12[Action]
            Instruction12[Instruction]-->Action13[Action]
        end
        subgraph Topic2[Topic]
            direction TB
            Instruction21[Instruction]-->Action21[Action]
        end
    end
```
