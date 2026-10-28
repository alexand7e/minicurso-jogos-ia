# Roteiro da aula (2 horas)

Acompanha a apresentação "Minicurso: Jogos com IA e SDD". Cada bloco diz o que se faz e o que se usa do repositório.
O objetivo é cada equipe sair com **uma mudança jogável**: decidir, escrever, verificar.

| # | Bloco | Tempo | No repositório |
| --- | --- | --- | --- |
| 1 | Abertura: o destino | 8 min | — |
| 2 | Equipe: quem faz o quê | 12 min | [Papéis](#2-equipe-12-min) |
| 3 | Planejar: o que entra | 15 min | `specs/templates/cartao-de-visao.md` |
| 4 | Godot: conceitos e projeto | 10 min | branch `main`, `main.tscn`, `config.gd` |
| 5 | SDD: o método | 15 min | `specs/`, `AGENTS.md`, `.claude/commands/` |
| 6 | Estudo de caso: o jogo de voo | 12 min | `specs/exemplos/voo-com-obstaculos/spec.md` |
| 7 | Demonstração: ciclo completo | 13 min | branch `demo/dificuldade-progressiva` (plano B) |
| 8 | Prática: equipes em ação | 25 min | uma branch `equipe/<nome>` por equipe |
| 9 | Fechamento: retrospectiva | 10 min | `specs/templates/retrospectiva.md` |

## Branches

| Branch | Para quê | `scripts/check.sh` |
| --- | --- | --- |
| `main` | Ponto de partida de todo mundo: Dodge the Creeps com config, testes e SDD | 17 verificações |
| `demo/dificuldade-progressiva` | O resultado da demonstração, com **um commit por etapa** do SDD | 20 verificações |
| `oficina-teresina` | Exemplo avançado: o mesmo método, quatro specs seguidas, um jogo com a cara de Teresina | 82 verificações |
| `equipe/<nome>` | A mudança de cada equipe na prática (cada equipe cria a sua) | — |

Para ver o ciclo da demonstração passo a passo: `git log --oneline main..demo/dificuldade-progressiva`.

---

## 1. Abertura (8 min)
- **Objetivo:** cada equipe decide, especifica e verifica uma mudança no jogo, com a IA como ferramenta.
- **Como trabalhamos:**
  - a equipe decide (uma pessoa aprova cada spec e cada plano);
  - a IA executa uma tarefa por vez, sempre com o check;
  - a spec guia;
  - o teste e uma partida jogada confirmam.
- **Por que Godot:** em duas horas, cada minuto de instalação é um minuto a menos de prática. É um executável único, o demo vem pronto e o projeto é texto, então a IA lê, edita e roda os testes.

## 2. Equipe (12 min)
A IA é ferramenta do time, não um membro. Quem decide e aprova são pessoas.

| Papel | Faz |
| --- | --- |
| Dono do produto | Decide o que entra no jogo e em que ordem. Aprova spec e plano |
| Desenvolvimento | Conduz a IA, uma tarefa por vez, e roda o check |
| Arte e áudio | Escolhe arquivos com licença conhecida e cuida do visual e do som |
| Testes de jogo | Joga cada mudança e diz se ficou divertido |

Equipes de 3 a 5 pessoas; com 3, uma pessoa acumula dois papéis.

## 3. Planejar (15 min)
Copie `specs/templates/cartao-de-visao.md` para `specs/cartao.md` e preencha as cinco linhas. O `/especificar` lê
esse cartão. Decidir o que **não** fazer define o jogo tanto quanto o que fazer.

## 4. Godot (10 min)
1. Baixe o Godot 4.7 e o repositório: `git clone https://github.com/alexand7e/minicurso-jogos-ia.git`.
2. No Godot, *Importar* e escolha `project.godot`.
3. Aperte **F5**. Se o jogo abriu, está tudo pronto.

Cinco conceitos: nó, cena, árvore de cena, sinal e script. Na árvore de `main.tscn`:

```
Main (Node)
├── ColorRect
├── Player (Area2D)            cena player.tscn
├── MobTimer, ScoreTimer, StartTimer
├── StartPosition (Marker2D)
├── MobPath (Path2D) → MobSpawnLocation
├── HUD (CanvasLayer)          cena hud.tscn
└── Music, DeathSound
```

| Sinal | Quem reage | O que acontece |
| --- | --- | --- |
| `Player.hit` | `Main.game_over` | O jogador tocou num inimigo: a partida termina |
| `HUD.start_game` | `Main.new_game` | Apertou Jogar: começa uma partida nova |
| `MobTimer.timeout` | `Main._on_MobTimer_timeout` | A cada 0,5 s nasce um inimigo de `mob.tscn` |

Comece mudando um número em `config.gd` e apertando F5.

## 5. SDD (15 min)
Primeiro escrevemos o que queremos; a IA só escreve código depois.

| Etapa | Comando | Gera | A equipe decide |
| --- | --- | --- | --- |
| 1 | `/especificar <ideia>` | `spec.md`: o quê, por quê, critérios de aceitação | É isso mesmo? O que fica de fora? |
| 2 | `/planejar` | `plan.md`: arquivos que mudam e como cada critério é testado | É o plano mais simples possível? |
| 3 | `/tarefas` | `tasks.md`: passos pequenos, cada um com verificação | Cada passo cabe numa conversa curta? |
| 4 | `/implementar T1` | código e testes de uma tarefa | Jogue (F5) antes de liberar a próxima |

- **Critério sem teste não existe:** cada CA-xx aponta para uma função em `tests/run_tests.gd`. Exemplo: o CA-02 do jogo base é verificado em `_test_ca02_pontuacao_sobe`.
- **Check:** `scripts/check.sh` termina com `OK: 17 verificacoes passaram.` na `main`.
- **Outro assistente:** cole o texto de `.claude/commands/<etapa>.md` como prompt.

## 6. Estudo de caso: o jogo de voo (12 min)
Um jogo inteiro em três decisões: ação, regra de pontos e jeito de perder. A spec está em
[`specs/exemplos/voo-com-obstaculos/spec.md`](../specs/exemplos/voo-com-obstaculos/spec.md).
- **Só a spec:** o repositório não traz o código desse jogo.
- **Na prática:** escrever essa spec e os testes dela é o "Desafio: só a spec" do cardápio.
- **Depois da aula:** implementá-la do zero é o passo "Em seguida".

## 7. Demonstração (13 min)
Uma ideia, quatro comandos, um jogo diferente no fim.

| Passo | Tempo | O que fazer |
| --- | --- | --- |
| 1 | 3 min | `/especificar inimigos mais rápidos conforme a pontuação` |
| 2 | 2 min | Ler a spec em voz alta e cortar o que não cabe |
| 3 | 3 min | `/planejar` e `/tarefas`, revisando cada um |
| 4 | 3 min | `/implementar`, uma tarefa por vez, rodando o check |
| 5 | 2 min | Jogar (F5) e conferir o critério manual |

**Plano B**, se a IA travar ou o tempo apertar (o check deve dar **20 verificações**), escolha uma das duas formas:

```bash
# aplicar a solução verificada na main
git apply specs/exemplos/dificuldade-progressiva/solucao.patch
./scripts/check.sh

# ou mostrar o ciclo já feito, um commit por etapa
git switch demo/dificuldade-progressiva
git log --oneline main..
```

## 8. Prática (25 min, em equipes)

```bash
git switch main
git switch -c equipe/<nome-da-equipe>
```

| Tempo | Etapa | O que fazer |
| --- | --- | --- |
| 6 min | Spec | `/especificar` com a ideia do cartão. Leia e corte o excesso |
| 6 min | Plano e tarefas | `/planejar` e `/tarefas`. O dono do produto aprova |
| 10 min | Implementar | Uma tarefa por vez, rodando o check a cada uma |
| 3 min | Jogar e mostrar | Uma pessoa joga; a equipe diz o que mudou |

O cardápio de ideias está no `README.md`. **Pronto quando** o check passa e alguém jogou uma partida.

## 9. Fechamento (10 min)
Retrospectiva em três perguntas, com uma resposta curta para cada: `specs/templates/retrospectiva.md`. Primeiro 2 min
sozinho, depois 4 min em equipe.

### Próximos passos
| Quando | O quê |
| --- | --- |
| Hoje | Abra o repositório, mude um número em `config.gd` e aperte F5 |
| Esta semana | Escreva uma spec nova a partir do cartão de visão e rode o ciclo inteiro |
| Em seguida | Faça o jogo de voo do zero, com a spec primeiro e testes para cada critério |
| Mais tarde | Veja a branch `oficina-teresina` (quatro specs seguidas no mesmo jogo), o GitHub Spec Kit e motores maiores, com o mesmo método |

Um jogo pequeno e terminado ensina mais do que um grande pela metade. Referências: [`docs/referencias.md`](referencias.md).
