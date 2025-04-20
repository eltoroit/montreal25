```Mermaid
flowchart TD
    subgraph FirstWave["**Early AI**"]
        T1950@{ label: "**1950**: Turing Test" }
        E1956["**1956**: Dartmouth Conference
        'Artificial Intelligence'"]
        E1966["**1966**: ELIZA"]
    end
    subgraph SecondWave["**1990s-2010s**"]
        D1997["**1997**: Deep Blue
        Garry Kasparov"]
        W2011["**2011**: IBM Watson
        Jeopardy!"]
        A2016["**2016**: AlphaGo
        Lee Sedol"]
    end
    subgraph ThirdWave["**2017+**"]
        T2017["**2017**: Transformer
        architecture for NLP"]
        G2020["**2020**: GPT-3
        (175B parameters)"]
        C2022["**2022**: ChatGPT
        mainstream"]
        M2023["**2023**: Multimodal Models
        text, vision & reasoning"]
    end
    FirstWave L1@-. "&nbsp;(First Winter)&nbsp;" .-> SecondWave
    SecondWave L2@-. "&nbsp;(Second Winter)&nbsp;" .-> ThirdWave

    L1@{ animate: true }
    L2@{ animate: true }
```
