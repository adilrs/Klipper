# 🔧 GUIA DO SISTEMA DUAL PROBE INTEGRADO

## 📋 VISÃO GERAL

O sistema dual probe foi integrado às **macros existentes** do seu sistema de toolchanger, aproveitando toda a infraestrutura já desenvolvida. Não foram criadas novas macros - apenas adaptadas as existentes para usar o sensor piezoelétrico quando apropriado.

## 🎯 ESTRATÉGIA IMPLEMENTADA

### ✅ **APROVEITAMENTO DAS MACROS EXISTENTES**
- **BLTouch (T0)**: Continua como probe principal para homing, mesh e referência
- **Sensor Piezoelétrico**: Conectado ao pino GPIO22 do host (pino físico 15), integrado para calibração de offsets das ferramentas T1-T3
- **Macros Adaptadas**: `CALIBRAR_TOOL_INDIVIDUAL`, `CALIBRACAO_RAPIDA_TOOL`
- **Nova Macro de Suporte**: `PROBE_PIEZO_POINT` (compatível com sistema existente)

## 🔧 **Configuração Implementada**

### **Sistema de Troca Dinâmica de Probe**
- **USE_PIEZO_PROBE**: Alterna para sensor piezoelétrico (GPIO22)
- **USE_BLTOUCH_PROBE**: Alterna para BLTouch (padrão)
- **PROBE_STATE**: Monitora probe ativo atual
- Troca automática durante calibrações baseada na ferramenta

### **⚠️ Configuração Necessária no printer.cfg**
```ini
# Adicionar configuração de output_pin para controle dinâmico
[output_pin probe_pin]
pin: host:gpio22  # Pino do sensor piezoelétrico no host (pino físico 15)
value: 0
shutdown_value: 0
```

### 🔄 **FUNCIONAMENTO AUTOMÁTICO**
```
T0 (Referência) → BLTouch → Medição de referência
T1, T2, T3     → Sensor Piezoelétrico → Cálculo de offsets
```

## 🚀 COMANDOS PRINCIPAIS

### 📊 **CALIBRAÇÃO COMPLETA** (Recomendado)
```gcode
CALIBRACO_COMPLETA
```
- Usa automaticamente BLTouch para T0 e piezo para T1-T3
- Aquecimento, nivelamento, bed mesh e calibração de offsets
- Relatório completo e salvamento automático

### ⚡ **CALIBRAÇÃO RÁPIDA**
```gcode
CALIBRACO_RAPIDA
```
- Calibração rápida de todas as ferramentas
- Usa sistema dual automaticamente
- Ideal para uso diário

### 🔧 **CALIBRAÇÃO INDIVIDUAL**
```gcode
CALIBRAR_TOOL_INDIVIDUAL TOOL=1  # Para T1
CALIBRAR_TOOL_INDIVIDUAL TOOL=2  # Para T2
CALIBRAR_TOOL_INDIVIDUAL TOOL=3  # Para T3
```

### 📈 **VERIFICAÇÃO DE STATUS**
```gcode
STATUS_DUAL_PROBE        # Status do sistema dual
RELATORIO_CALIBRACAO     # Relatório de offsets
STATUS_CALIBRACAO        # Status geral
```

## 🔍 **MACROS ADAPTADAS**

### 1. **CALIBRAR_TOOL_INDIVIDUAL**
- **T0**: Usa BLTouch em 5 pontos para estabelecer referência
- **T1-T3**: Usa troca dinâmica para piezoelétrico (USE_PIEZO_PROBE) nos mesmos 5 pontos
- **Cálculo**: Offset automático relativo ao T0
- **Salvamento**: Integrado com `variables.cfg`

### 2. **CALIBRACAO_RAPIDA_TOOL**
- **T0**: Medição central com BLTouch
- **T1-T3**: Medição central com troca dinâmica para piezoelétrico (USE_PIEZO_PROBE)
- **Posicionamento**: Automático para cada sensor

### 3. **PROBE_PIEZO_POINT** (Nova)
- **Função**: Medição pontual compatível com sistema existente
- **Integração**: Funciona como `PROBE` mas com sensor piezoelétrico
- **Resultado**: Salva em `PIEZO_STATE.trigger_position`

## 📍 **CONFIGURAÇÃO DE POSIÇÕES**

### 🎯 **Posições dos Sensores**
```
BLTouch (T0):           X=130, Y=100 (posição atual)
Sensor Piezoelétrico:   X=150, Y=150 (configurável)
```

