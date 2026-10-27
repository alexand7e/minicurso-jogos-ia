# Spec 001: Tema B-R-O Bró

> Primeira de duas specs do jogo da oficina com cara de Teresina. Esta troca a aparência e deixa escolher o
> personagem; a mecânica nova (termômetro, cajuína e sombra) fica para a spec 005 (a 002 virou as fases; a 003 e a 004, o contato com o cenário e a profundidade), para cada etapa dar para
> jogar e sentir sozinha.

## Por quê
O jogo base é genérico: bichos de um demo qualquer. Para a oficina em Teresina, quem joga deve reconhecer a
própria cidade logo na primeira tela, no calor do B-R-O Bró (setembro a dezembro), e se ver no personagem.
Isso puxa o interesse para as próximas mudanças.

## O que muda
- Há três personagens teresinenses atravessando a cidade a pé no calor: um vendedor ambulante de cajuína,
  um estudante indo para a aula e um teresinense comum.
- Na tela inicial, antes de jogar, quem joga troca entre os três e vê o nome do escolhido. O primeiro já vem
  escolhido, e a escolha continua valendo nas partidas seguintes até ser trocada.
- Os inimigos deixam de ser bichos e viram ameaças do calor: sol a pino, labaredas, rajadas de mormaço.
  Continuam se comportando como antes (atravessam a tela em linha reta).
- O fundo deixa de ser verde-azulado e passa a lembrar chão quente (terra ou asfalto sob o sol).
- Os textos da tela falam do tema: título com "B-R-O Bró", mensagem de preparar e de fim de jogo combinando.
- A música vira uma faixa com clima nordestino.
- Toda arte e som novos são prontos, podem vir de pacotes diferentes, têm licença conhecida e aparecem nos
  Créditos do README.

## Fora do escopo
- Termômetro, itens de cajuína e sombra de mangueira (spec 005).
- Diferença de jogo entre personagens: os três têm a mesma velocidade e o mesmo tamanho de colisão.
- Qualquer mudança de regra: velocidade, pontuação, colisão e ritmo continuam iguais aos da spec 000.
- Guardar a escolha de personagem depois de fechar o jogo.
- Cenário desenhado (ruas, prédios, ponte). Nesta etapa o fundo é só uma cor.
- Trocar os efeitos sonoros (som de fim de jogo).

## Critérios de aceitação
- **CA-05**: Dada uma partida em andamento, quando inimigos nascem, então cada um mostra uma das artes de calor
  do tema e nenhum mostra a arte dos bichos do demo.
- **CA-06**: Dada a tela inicial, quando quem joga troca de personagem para a frente ou para trás, então a escolha
  percorre os três em ciclo e o nome mostrado acompanha a escolha. Sem trocar nada, o escolhido é o primeiro.
- **CA-07**: Dado um personagem escolhido, quando a partida começa e o jogador anda, então ele aparece com a arte
  desse personagem e anima ao andar.
- **CA-08**: Dado um personagem escolhido e uma partida terminada, quando a próxima partida começa sem trocar,
  então o personagem continua o mesmo.
- **CA-09**: Dado o jogo aberto, então a tela inicial mostra o título do tema e a cor de fundo do tema, definidos
  no mesmo lugar que os demais textos e cores do jogo, assim como os nomes dos três personagens.
- **CA-10** (manual): Dá para trocar de personagem com o teclado e com o mouse, e durante a partida não dá.
- **CA-11** (manual): Os textos, inclusive "Bró" e os nomes com acento, aparecem legíveis na fonte do jogo.
- **CA-12** (manual): A música nova toca durante a partida e para no fim, como a antiga.
- **CA-13** (manual): Cada arquivo de arte e som novo está nos Créditos do README com autor, licença e link.
- **CA-14** (manual): Alguém que conhece Teresina, vendo uma partida sem explicação, reconhece o tema de calor.
- Os critérios CA-01 a CA-04 continuam passando sem mudança.

## Perguntas em aberto
Nenhuma. Decisões tomadas:
- Três personagens, escolhidos na tela inicial; a diferença é só de aparência.
- A música e a arte são escolhidas no plano, entre faixas e pacotes com licença conhecida, e podem misturar
  pacotes diferentes.
