#!/bin/bash
# Divide archivo CSV archivos con N lineas cada uno (excepto el último archivo)


INPUT=tokyo_medal.tsv


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
   echo "-d     Destination directory. It is created if it does not exists. Default: actual directory"
   echo "-p     Output file prefix. Default: part_"
   echo "-s     Skip first s lines. Default: 0"
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
    -n|--number-of-lines)
        lines_per_file="$2"
        shift # past argument
        shift # past value
        ;;
    -p|--output-file-prefix)
        output_file_prefix="$2"
        shift # past argument
        shift # past value
        ;;
    -d|--destination-dir)
        output_dir="$2"
        shift # past argument
        shift # past value
        ;;
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
    Help
    exit
fi





INPUT="$1"
DIR_ACTUAL=`pwd`
DIR_SALIDA="${output_dir:=$DIR_ACTUAL}"
PREFIJO="${output_file_prefix:=part_}"
N_LINEAS="${lines_per_file:=10000}"
LINES_TO_SKIP="${lines_to_skip:=0}"

echo "INPUT: $INPUT"
echo "DIR_ACTUAL: $DIR_ACTUAL"
echo "DIR_SALIDA: $DIR_SALIDA"
echo "PREFIJO: $PREFIJO"
echo "N_LINEAS: $N_LINEAS"
echo "LINES_TO_SKIP: $LINES_TO_SKIP"

echo "Creo DIR_SALIDA"
mkdir -p $DIR_SALIDA
# Elimino archivos del tipo solicitado prexistentes
rm -rf $DIR_SALIDA/$PREFIJO*






# Referencia: https://www.baeldung.com/linux/split-file-with-header
# Step 1: split the input file without the header line
tail -n +$((LINES_TO_SKIP+2)) "$INPUT" | split -d -l $lines_per_file - $DIR_SALIDA/$PREFIJO

# Agrega extensión a nombre de archivos
for f in $DIR_SALIDA/$PREFIJO* ; do 
  mv "$f" "$f.csv"
done

# Step 2: add the header line to each split file
for file in $DIR_SALIDA/$PREFIJO*
do
    head -n $((LINES_TO_SKIP+1)) "$INPUT" | tail -n 1  > with_header_tmp
    cat "$file" >> with_header_tmp
    mv -f with_header_tmp "$file"
done
