# Spec 001: Voo com obstáculos

> Estudo de caso da aula: a spec de **outro jogo**, um desafio de um botão só no estilo do Flappy Bird (Dong Nguyen,
> 2013), do mesmo modelo de `specs/templates/spec-template.md`. Por ser outro jogo, a numeração de CA começa do zero.
> O repositório traz só a spec, sem código: escrevê-la (e os testes) é o "Desafio: só a spec"; implementá-la do zero é
> um bom próximo passo depois da aula.

## Por quê
Um desafio de um botão só: passar por aberturas sem bater. O jogo inteiro cabe em três decisões: a ação, a regra de
pontos e o jeito de perder.

## O que muda
- Tocar (ou apertar Espaço) faz o jogador subir; sem tocar, ele cai sozinho.
- Pares de obstáculos, com a abertura numa altura sorteada, chegam da direita em intervalos regulares.
- Atravessar a abertura de um par vale 1 ponto.
- Bater num obstáculo ou no chão encerra a partida.

## Fora do escopo
Recorde salvo, medalhas, níveis e visuais alternativos.

## Critérios de aceitação
- **CA-01**: Dado o jogador no ar, quando ninguém toca, então ele cai e a queda acelera.
- **CA-02**: Dado o jogador caindo, quando há um toque, então ele sobe cerca de 75 px e volta a cair.
- **CA-03**: Dado um par de obstáculos, quando o jogador atravessa a abertura, então a pontuação sobe exatamente 1.
- **CA-04**: Dada uma partida, quando o jogador toca num obstáculo ou no chão, então a partida termina.

## Perguntas em aberto
Nenhuma. Valores de partida, para ajustar jogando (é para isso que serve o `config.gd`):

| Valor | Ponto de partida | O que é |
| --- | --- | --- |
| `GRAVITY` | 1800 | Queda, em px/s² |
| `FLAP_IMPULSE` | 520 | Velocidade para cima de um toque, em px/s (sobe cerca de 75 px) |
| `PIPE_SPEED` | 220 | Velocidade dos obstáculos, em px/s |
| `PIPE_GAP` | 220 | Altura da abertura, em px |
| `PIPE_INTERVAL` | 1.6 | Segundos entre um par e o próximo |
