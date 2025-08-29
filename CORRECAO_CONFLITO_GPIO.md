# CORREÇÃO DO CONFLITO GPIO 22

## 🚨 PROBLEMA IDENTIFICADO

**Erro:** `pin gpio22 used multiple times in config`

**Causa:** Múltiplas definições do mesmo GPIO em arquivos diferentes:

1. **teste_sensor_piezo.cfg:**
   ```ini
   [gcode_button sensor_piezo]
   pin: host:gpio22
   ```

2. **sensor_piezo_probe_lento.cfg:**
   ```ini
   [probe]
   pin: !host:gpio22
   
   [gcode_button sensor_piezo_backup]
   pin: !host:gpio22
   ```

## ✅ CORREÇÃO APLICADA

### Arquivos Modificados:

**sensor_piezo_probe_lento.cfg:**
- ❌ Comentado: `[probe]` com `pin: !host:gpio22`
- ❌ Comentado: `[gcode_button sensor_piezo_backup]` com `pin: !host:gpio22`

### Configuração Ativa:

**teste_sensor_piezo.cfg:**
- ✅ Mantido: `[gcode_button sensor_piezo]` com `pin: host:gpio22`

## 🔧 CONFIGURAÇÃO FINAL

Apenas **UMA** definição do GPIO 22 está ativa:

```ini
# Em teste_sensor_piezo.cfg
[gcode_button sensor_piezo]
pin: host:gpio22  # Sem pull-up para maior sensibilidade
press_gcode:
    RESPOND MSG="🔴 Sensor acionado"
release_gcode:
    RESPOND MSG="🟢 Sensor liberado"
```

## 🧪 PRÓXIMOS PASSOS

1. **Reiniciar Klipper:**
   ```
   RESTART
   ```

2. **Testar sensor:**
   ```
   TESTE_SENSIBILIDADE_RAPIDO
   ```

3. **Se precisar de probe automático:**
   - Descomente as configurações em `sensor_piezo_probe_lento.cfg`
   - Comente a configuração em `teste_sensor_piezo.cfg`
   - **NUNCA** tenha ambas ativas simultaneamente

## ⚠️ REGRA IMPORTANTE

**UM GPIO = UMA DEFINIÇÃO**

Nunca defina o mesmo pino em múltiplas seções:
- ❌ `[gcode_button]` + `[probe]` no mesmo GPIO
- ❌ Múltiplos `[gcode_button]` no mesmo GPIO
- ✅ Apenas UMA definição por GPIO

## 🔄 ALTERNATIVAS FUTURAS

Se precisar de funcionalidades diferentes:

1. **Para teste manual:** Use `teste_sensor_piezo.cfg`
2. **Para probe automático:** Descomente `sensor_piezo_probe_lento.cfg` e comente `teste_sensor_piezo.cfg`
3. **Para sistema híbrido:** Use `alternativa_sensor_pressao.cfg` (descomente no printer.cfg)

**IMPORTANTE:** Sempre mantenha apenas UMA configuração ativa por vez!