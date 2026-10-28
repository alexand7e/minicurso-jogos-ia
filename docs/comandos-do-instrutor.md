# Comandos do instrutor

Os comandos para rodar antes, durante e depois da aula, na ordem. O roteiro completo de cada bloco está em
[`roteiro.md`](roteiro.md).

- Os comandos de terminal são para o **Git Bash**, na pasta do repositório.
- Os que começam com `/` vão no **painel do Claude Code no VS Code**.
- O que se espera ver depois de cada comando está no comentário ao lado.

## Atalho no Windows: `scripts/jogar.ps1`

Para trocar de versão e abrir o jogo sem decorar comandos, rode no PowerShell, na pasta do repositório:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\jogar.ps1
```

Ele faz quatro coisas:
- mostra um menu com as três versões (1 `main`, 2 `demo/dificuldade-progressiva`, 3 `oficina-teresina`);
- recusa trocar se houver mudanças não salvas;
- oferece fechar o Godot se ele estiver aberto;
- troca de branch, importa a arte e abre o jogo.

| Opção | O que faz |
| --- | --- |
| `-Versao main`, `-Versao demo` ou `-Versao teresina` | Pula o menu |
| `-Editor` | Abre o editor (F5 joga) em vez do jogo |
| `-Check` | Roda os testes antes de abrir e mostra o número esperado |
| `-SemAbrir` | Não abre o Godot (útil com `-Check`) |
| `-FecharGodot` | Fecha o Godot aberto sem perguntar |

Exemplo, para conferir as três versões de uma vez na véspera:

```powershell
foreach ($v in "main", "demo", "teresina") { powershell -ExecutionPolicy Bypass -File scripts\jogar.ps1 -Versao $v -Check -SemAbrir }
```

## Antes da aula (na véspera)

### 1. Atualizar a cópia local e deixar o Godot à mão

```bash
cd ~/Documents/code/minicurso-jogos-ia
git switch main
git pull --all

# caminho do Godot (vale para esta janela do terminal)
export GODOT="$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64_console.exe"
```

Para não repetir o `export` a cada terminal, acrescente essa linha ao fim do arquivo `~/.bashrc`.

### 2. Conferir as três branches

```bash
git switch main
bash scripts/check.sh                    # OK: 17 verificacoes passaram.

git switch demo/dificuldade-progressiva
bash scripts/check.sh                    # OK: 20 verificacoes passaram.
git log --oneline --no-merges main..     # 7 commits: spec, plano, tarefas, T1, T2, T3, README

git switch oficina-teresina
bash scripts/check.sh                    # OK: 82 verificacoes passaram.

