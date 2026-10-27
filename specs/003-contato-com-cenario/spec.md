# Spec 003: Contato com o cenário

> Continua a spec 002. A profundidade (prédios com altura e sombras) é a spec 004; o termômetro, a cajuína e a
> sombra de mangueira passam para a spec 005.

## Por quê
Hoje o personagem passa por cima do rio, dos prédios e das árvores: o cenário parece só um fundo pintado. Quando a
rua oferece obstáculos e o chão muda o passo, quem joga sente que está andando pela Raul Lopes e pela UFPI, e desviar
do cenário vira parte do desafio, além de desviar do calor.

## O que muda
- **Obstáculos sólidos**: o personagem não atravessa o rio Poti, os prédios, as árvores, as carnaúbas, os carros
  parados, o mastro da Ponte Estaiada nem os pilares do portal da UFPI. Ao andar contra um deles, para encostado; ao
  andar na diagonal, desliza ao longo dele em vez de grudar.
- **A ponte é passagem**: sobre o tabuleiro da Estaiada dá para andar por cima do rio (até o mastro).
- **O chão empurra**: como o chão desce, um obstáculo que chega por cima empurra o personagem para baixo. Se ele for
  empurrado para fora da tela por baixo, **torrou**: a partida acaba como ao tocar um inimigo.
- **O chão muda o passo**: no asfalto o personagem anda na velocidade normal; no calçadão e na calçada, um pouco mais
  rápido; na grama e na areia, mais devagar. Os valores ficam na configuração.
- Alguns carros ficam estacionados junto ao meio-fio da avenida, para a rua também ter o que desviar.
- A avenida sempre tem um caminho livre de cima a baixo, nas duas fases: nunca dá para ficar sem saída.

## Fora do escopo
- Inimigos batendo no cenário: brasa, sol e mormaço continuam atravessando tudo, como hoje.
- Carros andando, pedestres ou qualquer obstáculo que se mexa por conta própria.
- Som ou tremida da tela ao encostar em algo.
- Prédios com altura, sombras e qualquer mudança de câmera (spec 004).
- Mudar a posição dos elementos do cenário, além de acrescentar os carros junto ao meio-fio.

## Critérios de aceitação
- **CA-24**: Dado um obstáculo à frente do personagem, quando ele anda contra o obstáculo, então para encostado sem
  atravessar; quando anda na diagonal contra ele, continua andando de lado, encostado.
- **CA-25**: Dada uma partida em andamento, quando um obstáculo desce sobre o personagem parado, então ele é empurrado
  para baixo junto; quando é empurrado para fora da tela por baixo, então a partida termina, com a mensagem de fim de
  jogo, como ao tocar um inimigo.
- **CA-26**: Dado o personagem andando, então a velocidade depende do chão sob ele: no calçadão mais rápido que no
  asfalto, na grama e na areia mais devagar, com os valores da configuração.
- **CA-27**: Dada cada fase, então o cenário tem os obstáculos dela (Raul Lopes: rio, árvores, carnaúbas, mastro da
  ponte e carros; UFPI: prédios, árvores, carros e pilares do portal), o tabuleiro da ponte é chão de andar, a posição
  inicial do personagem está livre e a avenida tem um corredor livre de cima a baixo, largo o bastante para ele.
- **CA-28** (manual): Encostar e deslizar nos obstáculos parece natural: sem tremer, sem "pular" de lugar.
- **CA-29** (manual): Dá para sentir a diferença de passo entre asfalto, calçadão, grama e areia.
- Os critérios CA-01 a CA-18 continuam passando.

## Perguntas em aberto
Nenhuma. Decisões tomadas com quem pediu:
- Obstáculos sólidos e chão que muda o passo, sim; inimigos batendo no cenário, não (por enquanto).
- Ser empurrado para fora da tela por baixo faz perder ("Torrou!").
- Árvores e carnaúbas bloqueiam pelo tronco (um pouco menor que a copa desenhada), para não parecer injusto.
- No calçadão o passo é 15% mais rápido; na grama, 25% mais lento; na areia, 45% mais lento.
