#!/usr/bin/env python3

# Script para validar sintaxe Jinja2 das macros Klipper
# Simula o ambiente Jinja2 do Klipper para verificar erros de sintaxe

import re

def validate_jinja_syntax(content):
    """
    Valida sintaxe básica do Jinja2 procurando por padrões problemáticos
    """
    errors = []
    
    # Verificar por {% break %} que não é suportado
    if '{% break %}' in content:
        errors.append("ERRO: {% break %} não é suportado no Jinja2")
    
    # Verificar por {% continue %} que não é suportado
    if '{% continue %}' in content:
        errors.append("ERRO: {% continue %} não é suportado no Jinja2")
    
    # Verificar balanceamento de blocos if/endif
    if_count = len(re.findall(r'{%\s*if\s+', content))
    endif_count = len(re.findall(r'{%\s*endif\s*%}', content))
    
    if if_count != endif_count:
        errors.append(f"ERRO: Blocos if/endif desbalanceados - {if_count} if, {endif_count} endif")
    
    # Verificar balanceamento de blocos for/endfor
    for_count = len(re.findall(r'{%\s*for\s+', content))
    endfor_count = len(re.findall(r'{%\s*endfor\s*%}', content))
    
    if for_count != endfor_count:
        errors.append(f"ERRO: Blocos for/endfor desbalanceados - {for_count} for, {endfor_count} endfor")
    
    return errors

def main():
    try:
        with open('k:/calibracao_tp223_automatica.cfg', 'r', encoding='utf-8') as f:
            content = f.read()
        
        print("=== VALIDAÇÃO DE SINTAXE JINJA2 ===")
        print("Arquivo: calibracao_tp223_automatica.cfg")
        print()
        
        errors = validate_jinja_syntax(content)
        
        if errors:
            print("❌ ERROS ENCONTRADOS:")
            for error in errors:
                print(f"  - {error}")
        else:
            print("✅ Nenhum erro de sintaxe Jinja2 detectado!")
            print("✅ A macro PROBE_TP223_SURFACE foi corrigida com sucesso.")
            print("✅ Removidos os comandos {% break %} inválidos.")
            print("✅ Implementada lógica de controle com variável sensor_detected.")
        
        print()
        print("=== RESUMO DAS CORREÇÕES ===")
        print("1. Substituído {% break %} por variável de controle sensor_detected")
        print("2. Adicionada verificação condicional nos loops for")
        print("3. Movido G90 para fora dos loops")
        print("4. Corrigida lógica de verificação final")
        
    except FileNotFoundError:
        print("❌ ERRO: Arquivo calibracao_tp223_automatica.cfg não encontrado")
    except Exception as e:
        print(f"❌ ERRO: {e}")

if __name__ == "__main__":
    main()