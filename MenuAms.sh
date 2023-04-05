#!/bin/bash


# Color verde del terminal
echo -e "\033[32m"


# Función para guardar comandos
function guardar_comando {
    echo "Enter the complete command you want to save and press ENTER."
    read comando
    echo "Provide the description of the command and press the ENTER key."
    read descripcion
    echo "$comando @ $descripcion" >>/Users/$(whoami)/comandos.txt
}


function mostrar_comandos {
    # Leer el archivo de texto
    clear
    i=0
    # Gris claro
    echo -e "\033[37m"
    while read -r line; do
        # Imprimir cada línea del archivo
        echo "$((++i)). $line"
    done </Users/$(whoami)/comandos.txt

    # Color verde del terminal
    echo -e "\033[32m"
    # Preguntar al usuario qué comando desea ejecutar
    echo "What command do you want to execute?"
    echo "Write a command, ‘:q’ to finish or ´:c´ to concat value."
    while true; do
        read -e -p "\>: " opction
        # Ejecutar el comando seleccionado por el usuario
        if [ "$opction" == ":q" ]; then
            break
        elif [[ $opction =~ ^[0-9]+\ :c$ ]]; then
            optioncomb=$(echo "$opction" | cut -d ' ' -f 1)
            caden=$(sed -n "${optioncomb}p" /Users/$(whoami)/comandos.txt)
            cutcaden=$(echo "$caden" | cut -d "@" -f1)
            nospaces="${cutcaden%%*( )}"
            read -p "$nospaces" addcommand
            variable_sin_espacios="$(echo -e "${nospaces}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
            variable_sin_espaciosedit="$(echo -e "${addcommand}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
            finalcommand="$variable_sin_espacios$variable_sin_espaciosedit"
            eval "$finalcommand"
        else
            caden=$(sed -n "${opction}p" /Users/$(whoami)/comandos.txt)
            cutcaden=$(echo "$caden" | cut -d "@" -f1)
            eval "$cutcaden"
        fi
    done
}


function borrar_comandos {
    # Leer el archivo de texto
    clear
    i=0
    echo -e "\033[37m"
    while read -r line; do
        # Imprimir cada línea del archivo
        echo "$((++i)). $line"
    done </Users/$(whoami)/comandos.txt

    echo -e "\033[32m"
    # Preguntar al usuario qué comando desea ejecutar
    echo "What command do you want to delete?"
    echo "Write a command or ‘:q’ to finish."
    while true; do
        read -e -p "\>: " opctiono
        # Ejecutar el comando seleccionado por el usuario
        if [ "$opctiono" == ":q" ]; then
            break
        else
            cutcadeno=$(sed -i '' "${opctiono}d" /Users/$(whoami)/comandos.txt)
            eval "$cutcadeno"
        fi
    done
}


function lanzar_comando {
    echo "Write a command or ‘:q’ to finish."
    while true; do
        echo -e "\033[32m"
        read -e -p "\>: " COMANDO
        if [ "$COMANDO" == ":q" ]; then
            break
        else
            eval $COMANDO
        fi
    done
}


# Ciclo principal del menú
while true; do
    clear
    echo "Select an option:"
    echo "1. Save a command"
    echo "2. Show saved commands"
    echo "3. Delete saved commands"
    echo "4. Launch a command"
    echo "5. Exit"
    read opcion

    case $opcion in
    1) guardar_comando ;;
    2) mostrar_comandos ;;
    3) borrar_comandos ;;
    4) lanzar_comando ;;
    5) exit ;;
    *) echo "Wrong command" ;;
    esac
done
