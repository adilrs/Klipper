# 🔧 Sistema de Calibração Multi-Ferramenta Independente

## 📋 Visão Geral

Este é o **novo sistema de calibração multi-ferramenta** que substitui o sistema anterior com interceptações problemáticas. O novo sistema é:

- ✅ **Mais confiável** - Sem interceptações que causam conflitos
- ✅ **Mais simples** - Comandos dedicados para cada ferramenta
- ✅ **Mais fácil de usar** - Interface clara e intuitiva
- ✅ **Mais fácil de manter** - Código limpo e bem documentado

## 🎯 Arquivos do Sistema

### Arquivos Principais
- `calibracao_multitools_independente.cfg` - Sistema principal de calibração
- `klipperscreen_menu_calibracao.cfg` - Menu personalizado (opcional)
- `INSTRUCOES_SISTEMA_INDEPENDENTE.md` - Este arquivo de instruções

### Arquivos Antigos (Mantidos para Compatibilidade)
- `klipperscreen_multitools.cfg` - Sistema antigo (sem interceptações)

## 🚀 Como Usar

### 1️⃣ Calibração T0 (Referência)

```gcode
# 1. Execute o comando de calibração
CALIBRAR_T0

# 2. No terminal, execute:
PROBE_CALIBRATE

# 3. Ajuste a altura usando os botões do KlipperScreen
# 4. Quando perfeito, execute:
FINALIZAR_CALIBRACAO_T0
```

**Resultado:** T0 será salvo em `printer.cfg` como referência para as outras ferramentas.

### 2️⃣ Calibração T1 (Relativa ao T0)

```gcode
# 1. Certifique-se que T0 foi calibrado primeiro
# 2. Execute o comando de calibração
CALIBRAR_T1

# 3. No terminal, execute:
PROBE_CALIBRATE

# 4. Ajuste a altura usando os botões do KlipperScreen
# 5. Quando perfeito, execute:
FINALIZAR_CALIBRACAO_T1
```

**Resultado:** T1 será salvo em `variables.cfg` como `tool_0_offset_z`.

### 3️⃣ Calibração T2 (Relativa ao T0)

```gcode
# 1. Certifique-se que T0 foi calibrado primeiro
# 2. Execute o comando de calibração
CALIBRAR_T2

# 3. No terminal, execute:
PROBE_CALIBRATE

# 4. Ajuste a altura usando os botões do KlipperScreen
# 5. Quando perfeito, execute:
FINALIZAR_CALIBRACAO_T2
```

**Resultado:** T2 será salvo em `variables.cfg` como `tool_1_offset_z`.

## 📱 Menu do KlipperScreen (Opcional)

Para ativar o menu personalizado no KlipperScreen:

### 1. Abra o arquivo `KlipperScreen.conf`
### 2. Adicione as seguintes linhas:

```ini
[menu __main calibracao_multitools]
name: Calibração Multi-Ferramenta
icon: probe

[menu __main calibracao_multitools calibrar_t0]
name: Calibrar T0 (Referência)
icon: extruder
method: printer.gcode.script
params: {"script":"CALIBRAR_T0"}

[menu __main calibracao_multitools calibrar_t1]
name: Calibrar T1 (Relativa)
icon: extruder
method: printer.gcode.script
params: {"script":"CALIBRAR_T1"}

[menu __main calibracao_multitools calibrar_t2]
name: Calibrar T2 (Relativa)
icon: extruder
method: printer.gcode.script
params: {"script":"CALIBRAR_T2"}

[menu __main calibracao_multitools separator1]
name: ────────────────

[menu __main calibracao_multitools finalizar_t0]
name: Finalizar T0
icon: complete
method: printer.gcode.script
params: {"script":"FINALIZAR_CALIBRACAO_T0"}

[menu __main calibracao_multitools finalizar_t1]
name: Finalizar T1
icon: complete
method: printer.gcode.script
params: {"script":"FINALIZAR_CALIBRACAO_T1"}

[menu __main calibracao_multitools finalizar_t2]
name: Finalizar T2
icon: complete
method: printer.gcode.script
params: {"script":"FINALIZAR_CALIBRACAO_T2"}

[menu __main calibracao_multitools separator2]
name: ────────────────

[menu __main calibracao_multitools status]
name: Status Sistema
icon: info
method: printer.gcode.script
params: {"script":"STATUS_CALIBRACAO_INDEPENDENTE"}

[menu __main calibracao_multitools cancelar]
name: Cancelar Calibração
icon: cancel
method: printer.gcode.script
params: {"script":"CANCELAR_CALIBRACAO"}

[menu __main calibracao_multitools ajuda]
name: Ajuda
icon: info
method: printer.gcode.script
params: {"script":"AJUDA_CALIBRACAO_INDEPENDENTE"}
```

