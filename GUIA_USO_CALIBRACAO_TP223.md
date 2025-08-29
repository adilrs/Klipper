# 🎯 Guia de Uso - Sistema de Calibração Automática TP223

## 📋 Visão Geral

O sistema de calibração automática TP223 permite medir automaticamente a distância do bico do extrusor usando o sensor de toque capacitivo TP223. Este sistema é ideal para:

- ✅ Medição precisa da distância do bico
- ✅ Calibração automática de offset Z
- ✅ Verificação de precisão do sensor
- ✅ Diagnóstico de problemas de nivelamento

## 🚀 Comandos Principais

### 1. Configuração Inicial
```gcode
CALIBRACO_TP223_CONFIG X=320 Y=100 SAMPLES=5 TOLERANCE=0.02
```
**Parâmetros:**
- `X`, `Y`: Posição da superfície de referência
- `SAMPLES`: Número de medições (recomendado: 5)
- `TOLERANCE`: Tolerância entre medições em mm (recomendado: 0.02)

### 2. Medição Automática da Distância
```gcode
MEDIR_DISTANCIA_BICO_TP223
```
**Funcionalidades:**
- 🔍 Executa múltiplas medições para maior precisão
- 📊 Calcula estatísticas (média, mín, máx, range)
- ✅ Verifica tolerância automaticamente
- 💡 Sugere offset Z baseado na medição

### 3. Calibração Automática de Offset Z
```gcode
CALIBRAR_OFFSET_Z_TP223 TOOL=extruder SAVE=1
```
**Parâmetros:**
- `TOOL`: Ferramenta a calibrar (extruder, extruder1, etc.)
- `SAVE`: 1 para salvar automaticamente, 0 apenas para teste

### 4. Teste do Sistema
```gcode
TESTAR_TP223_CALIBRACAO
```
**Verifica:**
- 🔧 Configuração do sistema
- 📍 Posicionamento da impressora
- 🔍 Estado do sensor TP223

### 5. Status do Sistema
```gcode
STATUS_TP223_CALIBRACAO
```
**Exibe:**
- 📊 Última medição realizada
- ⚙️ Configurações atuais
- 🎯 Offsets salvos para cada ferramenta

## 📝 Procedimento Recomendado

### Primeira Configuração
1. **Verificar sensor:**
   ```gcode
   TESTE_TP223_IND
   ```

2. **Configurar sistema:**
   ```gcode
   CALIBRACAO_TP223_CONFIG X=320 Y=100 SAMPLES=5
   ```

3. **Testar funcionamento:**
   ```gcode
   TESTAR_TP223_CALIBRACAO
   ```

### Calibração de Ferramenta
1. **Medição de teste:**
   ```gcode
   MEDIR_DISTANCIA_BICO_TP223 TOOL=extruder
   ```

2. **Calibração completa:**
   ```gcode
   CALIBRAR_OFFSET_Z_TP223 TOOL=extruder SAVE=1
   ```

3. **Verificar resultado:**
   ```gcode
   STATUS_TP223_CALIBRACAO
   ```

## 🔧 Configurações Avançadas

### Ajuste de Velocidades
```gcode
CALIBRACO_TP223_CONFIG SPEED=300 SLOW_SPEED=60
```
- `SPEED`: Velocidade de aproximação (mm/min)
- `SLOW_SPEED`: Velocidade final de toque (mm/min)

### Ajuste de Distâncias
```gcode
CALIBRACO_TP223_CONFIG DISTANCE=15 Z=10
```
- `DISTANCE`: Distância máxima de sondagem (mm)
- `Z`: Altura inicial segura (mm)

## 📊 Interpretação dos Resultados

### Exemplo de Saída Típica:
```
📊 ===== RESULTADOS DA MEDIÇÃO =====
🎯 Distância média do bico: 2.1250mm
📏 Range de medições: 0.015mm
📈 Mínimo: 2.118mm | Máximo: 2.133mm
🔢 Amostras válidas: 5/5
💡 Offset Z sugerido: 2.1250mm
```

### Análise:
- **Distância média**: Valor principal para offset Z
- **Range**: Deve estar dentro da tolerância configurada
- **Amostras válidas**: Todas as 5 medições devem ser válidas
- **Offset sugerido**: Valor calculado para aplicar

## ⚠️ Troubleshooting

### Problema: "Sensor TP223 não detectou contato"
**Soluções:**
1. Verificar conexão do GPIO 22
2. Testar sensor: `TESTE_TP223_IND`
3. Ajustar posição de referência
4. Verificar altura inicial (Z muito baixo)

### Problema: "Range excede tolerância"
**Soluções:**
1. Verificar estabilidade mecânica
2. Aumentar tempo de estabilização
3. Reduzir velocidade de aproximação
4. Verificar interferências elétricas

### Problema: "Falha no posicionamento"
**Soluções:**
1. Executar home: `G28`
2. Verificar limites da mesa
3. Ajustar posição de referência

## 🔄 Integração com Sistema Existente

O sistema TP223 funciona em paralelo com:
- ✅ BLTouch (probe principal)
- ✅ Sistema de calibração multitools
- ✅ Macros de teste independentes
- ✅ Sistema dual probe

## 📁 Arquivos Relacionados

- `calibracao_tp223_automatica.cfg` - Sistema principal
- `teste_piezo_independente.cfg` - Macros de teste TP223
- `CONFIGURACAO_TP223_DUAL_PROBE.md` - Documentação técnica
- `printer.cfg` - Configuração principal (includes)

## 💡 Dicas de Uso

1. **Sempre execute home antes da calibração**
2. **Use superfície limpa e plana para referência**
3. **Mantenha ambiente livre de interferências**
4. **Verifique regularmente a precisão do sensor**
5. **Salve offsets apenas após verificação**

## 🎯 Comandos de Emergência

```gcode
# Parar movimento imediatamente
M112

# Reset do sensor
SET_GCODE_VARIABLE MACRO=TESTE_TP223_IND VARIABLE=sensor_triggered VALUE=0

# Posição segura
G1 Z20 F3000
```

---

**✅ Sistema pronto para uso!**

Para começar, execute: `TESTAR_TP223_CALIBRACAO`