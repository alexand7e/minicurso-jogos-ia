# Plano 001: Dificuldade progressiva

## Abordagem
Extrair o cálculo da velocidade para uma função pura `mob_speed_range(points)` em `main.gd`, que devolve a faixa
(mínima, máxima) para uma pontuação. Assim dá para testar sem esperar a partida rodar, e a regra fica em um só lugar.
Os dois valores novos entram em `config.gd`, como manda a constituição.

## Arquivos afetados
| Arquivo | O que muda |
| --- | --- |
| `config.gd` | `MOB_SPEED_GAIN_PER_POINT := 2.0` (px/s por ponto; 0 desliga) e `MOB_SPEED_CAP := 600.0` (px/s) |
| `main.gd` | Nova função `mob_speed_range(points)`; `_on_MobTimer_timeout` passa a usá-la com a pontuação atual |
| `tests/run_tests.gd` | Novo grupo `_test_ca05_a_07_dificuldade_progressiva` |

## Como cada critério será verificado
| CA | Verificação |
| --- | --- |
| CA-05 | `mob_speed_range(0)` devolve exatamente a faixa base |
| CA-06 | `mob_speed_range(10)` devolve a faixa base somada de 10 x `MOB_SPEED_GAIN_PER_POINT` nas duas pontas |
| CA-07 | `mob_speed_range(100000)` não passa de `MOB_SPEED_CAP` em nenhuma ponta |
| CA-08 | Manual: jogar cerca de 30 s e comparar com o começo |

## Riscos e decisões
- **Por ponto, não por tempo**: a pontuação já sobe com o tempo (1 por segundo), então o efeito é parecido, mas fica fácil de testar sem esperar.
- **Teto absoluto**: sem teto, depois de poucos minutos os inimigos cruzariam a tela rápido demais para qualquer reação humana.
- Risco baixo: `main.gd` ganha uma função e muda uma linha; nenhuma cena é editada.
