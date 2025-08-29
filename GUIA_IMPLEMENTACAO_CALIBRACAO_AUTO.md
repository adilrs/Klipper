# 🤖 Sistema de Calibração Automática XYZ por Toque

## 📋 Visão Geral

Este sistema permite calibração automática dos offsets XYZ completos de todas as ferramentas sem intervenção do usuário, usando um sensor de toque para detectar o contato do bico com uma superfície de referência e realizar calibração 3D completa.

## 🔧 Hardware Necessário

### Opção 1: Sensor Capacitivo (Recomendado)
- **Modelo**: LJ12A3-4-Z/BX ou similar
- **Tensão**: 6-36V DC
- **Distância**: 4mm
- **Saída**: NPN NO (Normalmente Aberto)
- **Vantagens**: Sem contato físico, alta precisão, durabilidade

### Opção 2: Sensor Piezoelétrico
- **Modelo**: Sensor de pressão piezoelétrico
- **Sensibilidade**: Ajustável
- **Vantagens**: Detecta força mínima, muito preciso

### Opção 3: Microswitch de Precisão
- **Modelo**: Omron SS-5GL ou similar
- **Força de acionamento**: 0.25N
- **Vantagens**: Baixo custo, fácil implementação

## 🏗️ Implementação Física

### Montagem do Sensor

```
┌─────────────────────────────────────┐
│              OPÇÃO A                │
│        Sensor no Cabeçote           │
│                                     │
│    [Bico] ← → [Sensor]             │
│      ↓           ↓                  │
│  ┌─────────────────────┐            │
│  │  Superfície Ref.    │            │
│  └─────────────────────┘            │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│              OPÇÃO B                │
│      Superfície Instrumentada       │
│                                     │
│         [Bico]                      │
│           ↓                         │
│  ┌─────────────────────┐            │
│  │ [Sensor] Superfície │            │
│  └─────────────────────┘            │
└─────────────────────────────────────┘
```

### Posicionamento da Superfície de Referência

- **Localização**: Próximo ao eixo de elevação (X100, Y310)
- **Material**: Alumínio ou aço (para sensor capacitivo)
- **Tamanho**: Mínimo 50x50mm
- **Altura**: Ajustável, aproximadamente Z=2-5mm
- **Fixação**: Parafusos ou ímãs para remoção fácil

## ⚡ Conexão Elétrica

### Esquema de Ligação

```
Sensor Capacitivo LJ12A3-4-Z/BX:
┌─────────────┐    ┌─────────────┐
│   Sensor    │    │   Klipper   │
│             │    │             │
│ Marrom (+)  ├────┤ +12V/24V    │
│ Azul   (-)  ├────┤ GND         │
│ Preto (OUT) ├────┤ PC4 (^)     │
└─────────────┘    └─────────────┘
```

### Configuração no Klipper

```ini
# Adicionar ao printer.cfg
[probe touch_sensor]
pin: ^PC4                    # Pin com pullup
x_offset: 0
y_offset: 0
z_offset: 0
speed: 5
samples: 3
sample_retract_dist: 2.0
samples_tolerance: 0.02
```

## 🚀 Procedimento de Instalação

### Passo 1: Instalação Física
1. Monte o sensor próximo ao bico ou na superfície
2. Instale a superfície de referência na mesa
3. Conecte os cabos conforme esquema
4. Verifique fixação e alinhamento

### Passo 2: Configuração Software
1. Adicione as configurações ao `printer.cfg`
2. Inclua o arquivo `calibracao_automatica_toque.cfg`
3. Reinicie o Klipper
4. Execute `TESTAR_SENSOR_TOQUE`

### Passo 3: Calibração Inicial
1. Aqueça as ferramentas: `M104 S180 T0`
2. Execute homing: `G28`
3. Teste uma ferramenta: `CALIBRAR_AUTO_FERRAMENTA TOOL=0`
4. Verifique resultado: `STATUS_CALIBRACAO_INDEPENDENTE`

### Passo 4: Calibração Completa
1. Execute: `CALIBRAR_AUTO_TODAS_FERRAMENTAS`
2. Aguarde conclusão (5-10 minutos)
3. Verifique offsets salvos
4. Teste troca de ferramentas

