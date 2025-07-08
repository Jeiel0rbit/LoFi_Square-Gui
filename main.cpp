#define WEBVIEW_GTK
#include "webview.h"
#include <string>
#include <cstdlib>

// HTML embutido a partir do arquivo index_html.h
#include "index_html.h"

int main() {
    // --- Configuração da Janela ---
    
    webview::webview w(true, nullptr);
    w.set_title("LoFi Square");
    w.set_size(800, 600, WEBVIEW_HINT_NONE);

    // --- Binding C++ <-> JavaScript ---
    // Expõe a função 'abrirNavegador' para ser chamada pelo HTML.
    w.bind("abrirNavegador", [&](const std::string& args) -> std::string {
        std::string url = args.substr(2, args.length() - 4);
        std::string command = "xdg-open \"" + url + "\"";
        system(command.c_str());
        return "";
    });

    // --- Conteúdo da Webview ---
    // Carrega o HTML que foi embutido no executável.
    std::string html_content(reinterpret_cast<char*>(index_html), index_html_len);
    w.set_html(html_content);
    
    w.run();
    
    return 0;
}
