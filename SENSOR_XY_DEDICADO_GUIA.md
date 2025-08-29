# Guia do Sensor XY Dedicado para Calibração Automática

## Visão Geral

O sensor XY dedicado é uma solução avançada para detecção de offsets X e Y que oferece maior confiabilidade e precisão em comparação com métodos tradicionais. Este sistema utiliza um sensor piezoelétrico independente do sensor Z, eliminando interferências e melhorando a consistência das medições.

## Vantagens do Sensor Dedicado

### 🎯 **Maior Confiabilidade**
- **Independência do bico**: Não depende da limpeza do bico da impressora
- **Detecção consistente**: Sensor dedicado elimina variações causadas por resíduos
- **Menor interferência**: Separação física do sistema de nivelamento Z

### 📊 **Precisão Aprimorada**
- **Passos menores**: Varredura com incrementos de 0.3mm (vs 0.5mm tradicional)
- **Velocidade otimizada**: 200mm/min para maior precisão
- **Posicionamento específico**: Altura dedicada para detecção XY

### 🔧 **Facilidade de Manutenção**
- **Diagnóstico independente**: Testes específicos para o sensor XY
- **Configuração flexível**: Habilitação/desabilitação via software
- **Fallback automático**: Retorna ao método tradicional se necessário

## Configuração do Hardware

### Componentes Necessários

1. **Sensor Piezoelétrico Adicional**
   - Sensor piezoelétrico de alta sensibilidade
   - Cabo blindado para conexão
   - Suporte de montagem ajustável

2. **Conexão Elétrica**
   - Pino GPIO disponível (padrão: PA1)
   - Resistor pull-up interno habilitado
   - Isolamento adequado do sensor Z

3. **Posicionamento Físico**
   - Montagem lateral ou frontal do hotend
   - Altura ajustável (padrão: 10mm)
   - Acesso livre para varredura XY

### Instalação do Sensor

```bash
# 1. Conectar o sensor ao pino PA1 (ou outro disponível)
# 2. Configurar no printer.cfg:

[probe_xy]
pin: ^PA1
x_offset: 0
y_offset: 0
z_offset: 0
speed: 5
samples: 1
sample_retract_dist: 2.0
```

## Configuração do Software

### Configuração Inicial

```gcode
# Configurar sistema com sensor XY dedicado
CALIBRACO_AUTO_CONFIG XY_SENSOR_ENABLED=1 XY_SENSOR_Z=10.0

# Definir posição física do sensor
CALIBRAR_POSICAO_SENSOR_XY X=150 Y=150 Z=10

# Testar funcionamento
TESTAR_SENSOR_XY
```

### Sistema de Salvamento

O sensor XY dedicado utiliza o novo sistema de salvamento em `variables.cfg`:

**Vantagens do novo sistema:**
- ✅ Offsets persistem entre reinicializações
- ✅ Independente do sistema tool_data
- ✅ Consistente com offset Z
- ✅ Facilita backup e restauração
- ✅ Detecção automática de ferramentas não calibradas

**Variáveis salvas automaticamente:**
```
tool_offset_x_extruder = 0.123     # Offset X da ferramenta
tool_offset_y_extruder = -0.045    # Offset Y da ferramenta
tool_extruder_xy_calibrated = 1    # Status de calibração
```

### Parâmetros de Configuração

| Parâmetro | Descrição | Valor Padrão |
|-----------|-----------|-------------|
| `XY_SENSOR_ENABLED` | Habilita sensor dedicado | `True` |
| `XY_SENSOR_Z` | Altura de operação do sensor | `10.0mm` |
| `X_SWEEP_DIST` | Distância de varredura X | `8.0mm` |
| `Y_SWEEP_DIST` | Distância de varredura Y | `8.0mm` |
| `XY_PROBE_SPEED` | Velocidade de sondagem | `200mm/min` |

## Comandos Disponíveis

### Comandos de Teste

| Comando | Descrição |
|---------|----------|
| `TESTAR_SENSOR_XY` | Testa funcionamento do sensor XY |
| `DIAGNOSTICO_SISTEMA_XY` | Diagnóstico completo do sistema |
| `CALIBRAR_POSICAO_SENSOR_XY` | Define posição física do sensor |
| `PROBE_XY_DEDICATED` | Sondagem com sensor dedicado |

### Comandos de Calibração

