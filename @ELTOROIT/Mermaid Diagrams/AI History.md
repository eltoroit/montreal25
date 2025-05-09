```Mermaid
flowchart TD
 subgraph FirstWave["**Early AI**"]
        T1950["**1950**: Turing Test"]
        E1956@{ label: "**1956**: Dartmouth Conference\n        'Artificial Intelligence'" }
        E1966["**1966**: ELIZA"]
  end
 subgraph SecondWave["**1990s-2010s**"]
        D1997["**1997**: Deep Blue
        Garry Kasparov"]
        W2011["**2011**: IBM Watson
        Jeopardy!"]
  end
 subgraph ThirdWave["**2018+**"]
        G2020["**2018**: GPT-1"]
        C2022["**2022**: ChatGPT
        (mainstream)"]
        M2023["**2023**: Multimodal Models
        (text, vision & reasoning)"]
  end
    FirstWave L1@== &nbsp;(First Winter)&nbsp; ==> SecondWave
    SecondWave L2@== &nbsp;(Second Winter)&nbsp; ==> ThirdWave

    L1@{ animate: true }
    L2@{ animate: true }
```
