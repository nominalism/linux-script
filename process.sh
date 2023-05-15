#!/bin/bash
listProcess()
{
 ps -e > 'auxiliar.txt'
 dialog --title 'Processos' --textbox auxiliar.txt 0 0 
 > 'auxiliar.txt'
}

showPID()
{
  name=$(dialog --stdout --title 'Buscar PID' --inputbox 'Informe o processo do qual se deseja o pid:' 0 0)
  pid=$(pidof $name)
  
  dialog --stdout --title 'Buscar PID' --msgbox "Os pids vinculados ao processo $name são: \n$pid" 0 0
}


stopName()
{
processo=$(dialog --inputbox "Digite o nome do processo:" 8 50 --output-fd 1)
pids=$(pgrep "$processo")
if [[ -z "$pids" ]]; then
  dialog --title "Erro" --msgbox "Não foi possível encontrar o processo \"$processo\"" 8 50
  exit 1
fi
dialog --title "Pausar processo" --yesno "Deseja pausar o processo \"$processo\" (PIDs: $pids)?" 8 50

if [[ $? == 0 ]]; 
then
  for pid in $pids; do
    kill -STOP "$pid"
  done
  dialog --title "Processo pausado" --msgbox "O processo \"$processo\" (PIDs: $pids) foi pausado com sucesso." 8 50
fi
}


stopPID()
{
  PID=$(dialog --stdout --title 'Pausar Processo - PID' --inputbox 'Informe o PID do processo que deseja pausar:' 0 0)

ps -f --pid $PID > /dev/null
if [ $? == 1 ]
then
    dialog --msgbox "processo inválido" 8 40
  else
dialog --stdout --title 'SUCESSO!' --msgbox 'Processo Pausado!' 0 0
kill -STOP $PID
  fi
}

continueName()
{
processo=$(dialog --inputbox "Digite o nome do processo:" 8 50 --output-fd 1)
pids=$(pgrep "$processo")
if [[ -z "$pids" ]]; 
then
  dialog --title "Erro" --msgbox "Não foi possível encontrar o processo \"$processo\"" 8 50
  exit 1
fi
dialog --title "Pausar processo" --yesno "Deseja despausar o processo \"$processo\" (PIDs: $pids)?" 8 50

if [[ $? == 0 ]]; 
then
  for pid in $pids; do
    kill -CONT "$pid"
  done
  dialog --title "Processo despausado" --msgbox "O processo \"$processo\" (PIDs: $pids) foi despausado com sucesso." 8 50
fi

}

continuePID()
{
  PID=$(dialog --stdout --title 'Continuar Processo - PID' --inputbox 'Informe o PID do processo que deseja continuar:' 0 0)

ps -f --pid $PID > /dev/null
if [ $? == 1 ]
then
    dialog --msgbox "processo inválido" 8 40
  else
dialog --stdout --title 'SUCESSO!' --msgbox 'Processo despausado!' 0 0
kill -CONT $PID
  fi
}

finishName()
{
 processo=$(dialog --inputbox "Digite o nome do processo:" 8 50 --output-fd 1)
pids=$(pgrep "$processo")
if [[ -z "$pids" ]]; then
  dialog --title "Erro" --msgbox "Não foi possível encontrar o processo \"$processo\"" 8 50
  exit 1
fi
dialog --title "Parar processo" --yesno "Deseja parar o processo \"$processo\" (PIDs: $pids)?" 8 50

if [[ $? == 0 ]]; 
then
  for pid in $pids; do
    kill -TERM "$pid"
  done
  dialog --title "Processo parado" --msgbox "O processo \"$processo\" (PIDs: $pids) foi parado com sucesso." 8 50
fi
}

finishPID()
{

  PID=$(dialog --stdout --title 'Pausar terminado - PID' --inputbox 'Informe o PID do processo que deseja terminar:' 0 0)

ps -f --pid $PID > /dev/null
if [ $? == 1 ]
then
    dialog --msgbox "processo inválido" 8 40
  else
dialog --stdout --title 'SUCESSO!' --msgbox 'Processo terminado!' 0 0
kill -TERM $PID
  fi

}

killName()
{
processo=$(dialog --inputbox "Digite o nome do processo:" 8 50 --output-fd 1)
pids=$(pgrep "$processo")
if [[ -z "$pids" ]]; then
  dialog --title "Erro" --msgbox "Não foi possível encontrar o processo \"$processo\"" 8 50
  exit 1
fi
dialog --title "Matar processo" --yesno "Deseja matar o processo \"$processo\" (PIDs: $pids)?" 8 50

if [[ $? == 0 ]]; 
then
  for pid in $pids; do
    kill -KILL "$pid"
  done
  dialog --title "Processo morto" --msgbox "O processo \"$processo\" (PIDs: $pids) foi morto com sucesso." 8 50
fi
}

