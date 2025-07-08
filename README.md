# LoFi Square (GUI)
> https://jeielmiranda.is-a.dev/LoFi_Square/

Esse programa é escrito em C++ [main.cpp](./main.cpp). O projeto já foi escrito em `Electronjs`, mas abandonado depois por se tornar inviável a sua criação em relação ao desempenho e espaço do usuário final. 

Agora com leveza e implementação da [WebView](https://github.com/webview/webview), voltei a criar um programa que está disponível para Linux, atualmente.

## Como fazer a compilação na máquina?

- [compila.sh](./compila.sh) ---> Esse script irá lhe auxiliar verificando dependências para compilação do programa.Se falhar, você deve instalar os pacotes necessários com `sudo apt`. Originalmente testado no AnduinOS (baseado em Ubuntu).

> [!warning]
> Você deve clonar o repositório https://github.com/webview/webview, pois o caminho `webview/core/include/webView.h` é essencial para importação para `main.cpp`.

## Donwload do programa

- [LoFiS](./LoFiS) <--- 
