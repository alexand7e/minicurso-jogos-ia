# Instruções para assistentes de IA neste projeto

Jogo 2D em **Godot 4.7** (GDScript), baseado no demo oficial "Dodge the Creeps".
Documentos e comentários em português do Brasil; nomes de código em inglês, como no demo.

## Como trabalhamos: SDD (desenvolvimento guiado por especificação)

Nenhuma mudança de comportamento é feita sem spec. O ciclo é sempre este:

1. **Spec** (`spec.md`): o que muda e por quê, com critérios de aceitação (CA-xx). Sem código.
2. **Plano** (`plan.md`): como fazer neste código, quais arquivos mexem, como cada CA será verificado.
3. **Tarefas** (`tasks.md`): passos pequenos, cada um com sua verificação.
4. **Implementação**: uma tarefa por vez, rodando `scripts/check.sh` ao fim de cada uma.

Os documentos ficam em `specs/NNN-nome-curto/`. Antes de planejar ou implementar, leia
`specs/constitution.md` (princípios do projeto) e `specs/000-jogo-base/spec.md` (o que o jogo já faz).
Se a spec estiver errada ou incompleta, pare e proponha o ajuste na spec; não contorne no código.

## Mapa do projeto

| Arquivo | Papel |
| --- | --- |
| `config.gd` | Autoload `Config`: textos, cores e números do jogo. Acesso: `Config.PLAYER_SPEED` |
| `main.gd` / `main.tscn` | Orquestra a partida: `new_game()`, `game_over()`, timers de início, inimigos, pontuação e fases |
| `player.gd` / `player.tscn` | Jogador (`Area2D`): movimento e sinal `hit` |
| `mob.gd` / `mob.tscn` | Inimigo (`RigidBody2D`, grupo `mobs`) |
| `hud.gd` / `hud.tscn` | Interface (`CanvasLayer`): pontuação, mensagens, botão de jogar, seletor de personagem (criado por código) |
| `scenery.gd` | Chão das fases (`Node2D` criado pelo `Main`): trechos que descem durante a partida; Raul Lopes e UFPI |
| `tests/run_tests.gd` | Testes de aceitação, um grupo por CA-xx |
| `scripts/check.sh` | Importa recursos e roda os testes (código de saída 0 = passou) |
| `specs/` | Constituição, modelos, spec do jogo base e exemplos |

Sinais: `Player.hit` chama `Main.game_over`; `HUD.start_game` chama `Main.new_game`.

## Como verificar

- Rode `scripts/check.sh` com a variável `GODOT` apontando para o executável do Godot
  (ou com `godot` no PATH). Ele roda sem janela. Se não houver Godot disponível, diga isso
  em vez de afirmar que verificou.
- O check não substitui jogar: peça ao humano para jogar uma partida (F5 no editor) ao fim de cada tarefa.

## Regras

1. Números e textos que definem a "cara" do jogo ficam em `config.gd`, nunca espalhados.
2. Todo CA-xx novo ganha uma verificação em `tests/run_tests.gd`, continuando a numeração.
3. Não edite à mão `.godot/`, `*.import` nem `*.uid`. Não renomeie nós ou cenas existentes sem pedir.
4. Evite editar `.tscn` à mão. Se a spec exigir cena ou nó novo, crie-o por código ou explique ao humano
   o que montar no editor.
5. Arte ou som novos só entram com licença conhecida, registrada na seção Créditos do `README.md`.
6. Mantenha o escopo pequeno: uma spec, uma mudança que dê para jogar e sentir.
7. Em dúvida real sobre a intenção, pergunte (no máximo 3 perguntas) em vez de inventar.
