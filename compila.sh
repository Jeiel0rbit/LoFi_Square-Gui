#!/usr/bin/env bash

# Verifica dependências, embuti o HTML e compila o código C++.

# --- Configuração ---
# Para o script ao encontrar qualquer erro.
set -e

# Nome do arquivo de saída
readonly OUTPUT_NAME="LoFiS"

# Arquivos fonte
readonly SRC_CPP="main.cpp"
readonly SRC_HTML="index.html"
readonly HTML_HEADER="index_html.h"

# Dependências de biblioteca para o pkg-config
readonly REQUIRED_LIBS="webkit2gtk-4.1"

# Cores para as mensagens
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m' # Sem Cor

# --- Funções Auxiliares ---

# Função para verificar se um comando existe no sistema
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}Erro: O comando '$1' não foi encontrado.${NC}"
        echo -e "${YELLOW}Por favor, instale-o para continuar.${NC}"
        exit 1
    fi
}

# Função para verificar se uma biblioteca de desenvolvimento está disponível via pkg-config
check_pkg_lib() {
    if ! pkg-config --exists "$1"; then
        echo -e "${RED}Erro: A biblioteca de desenvolvimento para '$1' não foi encontrada.${NC}"
        echo -e "${YELLOW}Por favor, instale o pacote correspondente. Em Ubuntu/Debian, pode ser 'libwebkit2gtk-4.1-dev'.${NC}"
        exit 1
    fi
}

# --- Lógica Principal do Script ---

echo -e "${GREEN}--- Iniciando o processo de compilação para '$OUTPUT_NAME' ---${NC}"

# 1. Verificação de Dependências do Sistema
echo -e "\n${YELLOW}[1/4] Verificando dependências do sistema...${NC}"
check_command "g++"
check_command "pkg-config"
check_command "xxd"
check_pkg_lib "$REQUIRED_LIBS"
echo "Dependências do sistema OK."

# 2. Verificação dos Arquivos de Projeto
echo -e "\n${YELLOW}[2/4] Verificando arquivos de projeto...${NC}"
if [ ! -f "$SRC_CPP" ]; then
    echo -e "${RED}Erro: Arquivo principal '$SRC_CPP' não encontrado.${NC}"
    exit 1
fi
if [ ! -f "$SRC_HTML" ]; then
    echo -e "${RED}Erro: Arquivo HTML '$SRC_HTML' não encontrado.${NC}"
    exit 1
fi
if [ ! -d "webview/core/include" ]; then
    echo -e "${RED}Erro: Diretório da biblioteca webview não encontrado em 'webview/core/include'.${NC}"
    exit 1
fi
echo "Arquivos de projeto OK."

# 3. Embutindo o arquivo HTML
echo -e "\n${YELLOW}[3/4] Embutindo '$SRC_HTML' no código C++...${NC}"
xxd -i "$SRC_HTML" > "$HTML_HEADER"
echo "HTML embutido com sucesso em '$HTML_HEADER'."

# 4. Compilação
echo -e "\n${YELLOW}[4/4] Compilando o projeto...${NC}"

# Constrói as flags do compilador a partir do pkg-config
COMPILE_FLAGS=$(pkg-config --cflags --libs "$REQUIRED_LIBS")

# Exibe o comando final para transparência
echo "Comando: g++ -Iwebview/core/include -std=c++17 $SRC_CPP -o $OUTPUT_NAME $COMPILE_FLAGS"

# Executa a compilação
g++ -Iwebview/core/include -std=c++17 "$SRC_CPP" -o "$OUTPUT_NAME" $COMPILE_FLAGS

echo -e "\n${GREEN}--- Compilação concluída com sucesso! ---${NC}"
echo -e "Execute seu programa com: ${YELLOW}./$OUTPUT_NAME${NC}"
