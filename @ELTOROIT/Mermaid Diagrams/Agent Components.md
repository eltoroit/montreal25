```Mermaid
flowchart LR;
    subgraph Agent[Agentforce Agent]
        direction TB
        subgraph Topic1[Topic]
            direction TB
            Instruction11[Instruction]-.calls.->Action11[Action]
            Instruction11[Instruction]-.uses.->Action12[Action]
            Instruction12[Instruction]-.executes.->Action12[Action]
            Instruction12[Instruction]-.launches.->Action13[Action]
            Instruction13[Instruction]-.performs.->Action14[Action]
        end
        subgraph Topic2[Topic]
            direction TB
            Instruction21[Instruction]-.invokes.->Action21[Action]
        end
    end
```