git switch main
```

### 3. Ensaiar o plano B e desfazer

```bash
git apply specs/exemplos/dificuldade-progressiva/solucao.patch
bash scripts/check.sh                    # OK: 20 verificacoes passaram.
git restore .                            # volta a main como estava
git status --short                       # não deve mostrar nada
```

### 4. Jogar uma partida em cada branch

Feche o editor do Godot antes de trocar de branch: as cenas e a arte mudam entre elas.

```bash
git switch main
"$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --path . -e   # abre o editor; aperte F5
```

Repita com `oficina-teresina`, que você mostra no fechamento. Nela ainda falta conferir jogando os critérios manuais
CA-28, CA-29, CA-33 e CA-34 das specs 003 e 004.

### 5. Ajustar os slides
- Trocar `seu-usuario` por `alexand7e` em "O repositório base" e em "Material da aula".
- O rodapé "Testados em Godot 4.7 num protótipo" (slide do código do jogo de voo) não tem protótipo no repositório:
  apresente esse código como ilustrativo.

## Durante a aula

### Bloco 4: Godot (10 min)
O que você mostra e os alunos repetem:

```bash
git clone https://github.com/alexand7e/minicurso-jogos-ia.git
cd minicurso-jogos-ia
```

1. No Godot: *Importar* e escolha `project.godot`.
2. Aperte **F5**.
3. Em `config.gd`, mude `PLAYER_SPEED` ou `TITLE`, salve e aperte F5 de novo.

### Bloco 5: SDD (15 min)

```bash
bash scripts/check.sh                    # OK: 17 verificacoes passaram.
```

### Bloco 7: Demonstração (13 min)
Faça a demonstração numa branch descartável, para a `main` continuar limpa:

```bash
git switch main
git switch -c demo-ao-vivo
```

No painel do Claude Code, um comando por vez, lendo e aprovando o resultado antes do próximo:

```
/especificar inimigos mais rápidos conforme a pontuação
/planejar
/tarefas
/implementar T1
/implementar T2
/implementar T3
```

Depois de cada `/implementar`, a IA roda o check. Se quiser mostrar você mesmo, use `bash scripts/check.sh`. No fim,
aperte F5 e jogue uns 30 s: os inimigos ficam mais rápidos.

**Plano B**, se a IA travar ou o tempo apertar. Use uma das duas formas:

```bash
# forma 1: aplicar a solução pronta
git restore . && git clean -fd specs/      # descarta o que a IA fez (só arquivos sem commit)
git apply specs/exemplos/dificuldade-progressiva/solucao.patch
bash scripts/check.sh                      # OK: 20 verificacoes passaram.

# forma 2: mostrar o ciclo já feito, um commit por etapa
git stash -u                               # guarda o que a IA fez, se houver
git switch demo/dificuldade-progressiva
git log --oneline --no-merges main..
bash scripts/check.sh                      # OK: 20 verificacoes passaram.
```

Ao terminar a demonstração, volte à `main`:

```bash
git add -A && git commit -m "Demonstração ao vivo"   # só se ainda estiver na demo-ao-vivo
git switch main
git stash drop                                       # só se usou a forma 2 e não quer o que foi guardado
```

### Bloco 8: Prática (25 min)
O que cada equipe roda:

```bash
git switch main
git switch -c equipe/<nome-da-equipe>
cp specs/templates/cartao-de-visao.md specs/cartao.md   # preencher as 5 linhas
```

Depois, no Claude Code: `/especificar <ideia do cartão>`, `/planejar`, `/tarefas` e `/implementar T1` (e as seguintes),
com `bash scripts/check.sh` e F5 ao fim de cada tarefa. Para guardar o trabalho:

```bash
git add -A && git commit -m "Equipe <nome>: <mudança>"
```

Os alunos não têm permissão para enviar ao seu repositório. Para levar o trabalho para casa, cada equipe faz um
*fork* no GitHub, ou basta o commit local.

### Bloco 9: Fechamento (10 min)
Para a retrospectiva:

```bash
cp specs/templates/retrospectiva.md specs/retrospectiva.md
```

Para mostrar até onde o método leva, feche o editor do Godot e rode:

```bash
git switch oficina-teresina
bash scripts/check.sh                    # OK: 82 verificacoes passaram.
"$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe" --path . -e   # F5: B-R-O Bró, Raul Lopes, UFPI
```

## Depois da aula

```bash
git switch main
git branch -D demo-ao-vivo               # apaga a demonstração ao vivo (só existia na sua máquina)
git status --short                       # não deve mostrar nada
```

## Se algo der errado

| Sintoma | Comando |
| --- | --- |
| `Godot nao encontrado` | `export GODOT="$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64_console.exe"` |
| `git switch` reclama de mudanças não salvas | `git stash -u` (guarda) ou `git restore . && git clean -fd specs/` (descarta) |
| O jogo abre com a arte de outra branch | Feche o editor do Godot e abra de novo depois do `git switch` |
| `FALHA: ha erros de script` | Leia a primeira linha `SCRIPT ERROR` da saída: ela aponta o arquivo e a linha |
| Quero ver em que branch estou | `git branch --show-current` |
