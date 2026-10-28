<#
.SYNOPSIS
    Escolhe uma das três versões do jogo (branches), troca para ela e abre o jogo no Godot.

.DESCRIPTION
    As três versões:
      1  main                          jogo base da aula (check: 17)
      2  demo/dificuldade-progressiva  resultado da demonstração (check: 20)
      3  oficina-teresina              exemplo avançado, tema de Teresina (check: 82)

    Sem -Versao, mostra um menu. Antes de trocar, confere se há mudanças não salvas (para não perdê-las)
    e se o Godot está aberto (ele mostraria a arte da versão anterior).

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File scripts\jogar.ps1
.EXAMPLE
    powershell -ExecutionPolicy Bypass -File scripts\jogar.ps1 -Versao teresina -Editor
.EXAMPLE
    powershell -ExecutionPolicy Bypass -File scripts\jogar.ps1 -Versao demo -Check -SemAbrir
#>
param(
    [ValidateSet("main", "demo", "teresina")]
    [string]$Versao,        # qual versão; sem isto, aparece o menu
    [switch]$Editor,        # abre o editor (F5 joga) em vez de abrir o jogo direto
    [switch]$Check,         # roda os testes (scripts/check.sh) antes de abrir
    [switch]$SemAbrir,      # não abre o Godot (útil junto com -Check)
    [switch]$FecharGodot    # fecha o Godot aberto sem perguntar
)

# "Continue": o Godot escreve avisos no stderr, e no PowerShell 5.1 isso viraria erro fatal com "Stop".
# Os erros que importam são conferidos à mão ($LASTEXITCODE e a saída dos testes).
$ErrorActionPreference = "Continue"

$versoes = [ordered]@{
    "main"     = @{ Branch = "main";                         Nome = "Jogo base da aula";                 Check = 17 }
    "demo"     = @{ Branch = "demo/dificuldade-progressiva"; Nome = "Resultado da demonstração";         Check = 20 }
    "teresina" = @{ Branch = "oficina-teresina";             Nome = "Exemplo avançado: tema de Teresina"; Check = 82 }
}

# Para tudo com uma mensagem clara.
function Sair($mensagem) {
    Write-Host ""
    Write-Host $mensagem -ForegroundColor Red
    exit 1
}

