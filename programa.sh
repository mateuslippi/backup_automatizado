#!/usr/bin/env bash
#
# backuptar.sh - Automatização de backup com tar.gz
#
# Autor:      Mateus Lippi
# Manutenção: Mateus Lippi
#
# ------------------------------------------------------------------------ #
#  Este programa irá realizar o backup compactado e comprimido de um local origem
#  x local destino. obs: Deverá ser especificado no arquivo de configuração
#  o diretório origem e o diretório destino.
#
#  Exemplos:
#      $ ./backuptar.sh
#      executará o backup compactado e comprimido
# ------------------------------------------------------------------------ #
# Histórico:
#
#   v1.0 02/11/2022, Mateus:
# ------------------------------------------------------------------------ #
# Testado em:
#   bash 5.1.16(1)-release
# ----------------------------------VARIÁVEIS----------------------------------#
ARQUIVO_CONFIGURACAO="config.cf"
DIR_ORIGEM=
DIR_DESTINO=
BKP_NAME=/backup_$(date +%d-%m_%H%M).tgz
# ----------------------------------TESTES-------------------------------------#
[ $UID -ne 0 ] && echo "Necessita de privilégios root para a execução." \
&& exit 1

[ ! -r "$ARQUIVO_CONFIGURACAO" ] && echo                  \
"Não temos acesso de leitura ao arquivo de configuração." \
&& exit 1
# ----------------------------------FUNÇÕES------------------------------------#
Backup() {
  echo -e "Iniciando o backup do \e[35;1m${DIR_ORIGEM}\e[0m para o \e[35;1m${DIR_DESTINO}\e[0m";
  tar -czvpf ${DIR_DESTINO}${BKP_NAME} ${DIR_ORIGEM} \
  | tee /var/log/backup/backup_$(date +%d-%m_%H%M).log 2>&1

  echo -e "\e[35;1mBackup do ${DIR_ORIGEM} para o ${DIR_DESTINO} foi finalizado.\e[0m"
  exit 0
}

DefinirParametros () {
  local parametro="$(echo $1 | cut -d = -f 1)"
  local valor="$(echo $1 | cut -d = -f 2)"
  case "$parametro" in
    DIR_ORIGEM) DIR_ORIGEM="$valor"   ;;
    DIR_DESTINO) DIR_DESTINO="$valor" ;;
  esac
}
#----------------------------------EXECUÇÃO-----------------------------------#
while read -r p; do
  [ "$(echo $p | cut -c1)" = "#" ] && continue
  [ ! "$p" ] && continue
  DefinirParametros "$p"
done < "$ARQUIVO_CONFIGURACAO"

#echo -e "${DIR_DESTINO}${BKP_NAME}"
Backup
