# Minicurso: jogos com IA e SDD

Projeto base do minicurso. É o jogo oficial **Dodge the Creeps** do Godot (arte, música e código prontos), com três acréscimos para trabalhar com IA:

- `config.gd`: textos, cores e números do jogo em um só arquivo, para ver resultado em segundos.
- `tests/` e `scripts/check.sh`: verificação automática, para a IA (e você) saberem se algo quebrou.
- `specs/` e `.claude/commands/`: o fluxo **SDD** (desenvolvimento guiado por especificação) pronto para usar.

> Testado com Godot 4.7.2 em Linux, sem janela. Os testes cobrem as regras da partida, mas não o visual: jogue uma partida (F5) antes de apresentar.

## Pré-requisitos

| O que | Para quê |
| --- | --- |
| [Godot 4.7.x](https://godotengine.org/download), versão padrão (não a ".NET") | Abrir e jogar o projeto. É um executável único, sem instalador |
| Git | Baixar o projeto e versionar as mudanças |
| Um assistente de IA no editor ou terminal (Claude Code, Cursor, Copilot...) | Executar as etapas do SDD |

## Primeiros passos

1. **Baixar o projeto.** `git clone <endereço-do-repositório>` e depois `cd minicurso-jogos-ia`. Traz código, arte, specs e comandos de uma vez.
2. **Abrir no Godot.** No gerenciador de projetos: *Importar*, escolha o arquivo `project.godot`. A primeira abertura importa arte e som (cerca de um minuto, só desta vez).
3. **Jogar.** Aperte **F5**. Setas ou WASD movem o personagem; Espaço ou Enter começam a partida. Se jogou uma partida inteira, o ambiente está certo.
4. **Mudar sem código.** Abra `config.gd`, troque `PLAYER_SPEED`, `BACKGROUND_COLOR` ou `TITLE`, salve e aperte F5 de novo. Cada valor tem um comentário explicando a unidade.
5. **Verificar.** Diga onde está o Godot e rode o check. Ele importa os recursos e roda os testes sem abrir janela; termina com `OK: N verificacoes passaram.` e código 0 quando está tudo certo.

   ```bash
   # Linux / macOS (no macOS o executável fica em /Applications/Godot.app/Contents/MacOS/Godot)
   export GODOT=/caminho/do/executavel/do/Godot
   ./scripts/check.sh
   ```

   ```powershell
   # Windows (PowerShell): use a versão "_console.exe" para ver a saída no terminal
   $env:GODOT = "C:\caminho\Godot_v4.7.2-stable_win64_console.exe"
   & $env:GODOT --headless --path . --import
   & $env:GODOT --headless --path . --fixed-fps 60 -s res://tests/run_tests.gd
   ```

   O script `.sh` foi testado; os comandos do Windows são o mesmo procedimento escrito à mão.

## Fluxo SDD: spec, plano, tarefas, código

Cada etapa produz um documento diferente e uma pessoa lê e aprova antes da próxima. Os documentos de cada mudança ficam em `specs/NNN-nome/`.

| Etapa | Comando no Claude Code | Gera | O que só esta etapa faz |
| --- | --- | --- | --- |
| 1 | `/especificar <ideia em uma frase>` | `spec.md` | Alinha o QUÊ e o POR QUÊ, com critérios de aceitação que dá para verificar |
| 2 | `/planejar` | `plan.md` | Decide o COMO neste código e liga cada critério a uma verificação |
| 3 | `/tarefas` | `tasks.md` | Fatia o plano em passos pequenos, cada um com sua verificação |
| 4 | `/implementar` | código e testes | Executa **uma** tarefa por vez; você joga e aprova antes da seguinte |

- **Claude Code:** abra um terminal na pasta do projeto e rode `claude`. Os comandos acima já existem em `.claude/commands/`, e o `CLAUDE.md` faz a IA ler as regras do `AGENTS.md`.
- **Outro assistente:** peça que leia `AGENTS.md`, depois cole o conteúdo de `.claude/commands/<etapa>.md` trocando `$ARGUMENTS` pela sua ideia.

Os princípios do projeto estão em `specs/constitution.md`; modelos em `specs/templates/`; o que o jogo já faz, em `specs/000-jogo-base/`.

## Exemplo completo (e plano B)

`specs/exemplos/dificuldade-progressiva/` traz um ciclo inteiro já pronto (spec, plano e tarefas): inimigos que ficam mais rápidos conforme a pontuação. Use para ver como uma spec boa se parece.

Se a IA travar ou o tempo apertar, aplique a solução verificada na raiz do projeto e rode o check (deve dar 20 verificações):

```bash
git apply specs/exemplos/dificuldade-progressiva/solucao.patch
./scripts/check.sh
```

## Ideias de mudança para a prática

| Ideia | Dificuldade | Mexe em |
| --- | --- | --- |
| Trocar textos, cores e velocidades | Fácil, sem IA | `config.gd` |
| Recorde salvo, mostrado no fim da partida | Média | `main.gd`, `config.gd` |
| Turbo do jogador ao segurar Shift | Média | `player.gd`, `config.gd` |
| Três vidas antes do fim de jogo | Média | `main.gd`, `player.gd`, `hud.gd` |
| Novo tipo de inimigo (maior ou mais rápido) | Média | `main.gd`, `mob.gd` |
| Trocar arte e música por pacotes CC0 | Fácil, mas exige baixar arquivos | `art/`, `README.md` (créditos) |

## Estrutura

```
config.gd            textos, cores e números do jogo
main.gd / .tscn      regras da partida
player.gd / .tscn    jogador
mob.gd / .tscn       inimigo
hud.gd / .tscn       interface
art/ fonts/          arte, música e fonte do demo
tests/run_tests.gd   testes de aceitação (um grupo por CA-xx)
scripts/check.sh     importa e roda os testes sem janela
specs/               constituição, modelos, spec base e exemplos
AGENTS.md            regras para a IA (CLAUDE.md aponta para ele)
.claude/commands/    os quatro comandos do SDD
```

## Problemas comuns

| Sintoma | O que fazer |
| --- | --- |
| `Godot nao encontrado` | Defina a variável `GODOT` com o caminho do executável (passo 5) |
| `FALHA: ha erros de script` | Leia a primeira linha `SCRIPT ERROR` da saída: ela aponta arquivo e linha |
| Letra com acento sai errada na tela | A fonte do demo (Xolonium) pode não ter o glifo. Evite acento nos textos ou troque a fonte |
| Git mostra arquivos `.uid` novos | Normal: o Godot cria um por script novo. Pode versionar |
| Primeira abertura demora | O Godot está importando arte e som. Acontece uma vez |

## Créditos e licenças

- **Jogo base:** *Dodge the Creeps*, de [godotengine/godot-demo-projects](https://github.com/godotengine/godot-demo-projects), licença MIT (texto em `LICENSE`).
- **Arte:** "Abstract Platformer", de [Kenney](https://www.kenney.nl/assets/abstract-platformer), CC0 1.0.
- **Música:** "House In a Forest Loop", © 2012 [HorrorPen](https://opengameart.org/users/horrorpen), [CC-BY 3.0](https://creativecommons.org/licenses/by/3.0/). Atribuição obrigatória em qualquer jogo publicado com ela. Fonte: https://opengameart.org/content/loop-house-in-a-forest
- **Fonte:** Xolonium, © 2011-2016 Severin Meyer, SIL Open Font License 1.1 (`fonts/LICENSE.txt`).

### Tema B-R-O Bró (`art/teresina/`, spec 001)

Os arquivos de `art/teresina/` foram gerados por `scripts/preparar_arte.gd` (arte) e `scripts/gerar_baiao.py` (música);
o topo de cada script explica como refazer.

- **Personagens** (`vendedor_*`, `estudante_*`, `teresinense_*`): "Toon Characters", de [Kenney](https://kenney.nl/assets/toon-characters), CC0 1.0. Poses *walk* e *climb* de Male person, Female person e Male adventurer, reduzidas para 144 x 192.
- **Brasa e mormaço** (`brasa_*`, `mormaco_*`): "Particle Pack", de [Kenney](https://kenney.nl/assets/particle-pack), CC0 1.0. `fire_01`/`fire_02` e `smoke_04`/`smoke_07`, recortados e coloridos.
- **Sol** (`sol_*`): "Shiny Sun", de SalemF, [OpenGameArt](https://opengameart.org/content/shiny-sun), CC0 1.0, sobre o brilho `star_08`/`star_09` do "Particle Pack" (Kenney, CC0 1.0), colorido.
- **Música** (`baiao_do_bro_bro.wav`): baião original composto e sintetizado por código para este projeto, CC0 1.0.
- **Livro de referência do minicurso:** Clinton Keith, *Agile Game Development: Build, Play, Repeat*, 2ª edição, Addison-Wesley, 2020.
- **Nomes dos artefatos do SDD** (constituição, spec, plano, tarefas): inspirados no [GitHub Spec Kit](https://github.com/github/spec-kit), uma ferramenta de código aberto mais completa para o mesmo fluxo.
