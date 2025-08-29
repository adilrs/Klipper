# Correção do Erro 'Malformed command CALIBRAR_T0_REFERENCIA'

## Problema Identificado

O erro `!! Malformed command 'CALIBRAR_T0_REFERENCIA'` ocorreu devido a problemas na implementação das macros de calibração multi-ferramentas.

## Causa Raiz

1. **Complexidade excessiva**: As macros originais tentavam implementar todo o sistema de medição internamente
2. **Dependências circulares**: Referências a variáveis e macros que não estavam sendo atualizadas corretamente
3. **Sistema de detecção**: O sensor TP223 não estava sendo detectado adequadamente durante as medições

## Solução Implementada

### 1. Simplificação das Macros

**Antes:**
- Macros complexas com loops internos
- Múltiplas verificações de sensor
- Cálculos estatísticos complexos

**Depois:**
- Uso do sistema `MEDIR_DISTANCIA_BICO_TP223` já testado e funcional
- Simplificação da lógica de medição
- Foco na funcionalidade essencial

### 2. Correções Específicas

#### CALIBRAR_T0_REFERENCIA
```gcode
# ANTES: Sistema complexo com loops
{% for sample in range(config.samples) %}
    # Múltiplas verificações...
{% endfor %}

# DEPOIS: Sistema simplificado
MEDIR_DISTANCIA_BICO_TP223
{% set measured_z = printer["gcode_macro MEDIR_DISTANCIA_BICO_TP223"].last_measurement %}
```

#### MEDIR_FERRAMENTA_COMPARATIVO
```gcode
# ANTES: Implementação duplicada
# Loops e verificações complexas

# DEPOIS: Reutilização do sistema existente
MEDIR_DISTANCIA_BICO_TP223
# Cálculo direto do offset relativo
```

### 3. Melhorias no Sistema de Detecção

#### PROBE_TP223_SURFACE
- Adicionado registro automático da posição Z
- Melhor tratamento de erros
- Verificação dupla de detecção

```gcode
# Registrar posição Z atual quando sensor detecta
SET_GCODE_VARIABLE MACRO=TESTE_TP223_IND VARIABLE=trigger_z VALUE={printer.gcode_move.gcode_position.z}
```

## Arquivos Modificados

### 1. calibracao_multitools_tp223.cfg
- **CALIBRAR_T0_REFERENCIA**: Simplificada para usar MEDIR_DISTANCIA_BICO_TP223
- **MEDIR_FERRAMENTA_COMPARATIVO**: Simplificada e otimizada
- Remoção de código duplicado e complexo

### 2. calibracao_tp223_automatica.cfg
- **PROBE_TP223_SURFACE**: Melhorado registro de posição Z
- Melhor tratamento de erros de detecção

## Benefícios da Correção

1. **Estabilidade**: Macros mais simples e confiáveis
2. **Manutenibilidade**: Código mais limpo e fácil de entender
3. **Reutilização**: Aproveitamento do sistema já testado
4. **Performance**: Menos operações desnecessárias

## Como Usar Após a Correção

### Calibração Completa
```gcode
CALIBRAR_TODAS_FERRAMENTAS_COMPARATIVO
```

### Calibração Individual
```gcode
# 1. Calibrar T0 como referência
CALIBRAR_T0_REFERENCIA

# 2. Calibrar ferramentas específicas
MEDIR_FERRAMENTA_COMPARATIVO FERRAMENTA=1
MEDIR_FERRAMENTA_COMPARATIVO FERRAMENTA=2
```

### Verificar Status
```gcode
STATUS_CALIBRACAO_MULTITOOLS
```

## Teste de Funcionamento

### 1. Verificar Sensor
```gcode
TESTAR_TP223_CALIBRACAO
```

### 2. Teste Básico
```gcode
CALIBRACO_MULTITOOLS_CONFIG
CALIBRAR_T0_REFERENCIA
```

### 3. Verificar Resultados
```gcode
STATUS_CALIBRACAO_MULTITOOLS
```

## Troubleshooting

### Se ainda houver erros:

1. **Verificar GPIO 22**:
   ```gcode
   TESTE_TP223_IND
   ```

2. **Verificar configuração**:
   ```gcode
   CALIBRACAO_TP223_CONFIG
   ```

3. **Reiniciar Klipper**:
   - Salvar configuração
   - Reiniciar firmware

## Logs de Sucesso Esperados

```
🎯 ===== CALIBRAÇÃO T0 COMO REFERÊNCIA =====
🔧 T0 será usado como base para comparação
📍 Sensor TP223 no GPIO 22
📏 Iniciando medição automática com TP223...
📊 ===== RESULTADOS T0 REFERÊNCIA =====
✅ T0 calibrado: Z = -1.2500mm
📏 Amostras: 5
💾 Salvo em variables.cfg como referência
```

## Conclusão

A correção simplificou significativamente o sistema, mantendo toda a funcionalidade necessária enquanto elimina a complexidade desnecessária que causava o erro 'Malformed command'.

O sistema agora é:
- ✅ Mais estável
- ✅ Mais fácil de manter
- ✅ Mais confiável
- ✅ Compatível com o sistema existente

---
**Data da Correção**: Janeiro 2025  
**Versão**: 2.0 - Simplificada e Otimizada