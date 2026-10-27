# Spec exemplo: Dificuldade progressiva

> Exemplo completo de uma spec boa: curta, só comportamento, critérios verificáveis. Os arquivos `plan.md` e `tasks.md`
> desta pasta mostram as etapas seguintes. A solução verificada está em `solucao.patch`.

## Por quê
Hoje a partida é sempre igual do começo ao fim. Quem joga bem não sente a tensão crescer e perde o interesse.

## O que muda
Quanto mais pontos o jogador tem, mais rápidos ficam os inimigos que nascem. O aumento é gradual e tem um teto, para o jogo nunca ficar impossível.

## Fora do escopo
Mudar a frequência com que os inimigos nascem, o visual ou o som.

## Critérios de aceitação
- **CA-05**: Dado 0 pontos, quando um inimigo nasce, então sua velocidade é sorteada na faixa base (`MOB_MIN_SPEED` a `MOB_MAX_SPEED`).
- **CA-06**: Dado N pontos, quando um inimigo nasce, então as duas pontas da faixa sobem N x `MOB_SPEED_GAIN_PER_POINT`.
- **CA-07**: Dada qualquer pontuação, nenhuma ponta da faixa passa de `MOB_SPEED_CAP`.
- **CA-08** (manual): Jogando cerca de 30 segundos, dá para perceber os inimigos mais rápidos do que no início.

## Perguntas em aberto
Nenhuma. Decisões tomadas: o aumento é por ponto (não por tempo); valores iniciais de 2 px/s por ponto e teto de 600 px/s.