## 📊 Comandos Disponíveis

### Configuração Inicial

#### Para Sensor XY Dedicado (Recomendado)
```gcode
# Habilitar sensor XY dedicado
CALIBRACO_AUTO_CONFIG XY_SENSOR_ENABLED=1 XY_SENSOR_Z=10.0

# Configurar parâmetros de varredura
CALIBRACO_AUTO_CONFIG X_SWEEP_DIST=8.0 Y_SWEEP_DIST=8.0

# Definir posições de referência
CALIBRACO_AUTO_CONFIG REF_X=150 REF_Y=150 REF_Z=20

# Ajustar velocidades (otimizadas para sensor dedicado)
CALIBRACO_AUTO_CONFIG XY_PROBE_SPEED=200 Z_PROBE_SPEED=150

# Calibrar posição física do sensor XY
CALIBRAR_POSICAO_SENSOR_XY X=150 Y=150 Z=10

# Testar funcionamento
TESTAR_SENSOR_XY
```

#### Para Pino de Aço (Método Tradicional)
```gcode
# Desabilitar sensor XY dedicado (usar método tradicional)
CALIBRACO_AUTO_CONFIG XY_SENSOR_ENABLED=0

# Configurar sistema de calibração XYZ com pino de aço
CALIBRACO_AUTO_CONFIG X=100 Y=310 Z=5 SPEED=300 TOLERANCE=0.02 XY_ENABLED=True PIN_HEIGHT=3.0 X_SWEEP_DIST=15.0 Y_SWEEP_DIST=15.0 XY_SPEED=300
```

## Sistema de Salvamento de Offsets

### Migração para variables.cfg

O sistema agora salva os offsets XY em `variables.cfg` ao invés de `tool_data`, seguindo o mesmo padrão do offset Z:

**Vantagens:**
- ✅ Persistência entre reinicializações
- ✅ Independência do sistema tool_data
- ✅ Consistência com offset Z
- ✅ Facilita backup e restauração
- ✅ Melhor organização dos dados

**Variáveis salvas em variables.cfg:**
```
tool_offset_x_extruder = 0.123
tool_offset_y_extruder = -0.045
tool_offset_z_extruder = 0.678
tool_extruder_xy_calibrated = 1

tool_offset_x_extruder1 = -0.234
tool_offset_y_extruder1 = 0.156
tool_offset_z_extruder1 = -0.089
tool_extruder1_xy_calibrated = 1
```

### Carregamento Automático

Os offsets são carregados automaticamente:

1. **Na inicialização:** `INICIALIZAR_OFFSETS_XY`
2. **No START_PRINT:** `AUTO_CARREGAR_OFFSETS`
3. **Na troca de ferramenta:** `DETECTAR_MUDANCA_FERRAMENTA`

### Comandos de Gerenciamento

```gcode
# Carregar offsets de uma ferramenta específica
CARREGAR_OFFSETS_XY TOOL=extruder1

# Verificar se ferramenta precisa calibração
VERIFICAR_CALIBRACAO_XY TOOL=extruder

# Limpar dados de calibração
LIMPAR_CALIBRACAO_XY TOOL=extruder2

# Verificar mudança de ferramenta
VERIFICAR_MUDANCA_FERRAMENTA
```

## Fluxo de Calibração Automática

### Quando Calibrar

A calibração é necessária apenas quando:
- ✅ **Nova ferramenta instalada**
- ✅ **Troca de bico/hotend**
- ✅ **Manutenção do sistema**
- ✅ **Problemas de precisão detectados**

### Processo Automático

1. **Detecção de Necessidade:**
   ```gcode
   VERIFICAR_CALIBRACAO_XY TOOL=extruder
   ```

2. **Calibração Completa XYZ:**
   ```gcode
   CALIBRAR_XYZ_AUTO_COMPLETO TOOL=extruder
   ```

3. **Salvamento Automático:**
   - Offsets salvos em `variables.cfg`
   - Ferramenta marcada como calibrada
   - Aplicação imediata dos offsets

4. **Verificação:**
   ```gcode
   EXIBIR_OFFSETS_XYZ
   ```

### Integração com START_PRINT