killPID()
{
{
  PID=$(dialog --stdout --title 'Matar Processo - PID' --inputbox 'Informe o PID do processo que deseja matar:' 0 0)

ps -f --pid $PID > /dev/null
if [ $? == 1 ]
then
    dialog --msgbox "processo inválido" 8 40
  else
dialog --stdout --title 'SUCESSO!' --msgbox 'Processo morto!' 0 0
kill -KILL $PID
  fi
}
}

startPriority()
{
processo=$(dialog --inputbox "Digite o nome do processo:" 8 50 --output-fd 1)
prioridade=$(dialog --inputbox "Digite a prioridade do processo (-20 a 19):" 8 50 --output-fd 1)
if [[ $prioridade -lt -20 || $prioridade -gt 19 ]]; then
  dialog --title "Erro" --msgbox "A prioridade deve estar entre -20 e 19." 8 50
  exit 1
fi
nice -n "$prioridade" "$processo" &
dialog --title "Processo criado" --msgbox "O processo \"$processo\" foi criado com a prioridade $prioridade." 8 50

}

priority()
{
  PID=$(dialog --stdout --title 'Alterar Prioridade' --inputbox 'Informe o PID do processo que deseja alterar:' 0 0)
  priority=$(dialog --stdout --title 'Alterar Prioridade' --inputbox 'Informe sua prioridade de execução(20 a -20):' 0 0)
ps -f --pid $PID > /dev/null
if [ $? == 1 ]
then
    dialog --msgbox "processo inválido" 8 40
    else
dialog --stdout --title 'SUCESSO!' --msgbox 'Prioridade Alterada!' 0 0
renice $priority $PID
  fi
}


help()
{
  dialog --stdout --title 'Ajuda' --msgbox "DESENVOLVIDO POR: Gabriel Rosaes De Souza & Leonardo Rodrigues Cavalcante\n\n DISCIPLINA: Sistemas Operacionais" 8 80
}

treeProcess()
{
pid=$(dialog --stdout --title 'Ver arvore processo' --inputbox 'Informe o PID do processo que deseja ver a árvore:' 0 0)

if ! id -u $pid > /dev/null 2>&1; then
    dialog --msgbox "processo inválido" 8 40
fi
pstree -p $pid | dialog --programbox "Árvore de processos do PID $pid" 40 80
}
treeUser()
{
user=$(dialog --stdout --title 'Ver arvore usuário' --inputbox 'Informe o nome do usuario que deseja ver a árvore:' 0 0)
if ! id -u $user > /dev/null 2>&1; then
    dialog --msgbox "Usuário inválido" 8 40
fi
pstree -u -h $user | dialog --programbox "Árvore de processos do usuário $user" 40 80
}

threads(){
pid=$(dialog --stdout --title 'Ver thread do processo' --inputbox 'Informe o PID do processo que deseja ver as threads:' 0 0)

if ! ps -p $pid > /dev/null 2>&1; then
    dialog --msgbox "PID inválido" 8 40
 
fi

threads=$(ps -L -p $pid)

dialog --title "Threads do processo $pid" --msgbox "$threads" 0 0
}

killMouse()
{
processes=$(ps -eo pid,comm)

pid=$(dialog --title "Processos em execução" --stdout --menu "Selecione o processo a ser morto:" 0 0 0 $processes)

if [[ -n "$pid" ]]; then
    dialog --yesno "Deseja realmente matar o processo $pid?" 0 0
    if [[ $? -eq 0 ]]; then
        kill -9 $pid
        dialog --msgbox "Processo $pid morto" 0 0
    fi
fi
}
Exit(){

dialog --msgbox "Até logo!" 0 0

dialog --title "Fechar terminal?" --yesno "Deseja fechar o terminal?" 0 0

if [[ $? -eq 0 ]]; then
    exit
fi
}
while [ op != 18 ]
do
op=$( dialog --stdout --help-button --no-cancel --menu 'Gerenciador de Tarefas' 0 0 0 1 'Mostrar os processos' 2 'Mostrar o PID' 3 'Parar a execução - NOME' 4 'Parar a execução - PID' 5 'Continuar a execução - NOME' 6 'Continuar a execução - PID' 7 'Terminar a execução - NOME' 8 'Terminar a execução - PID' 9 'Matar um processo - NOME' 10 'Matar um processo - PID' 11 'Criar um processo em 2º Plano' 12 'Mudar a prioridade' 13 'Mostrar a árvore criada por um processo' 14 'Mostrar árvore de processo de um usuario' 15 'Mostrar todos as threads criadas por um processo' 16 'Matar um programa em execução' 17 'Sair')
[ $? -ne 0 ] && help
case $op in
1) listProcess;; 
2) showPID;;
3) stopName;;
4) stopPID;;
5) continueName;;
6) continuePID;;
7) finishName;;
8) finishPID;;
9) killName;;
10) killPID;;
11) startPriority;;
12) priority;;
13) treeProcess;;
14) treeUser;;
15) threads;;
16) killMouse;;
17) Exit;;
esac 
done
