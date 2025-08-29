# 🔧 Guia Completo para Testar o Sensor Piezoelétrico

## 📍 **Posição do Sensor Instalado**
- **Coordenadas**: X320 Y100
- **GPIO**: 22 (Pino 15 físico do Raspberry Pi)
- **Status**: ✅ Instalado e configurado

## 🚀 **Testes Rápidos - Comece Aqui!**

### 1️⃣ **Teste Básico Inicial**
```gcode
TESTE_SENSOR_PIEZO
```
**O que faz**: Verifica se o sensor está respondendo
**Resultado esperado**: Mostra estado atual e instruções

### 2️⃣ **Verificar Estado Atual**
```gcode
QUERY_PROBE
```
**Resultado esperado**:
- `Probe: open` = Sensor livre (✅ normal)
- `Probe: TRIGGERED` = Sensor pressionado

### 3️⃣ **Teste de Movimento até o Sensor**
```gcode
G28                    ; Home all axes
G1 X320 Y100 Z10 F3000 ; Mover para posição do sensor
```
**O que faz**: Move o bico até a posição do sensor
**Verifique**: Se o movimento é suave e chega na posição correta

### 4️⃣ **Teste de Sensibilidade**
```gcode
TESTE_SENSIBILIDADE_RAPIDO
```
**O que faz**: Testa se o sensor detecta toques leves
**Como usar**: Toque levemente no sensor e observe as mensagens

## 🔍 **Testes Avançados**

### 📊 **Monitor em Tempo Real**
```gcode
MONITOR_SENSOR_PIEZO DURATION=30
```
**Duração**: 30 segundos
**Como usar**: Pressione e solte o sensor várias vezes
**Observe**: Mudanças de estado em tempo real

### 🎯 **Teste de Precisão**
```gcode
PROBE_ACCURACY SAMPLES=10
```
**O que faz**: Testa a repetibilidade do sensor
**Resultado esperado**: Desvio baixo (< 0.1mm)

### ⚡ **Teste de Velocidade de Resposta**
```gcode
TESTE_RESPOSTA_RAPIDA REPETICOES=10
```
**O que faz**: Verifica se o sensor responde rapidamente

### 🔧 **Calibração de Sensibilidade**
```gcode
CALIBRAR_SENSIBILIDADE_PIEZO TESTES=5
```
**Como usar**: Toque no sensor quando solicitado
**Ajuste**: Use o potenciômetro da placa LM393 se necessário

## 🛠️ **Calibração do Sistema**

### 🎯 **Calibração Z com o Sensor**
```gcode
PROBE_CALIBRATE
```
**O que faz**: Inicia calibração automática do offset Z
**Siga**: As instruções na tela do KlipperScreen

### 📏 **Teste de Offset Z**
```gcode
G28                    ; Home
G1 X320 Y100 Z10 F3000 ; Ir para sensor
PROBE                  ; Testar probe
G1 Z10                 ; Subir
```
**Verifique**: Se o probe funciona na posição do sensor

## 🚨 **Solução de Problemas**

### ❌ **Sensor Não Responde**
**Sintomas**: Estado sempre "open" ou sempre "TRIGGERED"
**Soluções**:
1. Verificar conexões físicas
2. Ajustar potenciômetro da placa LM393
3. Executar: `DIAGNOSTICO_SENSOR_PIEZO`

### ⚡ **Sensor Muito Sensível**
**Sintomas**: Dispara com vibração da mesa
**Soluções**:
1. Girar potenciômetro no sentido anti-horário
2. Verificar fixação do sensor
3. Executar: `TESTE_RUIDO AMOSTRAS=20`

### 🐌 **Sensor Pouco Sensível**
**Sintomas**: Precisa pressionar muito forte
**Soluções**:
1. Girar potenciômetro no sentido horário
2. Verificar conexões dos fios
3. Executar: `TESTE_SENSIBILIDADE_NIVEIS`

### 📊 **Resultados Inconsistentes**
**Sintomas**: Valores de probe variam muito
**Soluções**:
1. Executar: `ANALISE_ESTABILIDADE CICLOS=20`
2. Verificar fixação mecânica
3. Ajustar sensibilidade

## 📋 **Lista Completa de Comandos**

### 🔧 **Comandos Básicos**
| Comando | Descrição |
|---------|----------|
| `TESTE_SENSOR_PIEZO` | Teste inicial básico |
| `QUERY_PROBE` | Estado atual do sensor |
| `AJUDA_SENSOR_PIEZO` | Lista de comandos |
| `MENU_SENSOR_PIEZO` | Menu principal |

### 📊 **Comandos de Monitoramento**
| Comando | Parâmetros | Descrição |
|---------|------------|----------|
| `MONITOR_SENSOR_PIEZO` | `DURATION=30` | Monitor por 30s |
| `MONITOR_TEMPO_REAL` | `DURACAO=30` | Monitor em tempo real |
| `MONITOR_CONTINUO_PIEZO` | `CICLOS=10` | 10 ciclos de monitor |

### 🎯 **Comandos de Calibração**
| Comando | Parâmetros | Descrição |
|---------|------------|----------|
| `PROBE_CALIBRATE` | - | Calibração Z oficial |
| `CALIBRAR_SENSIBILIDADE_PIEZO` | `TESTES=5` | 5 testes de sensibilidade |
| `PROBE_ACCURACY` | `SAMPLES=10` | Teste de precisão |

### 🔍 **Comandos de Diagnóstico**
| Comando | Parâmetros | Descrição |
|---------|------------|----------|
| `DIAGNOSTICO_SENSOR_PIEZO` | - | Diagnóstico completo |
| `TESTE_RESPOSTA_RAPIDA` | `REPETICOES=10` | Teste de velocidade |
| `ANALISE_ESTABILIDADE` | `CICLOS=20` | Análise de estabilidade |
| `TESTE_RUIDO` | `AMOSTRAS=20` | Detecta interferência |

## ✅ **Checklist de Verificação**

### 🔌 **Conexões Físicas**
- [ ] Pino 2 (5V) → VCC da placa LM393
- [ ] Pino 6 (GND) → GND da placa LM393
- [ ] Pino 15 (GPIO22) → OUT da placa LM393
- [ ] Sensor piezo conectado à placa LM393

### ⚙️ **Configuração Software**
- [ ] `[include teste_sensor_piezo.cfg]` no printer.cfg
- [ ] Klipper reiniciado após configuração
- [ ] Sem conflitos de GPIO (verificado)

### 🎯 **Testes Funcionais**
- [ ] `TESTE_SENSOR_PIEZO` executado com sucesso
- [ ] `QUERY_PROBE` mostra estados corretos
- [ ] Movimento para X320 Y100 funciona
- [ ] `PROBE_ACCURACY` com desvio < 0.1mm
- [ ] `PROBE_CALIBRATE` completa sem erros

## 🎉 **Próximos Passos**

1. **Teste básico**: Execute `TESTE_SENSOR_PIEZO`
2. **Verificação**: Execute `QUERY_PROBE` e toque o sensor
3. **Movimento**: Teste `G1 X320 Y100 Z10 F3000`
4. **Precisão**: Execute `PROBE_ACCURACY SAMPLES=10`
5. **Calibração**: Execute `PROBE_CALIBRATE` quando estiver satisfeito

---

**💡 Dica**: Comece sempre com `TESTE_SENSOR_PIEZO` para verificar o funcionamento básico antes de partir para testes mais avançados!

**⚠️ Importante**: Se algum teste falhar, consulte a seção "Solução de Problemas" antes de prosseguir.