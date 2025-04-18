# Generic Information

## Notes

- Do not bother with the previews, they are useless. They provide generic topics. But when it gest deployed, the topics become real.

## Create the spec

```
sf agent generate agent-spec \
--agent-user=first_agent@00doz000007e58f.ext \
--company-name=ELTOROit \
--company-description="ELTOROit is not a company but he knows how to build great demos 😳" \
--company-website=https://eltoro.it \
--enrich-logs=true \
--force-overwrite \
--full-interview \
--max-topics=5 \
--role="Engage in a fun and competitive geography game where players answer geography questions to earn points. The Agent provides questions, tracks scores, and declares winners or losers based on points earned, offering an enjoyable way to test and improve geographical knowledge." \
--tone=casual \
--type=customer \
--output-file="@ELTOROIT/agentforce/agent.yaml"
```

## Deploy Agent

```
sf agent create \
--agent-api-name="AGENT_API_NAME" \
--agent-name="AGENT LABEL" \
--spec="@ELTOROIT/agentforce/agent.yaml"
```

# Human Resources Agent

## Create the spec

```
sf agent generate agent-spec \
--type=customer \
--company-name=ELTOROit \
--company-description="ELTOROit is not a company but he knows how to build great demos 😳" \
--company-website=https://eltoro.it \
--role="The Human Resources Agent helps employees find answers to their questions related to policies. The agent also helps with employees requests for paid-time off." \
--max-topics=5 \
--agent-user="agent001@00DRu00000AT9FgMAL.ext" \
--enrich-logs=true \
--tone=casual \
--full-interview \
--force-overwrite \
--output-file="@ELTOROIT/agentforce/agentHR.yaml"
```

## Deploy Agent

```
sf agent create \
--agent-api-name="Human_Resources_Agent" \
--agent-name="Human Resources Agent" \
--spec="@ELTOROIT/agentforce/agentHR.yaml"
```

# Geography Agent

## Create the spec

```
sf agent generate agent-spec \
--type=customer \
--company-name=ELTOROit \
--company-description="ELTOROit is not a company but he knows how to build great demos 😳" \
--company-website=https://eltoro.it \
--role="Engage in a fun and competitive geography game where players answer geography questions to earn points. The Agent provides questions, tracks scores, and declares winners or losers based on points earned, offering an enjoyable way to test and improve geographical knowledge." \
--max-topics=5 \
--agent-user="agent002@00DRu00000AT9FgMAL.ext" \
--enrich-logs=true \
--tone=casual \
--full-interview \
--force-overwrite \
--output-file="@ELTOROIT/agentforce/agentGeo.yaml"
```

## Deploy Agent

```
sf agent create \
--agent-api-name="Geography_Agent" \
--agent-name="Geography Agent" \
--spec="@ELTOROIT/agentforce/agentGeo.yaml"
```
