# Spec 004: Profundidade

> Continua a spec 003. O termômetro, a cajuína e a sombra de mangueira ficam para a spec 005.

## Por quê
Mesmo com obstáculos, o cenário visto bem de cima parece um mapa chapado. Se o que é alto (prédios, árvores, o mastro
da Ponte Estaiada) mostrar volume e mudar de ângulo conforme passa, a tela ganha profundidade e a sensação de estar
na rua aumenta, sem deixar de ser um jogo 2D, simples de ler.

## O que muda
- **Câmera com ângulo**: a câmera olha a rua de cima, mas um pouco inclinada para a frente, como quem olha a avenida
  que vem: o ponto bem embaixo dela fica perto da parte de baixo da tela.
- **Coisas altas em perspectiva**: prédios e pilares do portal mostram as paredes viradas para a câmera e o telhado
  deslocado; o mastro da Estaiada aparece como uma torre alta, com os cabos descendo até a ponte; as copas das árvores,
  das carnaúbas, o letreiro do portal e a placa da avenida ficam no alto. Quanto mais alto e mais longe da câmera,
  mais o topo se afasta, e esse afastamento muda enquanto o chão anda.
- **Atrás e na frente**: o que é alto aparece por cima do personagem, então quem passa atrás de um prédio ou sob uma
  copa fica escondido por ela, como na vida real. Os inimigos (calor que voa) aparecem por cima de tudo.
- **Sombras**: o personagem tem sombra nos pés; os inimigos, uma sombra no chão afastada deles, mostrando que voam.
- O que bloqueia continua sendo o pé de cada coisa, no chão, como na spec 003.

## Fora do escopo
- Câmera 3D de verdade, girar ou dar zoom na câmera, câmera que segue o personagem.
- Mudar onde as coisas ficam ou o que bloqueia.
- Sombras que mudam com a hora do dia.
- Perspectiva no personagem e nos inimigos (só ganham sombra).

## Critérios de aceitação
- **CA-30**: Dado algo alto, então seu topo aparece afastado do ponto da câmera, tanto mais quanto mais alto e mais
  longe estiver; bem embaixo da câmera, não se afasta. Dado um prédio, quando o chão anda, então o topo muda de lugar
  em relação ao pé, e o pé continua no mesmo lugar do trecho.
- **CA-31**: Dadas as duas fases, então há coisas altas (prédios na UFPI; mastro com cabos na Raul Lopes; copas nas
  duas); elas aparecem por cima do personagem, e os inimigos aparecem por cima delas.
- **CA-32**: Dado o personagem, andando para cima ou para baixo, então a sombra fica no chão, abaixo dele. Dado um
  inimigo, em qualquer direção, então a sombra fica abaixo dele.
- **CA-33** (manual): Prédios, árvores e o mastro parecem ter altura e mudam de ângulo suavemente ao passar, sem tremer.
- **CA-34** (manual): A profundidade não atrapalha jogar: o personagem e os inimigos continuam fáceis de ver.
- Os critérios CA-01 a CA-27 continuam passando.

## Perguntas em aberto
Nenhuma. Decisões tomadas com quem pediu: "prédios com altura" em vez de entortar a imagem inteira ou só desenhar
fachadas. O ponto embaixo da câmera e a altura dela ficam na configuração.
