""" pytest para script skip_lines.sh """

from pathlib import Path
import pytest
import subprocess
import tempfile


ROOT_DIR = subprocess.check_output('git rev-parse --show-toplevel'.split()).decode().strip()
SCRIPT = Path(ROOT_DIR, 'scripts/skip-lines/skip-lines.sh')

@pytest.fixture
def data_csv():
    """ Datos csv"""
    
    data = [['a','b']
            ,['1','2']
            ,['3','4']
            ,['5','6']
            ,['7','8']
            ,['9','10']]
    
    return data


def test_skip_lines_0_lines(data_csv):  
    lineas_esperadas_archivo = [ a+','+b+'\n' for a,b in data_csv ]
    with tempfile.TemporaryDirectory() as d:
        with open(f'{d}/data.csv', 'w') as f:
            for line in lineas_esperadas_archivo:
                f.write(line)

        archivo = Path(d, 'data.csv')
        result = subprocess.run(f'{SCRIPT} {archivo}'.split(), stdout=subprocess.PIPE)
        assert result.returncode == 0

        # Lee contenido archivo final
        with open(f'{d}/data.csv', 'r') as f:
            lines = f.readlines()
            assert lines == lineas_esperadas_archivo

@pytest.mark.parametrize( 'skip_lines', [0,1,2] )
def test_skip_lines_1_lines(data_csv, skip_lines):  
    lineas_esperadas_archivo = [ a+','+b+'\n' for a,b in data_csv ]
    with tempfile.TemporaryDirectory() as d:
        with open(f'{d}/data.csv', 'w') as f:
            for line in lineas_esperadas_archivo:
                f.write(line)

        archivo = Path(d, 'data.csv')
        result = subprocess.run(f'{SCRIPT} {archivo} -s {skip_lines}'.split(), stdout=subprocess.PIPE)
        assert result.returncode == 0

        # Lee contenido archivo final
        with open(f'{d}/data.csv', 'r') as f:
            lines = f.readlines()
            assert lines == lineas_esperadas_archivo[skip_lines:]



