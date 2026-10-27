# Spec 002: Duas fases pelas ruas de Teresina

> Continua a spec 001. O termômetro, a cajuína e a sombra de mangueira, que seriam a 002, passam para a spec 003.

## Por quê
Hoje a partida acontece num fundo liso: não dá a sensação de ir a lugar nenhum. Atravessar lugares que quem joga
conhece (a Raul Lopes beirando o Poti, a Ponte Estaiada, a UFPI) dá vontade de sobreviver para ver o que vem
depois e faz o tema de Teresina aparecer de verdade.

## O que muda
- O chão anda de cima para baixo durante a partida, como se o personagem avançasse pela rua. Na tela inicial e
  depois do fim de jogo o chão fica parado.
- **Fase 1, Avenida Raul Lopes**: avenida de mão dupla, calçadão arborizado e carnaúbas, o rio Poti ao lado com aguapés
  e, de tempos em tempos, a Ponte Estaiada cruzando o rio, com seu mastro e cabos. "Raul Lopes" pintado no asfalto e
  "Rio Poti" escrito na água.
- **Fase 2, UFPI**: a Avenida Universitária ao lado do campus, com o portal "UFPI", prédios com nome (CCN, CCHL, CT,
  CCS, RU, Biblioteca), estacionamento e muitas árvores.
- A partida começa na fase 1. Ao chegar a uma pontuação definida na configuração, começa a fase 2: aparece o nome da
  fase e o cenário da UFPI entra por cima da tela, continuando a rua (sem corte seco). Na fase 2 os inimigos nascem
  um pouco mais rápido.
- Ao começar uma partida nova, tudo volta à fase 1.
- O nome de cada fase aparece na tela quando ela começa.
- Os textos da interface ganham contorno, para continuar legíveis sobre o cenário.

## Fora do escopo
- Mais de duas fases, chefes, fim da fase ou tela de vitória: a fase 2 segue até o fim da partida.
- Colisão com o cenário (rio, prédios, carros): o personagem passa por cima de tudo, como hoje.
- Carros andando, pedestres ou qualquer outro elemento que se mexa por conta própria.
- Mudar como os inimigos nascem e se movem (só o intervalo entre eles muda na fase 2).
- Fidelidade de mapa: as referências são reconhecíveis, não uma planta exata dos lugares.
- Termômetro, cajuína e sombra (spec 003).

## Critérios de aceitação
- **CA-15**: Dada uma partida nova, então a fase é a 1 e todo o cenário à vista é o da Raul Lopes.
- **CA-16**: Dada a tela inicial, o chão fica parado. Dada uma partida em andamento, o chão desce na velocidade
  configurada e cobre a tela inteira o tempo todo, sem buracos entre um trecho e o seguinte.
- **CA-17**: Dada a fase 1, quando a pontuação chega ao mínimo da fase 2, então a fase passa a ser a 2, o nome dela
  aparece na tela, os inimigos passam a nascer no intervalo da fase 2 e o cenário que entra por cima é o da UFPI.
- **CA-18**: Dada uma partida que terminou na fase 2, quando uma partida nova começa, então volta a fase 1, com o
  cenário da Raul Lopes e o intervalo de inimigos da fase 1.
- **CA-19** (manual): Quem conhece Teresina reconhece a Raul Lopes ao lado do Poti e a Ponte Estaiada.
- **CA-20** (manual): Quem conhece Teresina reconhece a UFPI.
- **CA-21** (manual): O chão desce suave, sem tremer nem mostrar emenda entre trechos.
- **CA-22** (manual): Pontuação, mensagens e nome do personagem continuam legíveis sobre o cenário.
- **CA-23** (manual): Cada arquivo novo de arte está nos Créditos do README com autor, licença e link.
- Os critérios CA-01 a CA-09 continuam passando.

## Perguntas em aberto
Nenhuma. Decisões tomadas (dá para mudar na configuração):
- O chão anda de cima para baixo porque a tela é em pé; o personagem continua livre para andar em qualquer direção.
- A fase 2 começa aos 20 pontos (uns 20 segundos), para quase todo mundo chegar a ver a UFPI na oficina.
- Na fase 2 os inimigos nascem a cada 0,4 s (na fase 1, 0,5 s, como hoje).
- O chão anda a 120 px/s.