# Executável do Godot: $env:GODOT, ou o instalado em %LOCALAPPDATA%\Programs\Godot, ou "godot" no PATH.
function Achar-Godot {
    if ($env:GODOT -and (Test-Path $env:GODOT)) { return $env:GODOT }
    $pasta = Join-Path $env:LOCALAPPDATA "Programs\Godot"
    if (Test-Path $pasta) {
        $exe = Get-ChildItem $pasta -Filter "Godot_v4*_win64.exe" | Sort-Object Name -Descending | Select-Object -First 1
        if ($exe) { return $exe.FullName }
    }
    $comando = Get-Command godot -ErrorAction SilentlyContinue
    if ($comando) { return $comando.Source }
    Sair "Godot não encontrado. Defina a variável GODOT com o caminho do executável, por exemplo:`n  `$env:GODOT = `"C:\caminho\Godot_v4.7.2-stable_win64.exe`""
}

# A versão "_console.exe" mostra a saída no terminal (para importar e para os testes); a outra abre sem console.
function Godot-Console($godot) {
    $console = $godot -replace "(_console)?\.exe$", "_console.exe"
    if (Test-Path $console) { return $console }
    return $godot
}

# Raiz do repositório: a pasta acima de scripts\.
Set-Location (Split-Path -Parent $PSScriptRoot)
if (-not (Test-Path "project.godot")) { Sair "Não achei project.godot em $(Get-Location)." }

# --- 1. Escolher a versão ---
if (-not $Versao) {
    Write-Host ""
    Write-Host "Qual versão do jogo?" -ForegroundColor Cyan
    $i = 1
    foreach ($chave in $versoes.Keys) {
        $v = $versoes[$chave]
        Write-Host ("  {0}  {1,-30} {2}" -f $i, $v.Branch, $v.Nome)
        $i++
    }
    $resposta = Read-Host "Número (1, 2 ou 3)"
    $chaves = @($versoes.Keys)
    $n = 0
    if (-not [int]::TryParse($resposta, [ref]$n) -or $n -lt 1 -or $n -gt $chaves.Count) {
        Sair "Opção inválida: '$resposta'. Rode de novo e digite 1, 2 ou 3."
    }
    $Versao = $chaves[$n - 1]
}
$escolha = $versoes[$Versao]
$branch = $escolha.Branch

# --- 2. Não perder trabalho: mudanças não salvas em arquivos do repositório impedem a troca ---
$atual = (git branch --show-current)
if ($atual -ne $branch) {
    $mudancas = git status --porcelain --untracked-files=no
    if ($mudancas) {
        Write-Host "Há mudanças não salvas na branch '$atual':" -ForegroundColor Yellow
        $mudancas | ForEach-Object { Write-Host "  $_" }
        Sair "Salve com 'git add -A; git commit -m ""...""' ou guarde com 'git stash -u' e rode de novo."
    }
}

# --- 3. Godot aberto mostraria a versão anterior: fechar antes de trocar ---
$abertos = Get-Process -ErrorAction SilentlyContinue | Where-Object { $_.ProcessName -like "Godot*" }
if ($abertos) {
    $fechar = $FecharGodot
    if (-not $fechar) {
        Write-Host "O Godot está aberto. Salve o que estiver fazendo nele." -ForegroundColor Yellow
        $fechar = (Read-Host "Fechar o Godot agora? (s/n)") -match "^[sS]"
    }
    if (-not $fechar) { Sair "Feche o Godot e rode de novo." }
    $abertos | Stop-Process -Force
    Start-Sleep -Milliseconds 500
}

# --- 4. Trocar de branch (na primeira vez, o git cria a branch local a partir do GitHub) ---
if ($atual -ne $branch) {
    Write-Host "Trocando para $branch..." -ForegroundColor Cyan
    git switch $branch
    if ($LASTEXITCODE -ne 0) { Sair "Não consegui trocar para $branch (veja a mensagem do git acima)." }
}

# --- 5. Importar a arte desta versão (rápido quando já está importada) ---
$godot = Achar-Godot
$console = Godot-Console $godot
Write-Host "Importando arte e som..." -ForegroundColor Cyan
& $console --headless --path . --import *> $null

# --- 6. Testes, se pedidos ---
if ($Check) {
    Write-Host "Rodando os testes..." -ForegroundColor Cyan
    $saida = & $console --headless --path . --fixed-fps 60 -s res://tests/run_tests.gd 2>&1 | ForEach-Object { "$_" }
    $resumo = $saida | Where-Object { $_ -match "^(OK|FALHA):" }
    $erros = $saida | Where-Object { $_ -match "SCRIPT ERROR" }
    if ($erros -or -not ($resumo -match "^OK:")) {
        $saida | Select-Object -Last 30 | ForEach-Object { Write-Host "  $_" }
        Sair "Os testes falharam em $branch."
    }
    Write-Host "  $resumo (esperado: $($escolha.Check))" -ForegroundColor Green
}

# --- 7. Abrir ---
Write-Host ""
Write-Host "Versão: $branch - $($escolha.Nome)" -ForegroundColor Green
if ($SemAbrir) { exit 0 }
$argumentos = @("--path", "`"$((Get-Location).Path)`"")
if ($Editor) {
    $argumentos += "-e"
    Write-Host "Abrindo o editor do Godot. Aperte F5 para jogar."
} else {
    Write-Host "Abrindo o jogo. Para trocar de versão, feche a janela e rode este script de novo."
}
Start-Process -FilePath $godot -ArgumentList $argumentos | Out-Null
