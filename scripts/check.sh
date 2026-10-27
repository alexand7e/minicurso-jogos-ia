#!/usr/bin/env bash
# Verificação do projeto sem abrir janela: importa os recursos e roda os testes
# de aceitação (tests/run_tests.gd). Sai com código 0 se tudo passou.
#
# Uso (Linux/macOS):
#   GODOT=/caminho/do/executavel/Godot ./scripts/check.sh
# Se o comando "godot" já está no PATH, basta ./scripts/check.sh
# No Windows, veja o comando equivalente no README.

set -uo pipefail

GODOT="${GODOT:-godot}"
cd "$(dirname "$0")/.."

if ! command -v "$GODOT" >/dev/null 2>&1; then
  echo "Godot nao encontrado: '$GODOT'."
  echo "Defina a variavel GODOT com o caminho do executavel (veja o README)."
  exit 2
fi

# 1) Importa recursos (necessario na primeira vez e depois de adicionar arte ou som).
"$GODOT" --headless --path . --import >/dev/null 2>&1

# 2) Roda os testes. --fixed-fps faz o tempo do jogo andar mais rapido que o relogio.
saida=$("$GODOT" --headless --path . --fixed-fps 60 -s res://tests/run_tests.gd 2>&1)
codigo=$?
echo "$saida"

# Erros de script nem sempre mudam o codigo de saida; procura no texto tambem.
# (Os avisos "leaked at exit" que a Godot imprime ao fechar sao inofensivos e ignorados.)
if echo "$saida" | grep -Eq "SCRIPT ERROR|Parse Error"; then
  echo ""
  echo "FALHA: ha erros de script na saida acima."
  exit 1
fi

exit "$codigo"