Adicione ao seu START_PRINT:
```gcode
[gcode_macro START_PRINT]
gcode:
    # ... outras configurações ...
    
    # Carregar offsets automaticamente
    AUTO_CARREGAR_OFFSETS
    
    # ... resto do código ...
```

### Troca Automática de Ferramentas

O sistema detecta automaticamente trocas de ferramenta:
- Comandos T0, T1, T2, T3 interceptados
- Offsets aplicados automaticamente
- Verificação de calibração
- Alertas se ferramenta não calibrada

### Instalação do Pino de Aço
```
🔧 HARDWARE NECESSÁRIO:
• Pino de aço inoxidável: 3mm altura, 0.5-1mm diâmetro
• Soldagem no sensor piezoelétrico (lateral)
• Verificação de continuidade elétrica

📖 Guia detalhado: INSTALACAO_PINO_ACO_SENSOR.md
```

## 🔧 Opções de Hardware para Detecção XY

### Opção 1: Sensor XY Dedicado (Recomendado)

**Vantagens:**
- ✅ Maior confiabilidade (independente da limpeza do bico)
- ✅ Precisão aprimorada (passos de 0.3mm)
- ✅ Diagnóstico independente
- ✅ Fallback automático para método tradicional

**Hardware Necessário:**
- Sensor piezoelétrico adicional
- Cabo blindado
- Suporte de montagem ajustável
- Pino GPIO disponível (ex: PA1)

**📖 Guia Completo**: Consulte `SENSOR_XY_DEDICADO_GUIA.md` para instruções detalhadas.

### Opção 2: Pino de Aço no Sensor Existente

**Hardware Necessário:**
- Pino de aço fino (0.5-1.0mm de diâmetro)
- Solda e ferro de solda
- Multímetro para teste de continuidade

**Procedimento:**
1. **Preparação**: Limpar a superfície do sensor piezoelétrico
2. **Posicionamento**: Fixar o pino perpendicular ao sensor
3. **Soldagem**: Soldar o pino garantindo contato elétrico
4. **Teste**: Verificar continuidade elétrica

**📖 Guia Detalhado**: Consulte `INSTALACAO_PINO_ACO_SENSOR.md` para instruções completas.

### Calibração Individual Z
```
CALIBRAR_AUTO_FERRAMENTA TOOL=extruder
```

### Calibração Individual X
```
CALIBRAR_OFFSET_X_AUTO TOOL=extruder
```

### Calibração Individual Y
```
CALIBRAR_OFFSET_Y_AUTO TOOL=extruder
```

### Calibração XYZ Completa
```
CALIBRAR_XYZ_AUTO_COMPLETO TOOL=extruder
```

### Calibração Todas as Ferramentas XYZ
```
CALIBRAR_TODAS_FERRAMENTAS_XYZ
```

### Calibração Completa Z (Legado)
```
CALIBRAR_AUTO_TODAS_FERRAMENTAS
```

### Exibição de Offsets
```gcode
# Exibir todos os offsets XYZ
EXIBIR_OFFSETS_XYZ

# Exibir offset da ferramenta atual (compacto)
OFFSET_ATUAL

# Status para Fluidd
STATUS_OFFSETS
```

### Diagnóstico
```
TESTAR_SENSOR_TOQUE
```

### Comandos Principais
| Comando | Descrição |
|---------|----------|
| `CALIBRACAO_AUTO_CONFIG` | Configura posição do sensor e opções XYZ |
| `CALIBRAR_AUTO_FERRAMENTA` | Calibra offset Z de uma ferramenta |
| `CALIBRAR_OFFSET_X_AUTO` | Calibra offset X de uma ferramenta |
| `CALIBRAR_OFFSET_Y_AUTO` | Calibra offset Y de uma ferramenta |
| `CALIBRAR_XYZ_AUTO_COMPLETO` | Calibra offsets XYZ completos de uma ferramenta |
| `CALIBRAR_TODAS_FERRAMENTAS_XYZ` | Calibra XYZ de todas as ferramentas |
| `CALIBRAR_AUTO_TODAS_FERRAMENTAS` | Calibra Z de todas as ferramentas (legado) |