| Comando | Descrição |
|---------|----------|
| `CALIBRAR_OFFSET_X_AUTO` | Calibração X (automática com sensor) |
| `CALIBRAR_OFFSET_Y_AUTO` | Calibração Y (automática com sensor) |
| `VARRER_LATERAL_X_DEDICADO` | Varredura X com sensor dedicado |
| `VARRER_LATERAL_Y_DEDICADO` | Varredura Y com sensor dedicado |

## Procedimento de Calibração

### 1. Verificação Inicial

```gcode
# Verificar status do sistema
DIAGNOSTICO_SISTEMA_XY

# Resultado esperado:
# 📊 Configurações atuais:
#    • Sensor XY: Habilitado
#    • Distância varredura X: 8.0mm
#    • Distância varredura Y: 8.0mm
# ✅ Diagnóstico concluído. Sensor: INATIVO
```

### 2. Calibração Automática

```gcode
# Calibração completa XYZ
CALIBRAR_XYZ_AUTO

# Ou calibração individual:
CALIBRAR_OFFSET_X_AUTO TOOL=extruder
CALIBRAR_OFFSET_Y_AUTO TOOL=extruder
CALIBRAR_OFFSET_Z_AUTO TOOL=extruder
```

### 3. Verificação dos Resultados

```gcode
# Exibir offsets aplicados
EXIBIR_OFFSETS_XYZ

# Status compacto
OFFSET_ATUAL
```

## Solução de Problemas

### Sensor XY Não Detecta Contato

**Sintomas:**
- Mensagem: "⚠️ Nenhum contato XY detectado durante varredura"
- Varredura completa sem detecção

**Soluções:**
1. Verificar conexão elétrica do sensor
2. Ajustar altura do sensor (`XY_SENSOR_Z`)
3. Verificar posicionamento físico
4. Testar com `TESTAR_SENSOR_XY`

### Sensor Sempre Ativo

**Sintomas:**
- Sensor sempre retorna estado "ATIVADO"
- Detecção imediata sem movimento

**Soluções:**
1. Verificar interferência elétrica
2. Ajustar sensibilidade do sensor
3. Verificar isolamento do cabo
4. Revisar configuração do pino

### Fallback para Sensor Z

**Sintomas:**
- Sistema usa automaticamente sensor Z tradicional
- Mensagem sobre sensor XY desabilitado

**Soluções:**
1. Reabilitar sensor XY: `CALIBRACAO_AUTO_CONFIG XY_SENSOR_ENABLED=1`
2. Verificar configuração do hardware
3. Executar diagnóstico completo

## Manutenção

### Verificação Periódica

```gcode
# Teste semanal recomendado
DIAGNOSTICO_SISTEMA_XY
TESTAR_SENSOR_XY
```

### Limpeza do Sensor

1. **Desligar a impressora**
2. **Limpar suavemente** a superfície do sensor
3. **Verificar conexões** elétricas
4. **Testar funcionamento** após limpeza

### Calibração de Posição

```gcode
# Recalibrar posição se necessário
CALIBRAR_POSICAO_SENSOR_XY X=150 Y=150 Z=10
```

## Comparação: Sensor Dedicado vs Tradicional

| Aspecto | Sensor Dedicado | Método Tradicional |
|---------|----------------|--------------------|
| **Confiabilidade** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Precisão** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Velocidade** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Complexidade** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Custo** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Manutenção** | ⭐⭐⭐⭐ | ⭐⭐ |

## Suporte e Recursos

### Arquivos de Configuração
- `calibracao_automatica_toque.cfg` - Configuração principal
- `GUIA_IMPLEMENTACAO_CALIBRACAO_AUTO.md` - Guia geral
- `INSTALACAO_PINO_ACO_SENSOR.md` - Método tradicional

### Comandos de Debug
```gcode
# Informações detalhadas do sistema
DIAGNOSTICO_SISTEMA_XY

# Estado atual dos sensores
QUERY_PROBE      # Sensor Z
QUERY_PROBE_XY   # Sensor XY

# Configurações salvas
SAVE_VARIABLES   # Visualizar todas as variáveis
```

---

**Nota**: Este sistema representa uma evolução significativa na precisão e confiabilidade da calibração automática de offsets XY, oferecendo uma solução robusta para impressoras 3D profissionais e entusiastas que buscam a máxima qualidade de impressão.