### 3. Reinicie o KlipperScreen
### 4. O menu aparecerá como "Calibração Multi-Ferramenta"

## 🛠️ Comandos Úteis

### Diagnóstico e Status
```gcode
STATUS_CALIBRACAO_INDEPENDENTE  # Ver status do sistema
STATUS_MULTITOOLS               # Ver status das ferramentas
CANCELAR_CALIBRACAO            # Cancelar calibração em andamento
```

### Ajuda e Informações
```gcode
AJUDA_CALIBRACAO_INDEPENDENTE   # Mostrar ajuda completa
INFO_SISTEMA_MULTITOOLS         # Informações sobre o sistema
MIGRAR_PARA_SISTEMA_INDEPENDENTE # Instruções de migração
```

### Utilitários
```gcode
LIMPAR_OFFSETS_MULTITOOLS       # Limpar todos os offsets (CUIDADO!)
```

## 📊 Onde os Offsets São Salvos

| Ferramenta | Arquivo | Localização | Descrição |
|------------|---------|-------------|------------|
| **T0** | `printer.cfg` | `[bltouch] z_offset` | Referência absoluta |
| **T1** | `variables.cfg` | `tool_0_offset_z` | Relativo ao T0 |
| **T2** | `variables.cfg` | `tool_1_offset_z` | Relativo ao T0 |

## 🔄 Fluxo de Calibração Recomendado

1. **Sempre calibre T0 primeiro** - Ele serve como referência
2. **Calibre T1 e T2 em qualquer ordem** - Eles são relativos ao T0
3. **Execute RESTART após calibrar T1/T2** - Para aplicar mudanças
4. **Teste a impressão** - Verifique se os offsets estão corretos

## ⚠️ Notas Importantes

### ✅ O Que Fazer
- Sempre calibre T0 primeiro
- Use os comandos `FINALIZAR_CALIBRACAO_TX` em vez de `ACCEPT`
- Execute `RESTART` após calibrar T1/T2
- Verifique os offsets com `STATUS_CALIBRACAO_INDEPENDENTE`

### ❌ O Que NÃO Fazer
- Não use o botão `ACCEPT` do KlipperScreen
- Não troque ferramentas durante a calibração
- Não calibre T1/T2 sem calibrar T0 primeiro
- Não edite manualmente os offsets sem entender o sistema

## 🐛 Solução de Problemas

### Problema: "T0 não foi calibrado ainda!"
**Solução:** Execute `CALIBRAR_T0` e `FINALIZAR_CALIBRACAO_T0` primeiro.

### Problema: "Calibração não está ativa!"
**Solução:** Execute `CALIBRAR_TX` antes de `FINALIZAR_CALIBRACAO_TX`.

### Problema: Offsets muito grandes
**Solução:** Verifique se a calibração foi feita corretamente. Offsets > 1mm podem indicar problema.

### Problema: Menu não aparece no KlipperScreen
**Solução:** Verifique se as configurações foram adicionadas corretamente ao `KlipperScreen.conf` e reinicie o KlipperScreen.

## 🔧 Migração do Sistema Antigo

Se você estava usando o sistema antigo com interceptações:

1. **O novo sistema já está ativo** - Configurado automaticamente
2. **Sistema antigo foi limpo** - Interceptações removidas
3. **Ambos coexistem** - Para transição suave
4. **Teste o novo sistema** - Use os comandos `CALIBRAR_TX`
5. **Remova o antigo** - Comente `[include klipperscreen_multitools.cfg]` quando confiante

## 📞 Suporte

Para diagnóstico, sempre execute:
```gcode
STATUS_CALIBRACAO_INDEPENDENTE
STATUS_MULTITOOLS
```

E forneça a saída desses comandos junto com a descrição do problema.

---

**✅ Sistema criado com sucesso!**

O novo sistema independente está pronto para uso. Ele é mais confiável, simples e não causa conflitos com o KlipperScreen ou outros sistemas.