### ⚙️ **Ajustar Posição do Sensor Piezoelétrico**
Edite em `CONFIGURACAO_DUAL_PROBE_SISTEMA.cfg`:
```gcode
G1 X150 Y150 F6000  # Altere X e Y conforme sua instalação
```

## 🔧 **FLUXO DE CALIBRAÇÃO AUTOMÁTICA**

### 📋 **Sequência Completa**
1. **Homing**: G28 com BLTouch
2. **Aquecimento**: Mesa + extrusores
3. **Nivelamento**: Z_TILT_ADJUST com BLTouch
4. **Bed Mesh**: BED_MESH_CALIBRATE com BLTouch
5. **Referência T0**: 5 pontos com BLTouch
6. **Calibração T1**: 5 pontos com sensor piezoelétrico
7. **Calibração T2**: 5 pontos com sensor piezoelétrico
8. **Calibração T3**: 5 pontos com sensor piezoelétrico
9. **Cálculo**: Offsets automáticos relativos ao T0
10. **Salvamento**: `variables.cfg` + `SAVE_CONFIG`

### 📊 **Pontos de Medição** (5 pontos para precisão)
```
Ponto 1: X=50,  Y=50   (Canto inferior esquerdo)
Ponto 2: X=230, Y=50   (Canto inferior direito)
Ponto 3: X=140, Y=100  (Centro)
Ponto 4: X=50,  Y=130  (Canto superior esquerdo)
Ponto 5: X=230, Y=130  (Canto superior direito)
```

## 🧪 **TESTES E VERIFICAÇÃO**

### 🔍 **Teste Completo do Sistema**
```gcode
TESTAR_SISTEMA_DUAL
```
- Testa BLTouch e sensor piezoelétrico
- Verifica precisão de ambos
- Relatório de funcionamento

### 📊 **Verificar Precisão**
```gcode
PROBE_ACCURACY          # Precisão do BLTouch
piezo_accuracy          # Precisão do sensor piezoelétrico
```

### 🔧 **Verificar Offsets Atuais**
```gcode
STATUS_DUAL_PROBE
```
Exibe:
- Status do BLTouch
- Status do sensor piezoelétrico
- Offsets de todas as ferramentas
- Última calibração

## ⚠️ **CONSIDERAÇÕES IMPORTANTES**

### 🎯 **Precisão**
- **BLTouch**: ±0.01mm (referência)
- **Sensor Piezoelétrico**: ±0.05mm (estimado)
- **Tolerância**: Offsets > 0.5mm geram aviso

### 🔄 **Compatibilidade**
- **100% compatível** com sistema existente
- **Sem alterações** nas macros de impressão
- **Integração transparente** com KlipperScreen

### 💾 **Salvamento**
- **Automático**: `variables.cfg` atualizado
- **Manual**: `SAVE_CONFIG` para persistir
- **Backup**: Use `BACKUP_CALIBRACOES_MULTI`

## 🚨 **SOLUÇÃO DE PROBLEMAS**

### ❌ **Sensor Piezoelétrico Não Responde**
```gcode
QUERY_PIEZO             # Verificar status
piezo_accuracy SAMPLES=3 # Testar precisão
```

### ❌ **Offsets Inconsistentes**
```gcode
RESET_TOOL_OFFSETS      # Resetar offsets
CALIBRACO_COMPLETA      # Recalibrar tudo
```

### ❌ **Erro de Posicionamento**
- Verificar posições em `CONFIGURACAO_DUAL_PROBE_SISTEMA.cfg`
- Ajustar coordenadas X/Y dos sensores
- Verificar altura Z segura

## 📚 **COMANDOS DE AJUDA**

```gcode
HELP_DUAL_PROBE         # Ajuda completa do sistema
INFO_CALIBRACAO_MULTI   # Informações de calibração
AJUDA_CALIBRACAO_INDEPENDENTE # Ajuda do sistema independente
```

## 🎉 **VANTAGENS DA INTEGRAÇÃO**

✅ **Aproveitamento Total**: Todas as macros existentes funcionam
✅ **Transparência**: Sistema funciona automaticamente
✅ **Precisão**: BLTouch para referência, piezo para offsets
✅ **Velocidade**: Calibração mais rápida que método manual
✅ **Confiabilidade**: Múltiplas amostras e verificações
✅ **Compatibilidade**: 100% compatível com KlipperScreen

---

**💡 DICA**: Execute `CALIBRACAO_COMPLETA` após qualquer manutenção das ferramentas para garantir precisão máxima!