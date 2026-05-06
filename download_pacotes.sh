#!/usr/bin/env bash
# =============================================================================
#  download_pacotes.sh
#
#  Execute em uma máquina Linux/Mac/WSL COM INTERNET.
#  Baixa todos os wheels necessários para instalar os notebooks
#  em Windows Python 3.13 SEM internet.
#
#  Uso:
#    chmod +x download_pacotes.sh
#    ./download_pacotes.sh
#
#  Resultado:
#    pacotes_offline_py313_win64.zip  ← copie para o Windows
# =============================================================================

set -e

PASTA="pacotes_offline_py313_win64"
ZIP="${PASTA}.zip"

echo ""
echo "============================================================"
echo "  Download de pacotes — Python 3.13 Windows x64"
echo "  numpy | pandas | matplotlib | seaborn | scikit-learn | jupyter"
echo "============================================================"
echo ""

# ── Limpa e cria pasta ────────────────────────────────────────
rm -rf "$PASTA"
mkdir -p "$PASTA/wheels"
cp requirements.txt "$PASTA/"

# ── Baixa wheels para Windows/Python 3.13 ────────────────────
echo "▶  Baixando wheels (win_amd64 / cp313)..."
echo "   O pip resolverá todas as dependências automaticamente."
echo ""

pip download \
    --dest              "$PASTA/wheels" \
    --python-version    "3.13" \
    --platform          "win_amd64" \
    --implementation    cp \
    --abi               "cp313" \
    --only-binary       :all: \
    --requirement       requirements.txt

echo ""
echo "▶  Total de arquivos baixados:"
ls "$PASTA/wheels" | wc -l

# ── Cria instalar_windows.bat ─────────────────────────────────
cat > "$PASTA/instalar_windows.bat" << 'BATEOF'
@echo off
echo.
echo ============================================================
echo   Instalador offline - Regressao Linear e SVR Notebooks
echo   Python 3.13 - Windows x64
echo ============================================================
echo.

REM ── Verifica Python 3.13 ─────────────────────────────────────
python --version 2>nul | findstr "3.13" >nul
IF ERRORLEVEL 1 (
    echo [ERRO] Python 3.13 nao encontrado no PATH.
    echo Instale em https://www.python.org/downloads/
    echo e marque "Add Python to PATH" durante a instalacao.
    pause
    exit /b 1
)
echo [OK] Python 3.13 encontrado.
echo.

REM ── Cria venv ────────────────────────────────────────────────
SET VENV=%~dp0venv_ml
IF EXIST "%VENV%" (
    echo [INFO] Ambiente virtual ja existe. Pulando criacao.
) ELSE (
    echo [1/3] Criando ambiente virtual em venv_ml...
    python -m venv "%VENV%"
    echo [OK] Ambiente virtual criado.
)
echo.

REM ── Ativa venv ───────────────────────────────────────────────
CALL "%VENV%\Scripts\activate.bat"

REM ── Atualiza pip offline ──────────────────────────────────────
echo [2/3] Atualizando pip...
python -m pip install --upgrade pip --no-index --find-links="%~dp0wheels" 2>nul || echo [AVISO] pip ja esta atualizado.
echo.

REM ── Instala pacotes offline ───────────────────────────────────
echo [3/3] Instalando pacotes offline...
echo       Aguarde, isso pode levar alguns minutos...
echo.

pip install ^
    --no-index ^
    --find-links="%~dp0wheels" ^
    --requirement="%~dp0requirements.txt"

IF ERRORLEVEL 1 (
    echo.
    echo [ERRO] Falha na instalacao. Verifique se todos os .whl estao na pasta wheels.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo   [OK] Instalacao concluida!
echo ============================================================
echo.

REM ── Cria atalhos ─────────────────────────────────────────────
(
    echo @echo off
    echo CALL "%VENV%\Scripts\activate.bat"
    echo jupyter notebook
) > "%~dp0abrir_jupyter.bat"

(
    echo @echo off
    echo CALL "%VENV%\Scripts\activate.bat"
    echo echo Ambiente ativado. Digite: jupyter notebook
    echo cmd /k
) > "%~dp0ativar_venv.bat"

echo   Atalhos criados:
echo     abrir_jupyter.bat  — abre o Jupyter direto no navegador
echo     ativar_venv.bat    — ativa o venv no terminal
echo.
pause
BATEOF

# ── Cria LEIA_ME.txt ──────────────────────────────────────────
cat > "$PASTA/LEIA_ME.txt" << 'READMEEOF'
============================================================
  PACOTE OFFLINE — Regressão Linear & SVR Notebooks
  Python 3.13 | Windows x64
============================================================

CONTEÚDO:
  wheels/              → arquivos .whl para instalação offline
  requirements.txt     → 6 pacotes principais
  instalar_windows.bat → execute este no Windows
  LEIA_ME.txt          → este arquivo

PRÉ-REQUISITO NO WINDOWS:
  Python 3.13 instalado com "Add Python to PATH" marcado.
  Download: https://www.python.org/downloads/

INSTALAÇÃO (sem internet):
  1. Extraia o .zip
  2. Botão direito em instalar_windows.bat → Executar como administrador
  3. Aguarde ~3 minutos
  4. Clique duplo em abrir_jupyter.bat

PACOTES INSTALADOS:
  numpy | pandas | matplotlib | seaborn | scikit-learn | jupyter
  (dependências resolvidas automaticamente)
READMEEOF

# ── Compacta ──────────────────────────────────────────────────
echo ""
echo "▶  Compactando em ${ZIP}..."
zip -r "$ZIP" "$PASTA/"

echo ""
echo "============================================================"
echo "  Pronto! Arquivo gerado: ${ZIP}"
echo ""
du -sh "$ZIP" 2>/dev/null || ls -lh "$ZIP"
echo ""
echo "  Transfira para o Windows e execute: instalar_windows.bat"
echo "============================================================"
echo ""