### Comandos de Exibição
| Comando | Descrição |
|---------|----------|
| `EXIBIR_OFFSETS_XYZ` | Exibe todos os offsets XYZ aplicados (detalhado) |
| `OFFSET_ATUAL` | Exibe offset XYZ da ferramenta atual (compacto) |
| `STATUS_OFFSETS` | Status dos offsets para integração com Fluidd |

### Comandos do Sensor XY Dedicado
| Comando | Descrição |
|---------|----------|
| `TESTAR_SENSOR_XY` | Testar sensor XY dedicado |
| `DIAGNOSTICO_SISTEMA_XY` | Diagnóstico completo XY |
| `CALIBRAR_POSICAO_SENSOR_XY` | Definir posição do sensor |
| `VARRER_LATERAL_X_DEDICADO` | Varredura X com sensor dedicado |
| `VARRER_LATERAL_Y_DEDICADO` | Varredura Y com sensor dedicado |

### Comandos de Diagnóstico
| Comando | Descrição |
|---------|----------|
| `TESTAR_SENSOR_TOQUE` | Testa funcionamento do sensor |
| `PROBE_TOUCH_SURFACE` | Sondagem manual |

## 🎯 Precisão Esperada

- **Repetibilidade**: ±0.01mm (sensor capacitivo)
- **Precisão absoluta**: ±0.02mm
- **Tempo por ferramenta**: 1-2 minutos
- **Tolerância configurável**: 0.02mm (padrão)

## 🔍 Solução de Problemas

### Sensor Não Detecta Contato
- Verificar conexões elétricas
- Testar continuidade dos cabos
- Verificar tensão de alimentação
- Ajustar distância do sensor

### Medições Inconsistentes
- Verificar vibração da mesa
- Limpar superfície de referência
- Verificar temperatura estável
- Ajustar velocidade de aproximação

### Erro de Tolerância
- Verificar rigidez mecânica
- Reduzir velocidade de sondagem
- Aumentar número de amostras
- Verificar desgaste do bico

## 🔄 Integração com Sistema Existente

O sistema é totalmente compatível com:
- ✅ Sistema de calibração independente atual
- ✅ Macros de troca de ferramenta
- ✅ Diagnóstico de ferramentas
- ✅ KlipperScreen
- ✅ Salvamento em `variables.cfg`

## 💡 Vantagens do Sistema

### Automação Completa
- Sem intervenção manual para calibração 3D completa
- Calibração durante aquecimento
- Execução noturna possível
- Integração com rotinas de manutenção

### Precisão Superior XYZ
- Eliminação de erro humano em calibração 3D
- Medições repetíveis em todas as dimensões
- Compensação de temperatura
- Validação automática XYZ

### Flexibilidade
- Suporte a diferentes tipos de bico
- Calibração individual X, Y, Z ou completa XYZ
- Calibração sob demanda
- Histórico de calibrações
- Detecção de problemas

## 🛠️ Manutenção

### Verificações Regulares
- Limpeza da superfície de referência
- Verificação do alinhamento do sensor
- Teste de funcionamento mensal
- Backup das configurações

### Substituição de Ferramentas
1. Instale a nova ferramenta
2. Execute `CALIBRAR_AUTO_FERRAMENTA TOOL=X`
3. Verifique offset calculado
4. Teste impressão de calibração

## 📈 Melhorias Futuras

### Recursos Avançados
- Calibração automática por temperatura
- Detecção de desgaste do bico
- Compensação de dilatação térmica
- Interface web para monitoramento

### Sensores Adicionais
- Sensor de força para detecção de pressão
- Sensor óptico para medição sem contato
- Múltiplos pontos de referência
- Calibração de offsets X/Y automática

## 💰 Custo Estimado

| Item | Preço Aproximado |
|------|------------------|
| Sensor Capacitivo LJ12A3 | R$ 25-40 |
| Superfície de Alumínio | R$ 10-20 |
| Cabos e Conectores | R$ 15-25 |
| **Total** | **R$ 50-85** |

## 📞 Suporte

Para dúvidas sobre implementação:
1. Verifique este guia primeiro
2. Execute diagnósticos do sistema
3. Consulte logs do Klipper
4. Documente o problema com detalhes

---

**Nota**: Este sistema representa uma evolução significativa na automação da impressora, eliminando uma das tarefas manuais mais críticas e propensas a erro.