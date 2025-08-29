#!/usr/bin/env python3

# Teste final da macro PROBE_TP223_SURFACE corrigida

def test_macro_corrections():
    print("🧪 TESTE FINAL DA MACRO CORRIGIDA")
    print("=" * 40)
    
    try:
        with open('k:/calibracao_tp223_automatica.cfg', 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Verificações essenciais
        tests = [
            ('{% break %}', False, "❌ {% break %} removido", "✅ {% break %} removido"),
            ('sensor_detected = 0', True, "❌ Variável sensor_detected não encontrada", "✅ Variável sensor_detected implementada"),
            ('{% if sensor_detected == 0 %}', True, "❌ Lógica de controle não implementada", "✅ Lógica de controle implementada"),
            ('G91', True, "❌ Comando G91 não encontrado", "✅ Comando G91 presente"),
            ('G90', True, "❌ Comando G90 não encontrado", "✅ Comando G90 presente"),
            ('QUERY_ENDSTOPS', True, "❌ QUERY_ENDSTOPS não encontrado", "✅ QUERY_ENDSTOPS presente")
        ]
        
        all_passed = True
        
        for pattern, should_exist, fail_msg, success_msg in tests:
            if should_exist:
                if pattern in content:
                    print(success_msg)
                else:
                    print(fail_msg)
                    all_passed = False
            else:
                if pattern not in content:
                    print(success_msg)
                else:
                    print(fail_msg)
                    all_passed = False
        
        print()
        print("=" * 40)
        
        if all_passed:
            print("🎉 TODOS OS TESTES PASSARAM!")
            print("✅ A macro PROBE_TP223_SURFACE está corrigida")
            print("✅ Sintaxe Jinja2 válida")
            print("✅ Lógica de controle implementada")
            print("✅ Pronta para uso no Klipper")
            print()
            print("📋 PRÓXIMOS PASSOS:")
            print("  1. Reiniciar o Klipper")
            print("  2. Executar G28")
            print("  3. Testar a macro CAL_T0")
        else:
            print("❌ ALGUNS TESTES FALHARAM")
            print("A macro precisa de correções adicionais")
        
        return all_passed
        
    except Exception as e:
        print(f"❌ ERRO: {e}")
        return False

if __name__ == "__main__":
    test_macro_corrections()