# 🔧 Correção do Sistema de Calibração Multi-Ferramenta

## ❌ Problemas Identificados

### 1. **Medição Desnecessária do T0**
- Sistema forçava carregamento de T0 para medir referência
- Desperdiçava tempo e causava confusão
- **Solução**: Usar referência já salva em `printer.cfg [bltouch] z_offset`

### 2. **Botões de Ajuste Não Apareciam**
- `MANUAL_PROBE` não mostrava interface do KlipperScreen
- **Solução**: Usar `PROBE_CALIBRATE_ORIGINAL` para interface completa

### 3. **Cálculo de Offset Incorreto**
- Não calculava diferença relativa corretamente
- **Solução**: Calcular `offset_ferramenta - referencia_T0`

## ✅ Correções Implementadas

### Arquivo Modificado: `klipperscreen_multitools.cfg`

#### 1. **Macro CALIBRAR_FERRAMENTA_RELATIVA**
```gcode
# ANTES: Forçava medição T0
T0
PROBE
{% set ref_z = printer.probe.last_z_result %}

# DEPOIS: Usa referência salva
{% set bltouch_offset = printer.configfile.settings.bltouch.z_offset|float %}
RESPOND MSG="📌 Usando referência T0 salva: {bltouch_offset|round(4)}mm"
```

#### 2. **Interface de Calibração**
```gcode
# ANTES: Interface limitada
MANUAL_PROBE

# DEPOIS: Interface completa do KlipperScreen
PROBE_CALIBRATE_ORIGINAL
```

#### 3. **Cálculo de Offset Relativo**
```gcode
# ANTES: Offset absoluto
SAVE_VARIABLE VARIABLE=tool_{tool_index}_offset_z VALUE={current_offset}

# DEPOIS: Offset relativo ao T0
{% set relative_offset = current_offset - ref_z %}
SAVE_VARIABLE VARIABLE=tool_{tool_index}_offset_z VALUE={relative_offset}
```

## 🎯 Fluxo Corrigido

### Para Calibrar T1:
1. **Usuário**: Ativa T1 → KlipperScreen → Calibrate
2. **Sistema**: Detecta T1 ativa
3. **Sistema**: Usa referência T0 já salva (1.00mm)
4. **Sistema**: Ativa T1 e chama `PROBE_CALIBRATE_ORIGINAL`
5. **KlipperScreen**: Mostra botões de ajuste (↑↓)
6. **Usuário**: Ajusta altura com papel
7. **Sistema**: Calcula diferença relativa e salva

### Exemplo de Cálculo:
- **Referência T0**: 1.00mm (salva em printer.cfg)
- **Ajuste final T1**: 0.85mm
- **Offset relativo**: 0.85 - 1.00 = -0.15mm
- **Salvo em**: `variables.cfg → tool_0_offset_z = -0.15`

## 📊 Vantagens da Correção

✅ **Mais Rápido**: Não precisa medir T0 toda vez
✅ **Interface Completa**: Botões de ajuste aparecem
✅ **Cálculo Correto**: Offset relativo preciso
✅ **Menos Confusão**: Não troca ferramenta desnecessariamente
✅ **Usa Referência Salva**: Aproveita calibração T0 existente

## 🔄 Como Testar

1. **Reiniciar Klipper**:
   ```
   RESTART
   ```

2. **Verificar Status**:
   ```
   STATUS_CALIBRACAO_MULTI
   ```

3. **Calibrar T1**:
   - Ativar T1
   - KlipperScreen → Settings → Calibrate → Probe Z Offset
   - Ajustar com botões na tela
   - Aplicar quando perfeito

4. **Verificar Resultado**:
   ```
   STATUS_CALIBRACAO_MULTI
   ```

## 📝 Resultado Esperado

- **T0**: Mantém referência em `printer.cfg` (1.00mm)
- **T1**: Offset relativo em `variables.cfg` (ex: -0.15mm)
- **T2**: Offset relativo em `variables.cfg` (ex: +0.05mm)
- **Interface**: Botões de ajuste funcionando
- **Velocidade**: Calibração mais rápida
- **Precisão**: Cálculos corretos