# Plano 000: Como o jogo base é construído

> Mapa para quem (pessoa ou IA) vai mexer no código pela primeira vez.

## Estrutura de cenas

```
Main (main.gd)
├── ColorRect            fundo, cor vem de Config.BACKGROUND_COLOR
├── Player (player.gd)   Area2D; emite o sinal "hit" ao tocar em um inimigo
├── MobTimer             a cada MOB_SPAWN_INTERVAL chama _on_MobTimer_timeout (cria um inimigo)
├── ScoreTimer           a cada 1 s chama _on_ScoreTimer_timeout (soma pontos)
├── StartTimer           uma vez, após START_DELAY, liga MobTimer e ScoreTimer
├── StartPosition        ponto onde o jogador começa
├── MobPath / MobSpawnLocation   caminho nas bordas da tela onde os inimigos nascem
├── HUD (hud.gd)         pontuação, mensagens e botão de jogar
├── Music / DeathSound   áudio
```

Inimigos são instâncias de `mob.tscn` (`RigidBody2D`, grupo `mobs`) adicionadas como filhas de `Main`.

## Fluxo de uma partida

1. Botão "Jogar" no HUD emite `start_game`, que chama `Main.new_game()`.
2. `new_game()` remove inimigos antigos, zera a pontuação, posiciona o jogador e inicia o `StartTimer`.
3. Quando `StartTimer` termina, `MobTimer` e `ScoreTimer` começam.
4. O jogador toca em um inimigo, o sinal `hit` chama `Main.game_over()`, que para os timers e a música, toca o som e mostra o fim de jogo.

## Onde mexer para...

| Quero mudar | Arquivo |
| --- | --- |
| Números, textos e cores | `config.gd` |
| Regras da partida (pontos, nascimento de inimigos, fim) | `main.gd` |
| Movimento do jogador | `player.gd` |
| Comportamento de cada inimigo | `mob.gd` |
| Interface | `hud.gd` e `hud.tscn` |

## Como cada critério é verificado
Veja a coluna "Verificado em" de `spec.md`; os testes estão em `tests/run_tests.gd`.
