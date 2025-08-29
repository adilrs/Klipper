# 📐 Instalação do Pino de Aço para Detecção XY

## 🎯 Visão Geral

Este guia detalha como instalar um pino de aço fino no sensor piezoelétrico para permitir a detecção de offsets X e Y através de varredura lateral.

## 🔧 Materiais Necessários

- **Pino de aço inoxidável**: 3mm de altura, diâmetro fino (0.5-1mm)
- **Solda e ferro de solda**: Para fixação do pino
- **Lima ou lixa fina**: Para acabamento
- **Multímetro**: Para verificar continuidade elétrica

## 📋 Procedimento de Instalação

### 1. Preparação do Pino

```
🔹 Cortar o pino de aço com exatamente 3mm de altura
🔹 Limar uma das extremidades para criar ponta levemente arredondada
🔹 Limpar o pino com álcool isopropílico
```

### 2. Posicionamento no Sensor

```
🔹 Localizar a lateral do sensor piezoelétrico
🔹 Posicionar o pino perpendicular à superfície de detecção
🔹 O pino deve ficar na mesma altura da ponta da ferramenta
```

### 3. Soldagem

```
⚠️  ATENÇÃO: Sensor desligado durante soldagem!

🔹 Aquecer o ferro de solda (300-350°C)
🔹 Aplicar flux na área de contato
🔹 Soldar o pino firmemente ao sensor
🔹 Verificar que não há curto-circuito
```

### 4. Teste de Continuidade

```
🔹 Usar multímetro para verificar continuidade
🔹 Pino deve estar eletricamente conectado ao sensor
🔹 Não deve haver resistência excessiva (< 1Ω)
```

## ⚙️ Configuração do Sistema

### Variáveis de Configuração

```gcode
# Configurar altura do pino e distâncias de varredura
CALIBRACO_AUTO_CONFIG PIN_HEIGHT=3.0 X_SWEEP_DIST=15.0 Y_SWEEP_DIST=15.0
```

### Parâmetros Importantes

| Parâmetro | Valor Padrão | Descrição |
|-----------|--------------|-----------|
| `PIN_HEIGHT` | 3.0mm | Altura do pino de aço |
| `X_SWEEP_DIST` | 15.0mm | Distância de varredura X |
| `Y_SWEEP_DIST` | 15.0mm | Distância de varredura Y |
| `XY_PROBE_SPEED` | 300mm/min | Velocidade de varredura |

## 🧪 Testes de Funcionamento

### 1. Teste de Detecção X

```gcode
# Calibrar offset X com varredura lateral
CALIBRAR_OFFSET_X_AUTO TOOL=extruder
```

**Resultado esperado:**
- Movimento lateral lento até detectar contato
- Mensagem: "🎯 Contato detectado em X[posição]"
- Cálculo e salvamento do offset X

### 2. Teste de Detecção Y

```gcode
# Calibrar offset Y com varredura lateral
CALIBRAR_OFFSET_Y_AUTO TOOL=extruder
```

**Resultado esperado:**
- Movimento lateral lento até detectar contato
- Mensagem: "🎯 Contato detectado em Y[posição]"
- Cálculo e salvamento do offset Y

### 3. Teste Completo XYZ

```gcode
# Calibração completa com pino de aço
CALIBRAR_XYZ_AUTO_COMPLETO TOOL=extruder
```

## 🔍 Solução de Problemas

### Problema: Contato não detectado

**Possíveis causas:**
- Pino mal soldado (sem continuidade elétrica)
- Altura incorreta do pino
- Velocidade de varredura muito alta
- Sensor piezoelétrico com defeito

**Soluções:**
1. Verificar continuidade com multímetro
2. Ajustar altura do pino para 3mm exatos
3. Reduzir velocidade: `XY_PROBE_SPEED=150`
4. Testar sensor com calibração Z normal

### Problema: Detecção inconsistente

**Possíveis causas:**
- Pino com ponta muito afiada
- Vibração excessiva
- Interferência elétrica

**Soluções:**
1. Arredondar levemente a ponta do pino
2. Verificar fixação mecânica do sensor
3. Verificar aterramento elétrico

### Problema: Offset incorreto

**Possíveis causas:**
- Posição de referência incorreta
- Distância de varredura inadequada
- Pino desalinhado

**Soluções:**
1. Reconfigurar posição de referência
2. Ajustar distâncias de varredura
3. Verificar alinhamento perpendicular do pino

## 📊 Vantagens do Sistema com Pino

### ✅ Benefícios

- **Detecção 3D completa**: X, Y e Z em um único sensor
- **Precisão lateral**: Detecção de contato em qualquer direção
- **Economia**: Não requer sensores adicionais
- **Simplicidade**: Modificação mínima do hardware existente

### ⚠️ Considerações

- **Fragilidade**: Pino pode quebrar com impacto
- **Manutenção**: Verificação periódica da soldagem
- **Calibração**: Requer ajuste fino das distâncias

## 🔄 Manutenção

### Verificação Mensal

```
🔹 Inspeção visual do pino (integridade)
🔹 Teste de continuidade elétrica
🔹 Verificação da altura (3mm)
🔹 Limpeza com álcool isopropílico
```

### Substituição do Pino

```
🔹 Dessoldar pino antigo cuidadosamente
🔹 Limpar área de soldagem
🔹 Instalar novo pino seguindo procedimento
🔹 Recalibrar sistema completo
```

## 📞 Suporte

Para dúvidas ou problemas:
1. Verificar este guia primeiro
2. Testar calibração Z normal
3. Consultar logs do Klipper
4. Documentar problema com fotos/vídeos

---

**Versão:** 2.0 - Sistema de Calibração XYZ com Pino de Aço  
**Atualizado:** Janeiro 2025