#!/bin/bash
 
# Função para extrair informações básicas do site
extract_basic_info() {
    echo "---- Informações Básicas ----"
    # Título do site
    title=$(curl -s $1 | grep -oP '(?<=<title>).*?(?=</title>)' | head -1)
    echo "Título do site: $title"
    
    # Servidor web
    server=$(curl -s -I $1 | grep -i 'Server' | awk '{print $2}')
    echo "Servidor web: $server"
    
    # Linguagem de programação (pode ser uma estimativa)
    language=$(curl -s $1 | grep -io 'x-powered-by:.*' | sed 's/.*: //')
    echo "Linguagem de programação: $language"
}
 
# Função para extrair URLs do site
extract_urls() {
    echo "---- URLs do Site ----"
    urls=$(curl -s $1 | grep -oP 'href="\K[^"]+' | grep -E '^(http|https)://' | sort -u)
    echo "$urls"
}
 
# Função para extrair formulários e inputs de texto
extract_forms() {
    echo "---- Formulários e Inputs de Texto ----"
    forms=$(curl -s $1 | grep -o '<form[^>]*>.*</form>' | sed 's/<\/form>//g')
    echo "$forms"
}
 
# URL padrão
default_url="http://example.com"
 
# Verificar se foi passada uma URL como parâmetro
if [ -z "$1" ]; then
    echo "Nenhuma URL fornecida. Usando a URL padrão: $default_url"
    url=$default_url
else
    url=$1
fi
 
# Executar as funções
extract_basic_info $url
extract_urls $url
extract_forms $url