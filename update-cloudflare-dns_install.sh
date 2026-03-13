#!/bin/bash

# ==========================================
# Variáveis de Configuração
# ==========================================

# URL "Raw" do script no GitHub
URL_GITHUB="https://raw.githubusercontent.com/rsecbr/repo/main/update-cloudflare-dns.sh"

# Diretório onde o script será salvo (certifique-se de ter permissão de escrita)
DIRETORIO_DESTINO="/app"

# Nome que o arquivo terá após o download
NOME_DO_ARQUIVO="update-cloudflare-dns.sh"

# Caminho completo do arquivo
CAMINHO_COMPLETO="$DIRETORIO_DESTINO/$NOME_DO_ARQUIVO"

# Expressão do cron (Exemplo: "0 2 * * *" para rodar todos os dias às 2h da manhã)
AGENDAMENTO_CRON="0/5 * * * *" 

# ==========================================
# Execução
# ==========================================

# 1. Prepara o diretório de destino
mkdir -p "$DIRETORIO_DESTINO"

# 2. Faz o download do script
echo "Baixando o script de: $URL_GITHUB..."
# O parâmetro -sS oculta o progresso, mas mostra erros. O -L segue redirecionamentos.
curl -sSL "$URL_GITHUB" -o "$CAMINHO_COMPLETO"

# Verifica se o download foi bem-sucedido
if [ $? -ne 0 ]; then
    echo "Erro: Falha ao baixar o script. Verifique a URL e a sua conexão de rede."
    exit 1
fi

# 3. Torna o arquivo executável
echo "Aplicando permissões de execução..."
chmod +x "$CAMINHO_COMPLETO"

# 4. Adiciona ao crontab
echo "Configurando o agendamento no crontab..."

# Cria o comando exato que deve constar no cron
COMANDO_CRON="$AGENDAMENTO_CRON $CAMINHO_COMPLETO"

# Lista o crontab atual (ignorando erros se estiver vazio), 
# remove qualquer linha antiga que aponte para o mesmo script, 
# adiciona a nova linha e salva de volta no crontab.
(crontab -l 2>/dev/null | grep -F -v "$CAMINHO_COMPLETO"; echo "$COMANDO_CRON") | crontab -

echo "Processo concluído com sucesso!"
echo "O script foi salvo em: $CAMINHO_COMPLETO"
echo "O agendamento atual do seu usuário agora é:"
crontab -l
