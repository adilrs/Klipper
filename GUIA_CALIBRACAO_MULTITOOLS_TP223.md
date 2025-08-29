# Guia de Uso - Sistema de Calibração Multi-Ferramentas TP223

## Visão Geral
Sistema automático para calibração de múltiplas ferramentas usando o sensor TP223 como referência. O T0 é usado como ferramenta de referência base, e T1-T3 são calibrados comparativamente.

## Comandos Principais

### 1. Configuração Inicial
```gcode
CALIBRACO_MULTITOOLS_CONFIG
```
- Define parâmetros de calibração
- Configura posições e velocidades
- Ativa ferramentas disponíveis

### 2. Calibração Completa (Recomendado)
```gcode
CALIBRAR_TODAS_FERRAMENTAS_COMPARATIVO
```
**Sequência automática:**
1. G28 com T0
2. Calibra T0 como referência
3. Mede T1, T2, T3 comparativamente
4. Salva todos os offsets em variables.cfg

### 3. Calibração Individual

#### Calibrar T0 (Referência)
```gcode
CALIBRAR_T0_REFERENCIA
```

#### Calibrar Ferramenta Específica
```gcode
MEDIR_FERRAMENTA_COMPARATIVO FERRAMENTA=1  # Para T1
MEDIR_FERRAMENTA_COMPARATIVO FERRAMENTA=2  # Para T2
MEDIR_FERRAMENTA_COMPARATIVO FERRAMENTA=3  # Para T3
```

### 4. Diagnóstico e Status

#### Verificar Status
```gcode
STATUS_CALIBRACAO_MULTITOOLS
```

#### Testar Sistema
```gcode
TESTAR_SISTEMA_MULTITOOLS
```

### 5. Gerenciamento T3

#### Ativar T3
```gcode
ATIVAR_T3
```

#### Desativar T3
```gcode
DESATIVAR_T3
```

## Procedimento Recomendado

### Primeira Configuração
1. **Verificar sensor TP223:**
   ```gcode
   TESTAR_TP223_CALIBRACAO
   ```

2. **Configurar sistema:**
   ```gcode
   CALIBRACAO_MULTITOOLS_CONFIG
   ```

3. **Calibração completa:**
   ```gcode
   CALIBRAR_TODAS_FERRAMENTAS_COMPARATIVO
   ```

### Recalibração Rápida
```gcode
CALIBRAR_TODAS_FERRAMENTAS_COMPARATIVO
```

### Calibração de Uma Ferramenta
1. **Garantir T0 calibrado:**
   ```gcode
   CALIBRAR_T0_REFERENCIA
   ```

2. **Calibrar ferramenta específica:**
   ```gcode
   MEDIR_FERRAMENTA_COMPARATIVO FERRAMENTA=2
   ```

## Configurações Avançadas

### Parâmetros Ajustáveis
- `config.tp223_probe_x`: Posição X do sensor (padrão: 150)
- `config.tp223_probe_y`: Posição Y do sensor (padrão: 150)
- `config.probe_speed`: Velocidade de sondagem (padrão: 5)
- `config.probe_samples`: Número de amostras (padrão: 5)
- `config.sample_tolerance`: Tolerância entre amostras (padrão: 0.01)

### Modificar Configurações
```gcode
CALIBRACO_MULTITOOLS_CONFIG PROBE_SPEED=3 SAMPLES=7
```

## Interpretação de Resultados

### Valores Salvos em variables.cfg
- `calibration_ref_z`: Posição Z de referência do T0
- `tool_0_offset_z`: Offset Z do T0 (igual à referência)
- `tool_1_offset_z`: Offset Z do T1 (relativo ao T0)
- `tool_2_offset_z`: Offset Z do T2 (relativo ao T0)
- `tool_3_offset_z`: Offset Z do T3 (relativo ao T0)

### Exemplo de Resultados
```
T0 (referência): Z = -1.2500
T1: offset = -1.1800 (diferença: +0.0700)
T2: offset = -1.3200 (diferença: -0.0700)
T3: offset = -1.2450 (diferença: +0.0050)
```

## Troubleshooting

### Erro: "Sensor TP223 não detectado"
- Verificar conexão GPIO 22
- Testar com `TESTAR_TP223_CALIBRACAO`

### Erro: "Precisão insuficiente"
- Aumentar número de amostras
- Verificar estabilidade mecânica
- Reduzir velocidade de sondagem

### Erro: "Ferramenta não encontrada"
- Verificar se a ferramenta está definida
- Para T3: usar `ATIVAR_T3` primeiro

### Valores Inconsistentes
- Recalibrar T0 primeiro
- Verificar limpeza do sensor
- Verificar temperatura estável

## Integração com Sistema Existente

### Arquivos Relacionados
- `calibracao_multitools_tp223.cfg`: Sistema principal
- `calibracao_tp223_automatica.cfg`: Funções base TP223
- `variables.cfg`: Armazenamento de offsets
- `printer.cfg`: Configuração principal

### Compatibilidade
- Funciona com sistema dual probe existente
- Mantém compatibilidade com calibração manual
- Integra-se com sistema de inicialização de ferramentas

## Comandos de Emergência

### Parar Calibração
```gcode
M112  # Parada de emergência
```

### Reset de Configuração
```gcode
CALIBRACO_MULTITOOLS_CONFIG  # Restaura padrões
```

## Dicas de Uso

1. **Sempre calibre T0 primeiro** - é a referência para todas as outras
2. **Mantenha temperatura estável** durante a calibração
3. **Limpe o sensor** antes de calibrações importantes
4. **Use CALIBRAR_TODAS_FERRAMENTAS_COMPARATIVO** para máxima precisão
5. **Verifique resultados** com STATUS_CALIBRACAO_MULTITOOLS
6. **T3 fica desativado por padrão** - ative apenas se necessário

## Sequência Típica de Uso

```gcode
# 1. Configuração inicial
CALIBRACO_MULTITOOLS_CONFIG

# 2. Calibração completa
CALIBRAR_TODAS_FERRAMENTAS_COMPARATIVO

# 3. Verificar resultados
STATUS_CALIBRACAO_MULTITOOLS

# 4. Aplicar offsets (automático)
# Os offsets são aplicados automaticamente pelo sistema
```

---
**Nota:** Este sistema substitui a necessidade de calibração manual individual de cada ferramenta, automatizando todo o processo e garantindo consistência entre as medições.