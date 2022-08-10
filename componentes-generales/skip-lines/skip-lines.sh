#!/bin/bash
# Skip lines from a file
# Removes first N lines from a file

############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Divide archivo CSV archivos con N lineas cada uno."
   echo
   echo "Syntax: split-csv-into-files.sh archivo [-n|d|p|s|h]"
   echo "options:"
   echo "-n     Number of lines for each file. Default: 10.000"
   echo "-h     Print this Help."
   echo
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################


# Procesa opciones y argumentos
# Ref: https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -s|--skip-lines)
        lines_to_skip="$2"
        shift # past argument
        shift # past value
        ;;
    -h|--help)
      Help
      exit
      ;;

    -*|--*)
      echo "Unknown option $1"
      Help
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

if [[ $# -eq 0 ]] ; then
    echo 'Error: No file specified'
    Help
    exit
fi

INPUT="$1"
N_LINEAS="${lines_per_file:=10000}"
if [[ "$INPUT" -eq 0 ]]; then
    # No hay lineas por remover
    exit
fi
tail -n +$((lines_to_skip+1)) "$INPUT" > "$INPUT".tmp
mv "$INPUT".tmp "$INPUT"

