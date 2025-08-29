# Configuração Sensor TP223 - Sistema Dual Probe

## Visão Geral
Este documento descreve a configuração do sensor de toque capacitivo TP223 como sensor secundário independente, mantendo o BLTouch como probe principal.

## Características do Sensor TP223

### Especificações Técnicas
- **Tipo**: Sensor de toque capacitivo digital
- **Tensão de operação**: 2.0V - 5.5V
- **Corrente de operação**: < 3µA (standby), < 60µA (ativo)
- **Saída**: Digital (HIGH/LOW)
- **Sensibilidade**: Ajustável via capacitor externo
- **Tempo de resposta**: < 220ms
- **Interface**: 3 pinos (VCC, GND, OUT)

### Vantagens
- ✅ Baixo consumo de energia
- ✅ Saída digital estável
- ✅ Não requer calibração complexa
- ✅ Imune a interferências mecânicas
- ✅ Detecção através de materiais isolantes
- ✅ Custo muito baixo

## Configuração de Hardware

### Conexões
```
TP223 Sensor    →    Raspberry Pi
─────────────────────────────────
VCC (Vermelho)  →    3.3V ou 5V
GND (Preto)     →    GND
OUT (Amarelo)   →    GPIO 22
```

### Posicionamento
- **Localização**: Próximo ao bico do extrusor
- **Distância**: 2-5mm da mesa de impressão
- **Orientação**: Face sensível voltada para baixo
- **Fixação**: Suporte rígido para evitar vibração

## Configuração de Software

### Arquivo: teste_piezo_independente.cfg
```ini
# Sensor TP223 como botão para teste independente
[gcode_button sensor_tp223_teste]
pin: ^host:gpio22                    # GPIO 22 com pullup interno
press_gcode:
    RESPOND MSG="🔍 SENSOR ATIVADO! Posição: X{printer.gcode_move.gcode_position.x} Y{printer.gcode_move.gcode_position.y} Z{printer.gcode_move.gcode_position.z}"
    SET_GCODE_VARIABLE MACRO=TESTE_TP223_IND VARIABLE=sensor_triggered VALUE=1
    SET_GCODE_VARIABLE MACRO=TESTE_TP223_IND VARIABLE=trigger_z VALUE={printer.gcode_move.gcode_position.z}
```

### Configuração do Pino
- **Pino**: `^host:gpio22` (pullup interno ativado)
- **Lógica**: HIGH = não tocado, LOW = tocado
- **Debounce**: Automático pelo TP223

## Macros de Teste Disponíveis

### 1. TESTE_TP223_IND
**Função**: Teste básico do sensor
**Uso**: `TESTE_TP223_IND`
**Descrição**: Posiciona o extrusor e aguarda detecção do sensor

### 2. RESULTADO_TESTE_TP223
**Função**: Mostra resultado do último teste
**Uso**: `RESULTADO_TESTE_TP223`
**Descrição**: Exibe posição Z de detecção e offset calculado

### 3. TESTE_PRECISAO_TP223_MANUAL
**Função**: Teste de precisão com múltiplas medições
**Uso**: `TESTE_PRECISAO_TP223_MANUAL`
**Descrição**: Inicia sequência de 10 medições para análise de precisão

### 4. REGISTRAR_MEDICAO_TP223
**Função**: Registra uma medição individual
**Uso**: `REGISTRAR_MEDICAO_TP223`
**Descrição**: Salva posição Z atual quando sensor é ativado

### 5. CALCULAR_PRECISAO_TP223
**Função**: Calcula estatísticas de precisão
**Uso**: `CALCULAR_PRECISAO_TP223`
**Descrição**: Analisa as medições coletadas

## Procedimento de Teste

### Teste Básico
1. Execute `TESTE_TP223_IND`
2. Abaixe Z manualmente até ativar o sensor
3. Execute `RESULTADO_TESTE_TP223` para ver dados

### Teste de Precisão
1. Execute `TESTE_PRECISAO_TP223_MANUAL`
2. Repita 10 vezes:
   - Abaixe Z até ativar sensor
   - Execute `REGISTRAR_MEDICAO_TP223`
   - Levante Z
3. Execute `CALCULAR_PRECISAO_TP223`

## Interpretação dos Resultados

### Precisão Esperada
- **Excelente**: Range < 0.02mm
- **Boa**: Range 0.02-0.05mm
- **Aceitável**: Range 0.05-0.10mm
- **Ruim**: Range > 0.10mm

### Fatores que Afetam a Precisão
- Vibração da estrutura
- Interferência elétrica
- Temperatura ambiente
- Umidade do ar
- Qualidade da superfície de teste

## Troubleshooting

### Sensor Não Detecta
- ✅ Verificar conexões (VCC, GND, OUT)
- ✅ Confirmar tensão de alimentação (3.3V ou 5V)
- ✅ Testar continuidade dos cabos
- ✅ Verificar se GPIO 22 está livre

### Detecção Inconsistente
- ✅ Ajustar distância do sensor (2-5mm)
- ✅ Verificar fixação rígida
- ✅ Eliminar fontes de interferência
- ✅ Limpar superfície de teste

### Falsos Positivos
- ✅ Aumentar distância do sensor
- ✅ Verificar aterramento adequado
- ✅ Adicionar filtro capacitivo se necessário

## Sistema Dual Probe

### Configuração Atual
- **Probe Principal**: BLTouch (ativo)
- **Probe Secundário**: TP223 (teste independente)
- **Conflito GPIO**: Resolvido (comentado output_pin no printer.cfg)

### Vantagens do Sistema Dual
- BLTouch para auto-leveling normal
- TP223 para calibração e testes específicos
- Redundância para diagnóstico
- Flexibilidade de configuração

## Próximos Passos

1. **Teste Físico**: Conectar TP223 e executar testes
2. **Calibração**: Ajustar offset baseado nos resultados
3. **Integração**: Considerar uso em rotinas de calibração
4. **Documentação**: Registrar resultados e ajustes

---

**Data**: $(Get-Date -Format "dd/MM/yyyy")
**Versão**: 1.0
**Status**: Configuração completa, aguardando teste físico