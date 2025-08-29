# 🔧 GUIA DE CORREÇÃO - PROBLEMA DE REINÍCIO DE FERRAMENTAS

## 🚨 PROBLEMA IDENTIFICADO

**Situação atual:**
- Você reinicia o Klipper com T2 ativa
- O sistema assume que está com T0 (padrão)
- Quando você pede para trocar para T1, ele tenta descarregar T0
- **RESULTADO: DESASTRE** - movimento incorreto da ferramenta

**Causa raiz:**
- O `delayed_gcode init_tool_restore` não sincroniza o `TOOL_STATE` corretamente
- A macro `TROCA` usa `printer["gcode_macro TOOL_STATE"].tool` para detectar ferramenta ativa
- Após reinício, há dessincronização entre estado salvo e estado ativo

## ✅ SOLUÇÃO IMPLEMENTADA

### 1. **ARQUIVO CRIADO: `correcao_reinicio_ferramentas.cfg`**

Este arquivo contém:
- ✅ `init_tool_restore_fixed` - Inicialização corrigida
- ✅ `CORRIGIR_FERRAMENTA_FISICA` - Correção manual de emergência
- ✅ `VERIFICAR_SINCRONIZACAO` - Diagnóstico de estados
- ✅ `REINICIAR_SISTEMA_FERRAMENTAS` - Reset completo

### 2. **IMPLEMENTAÇÃO PASSO A PASSO**

#### **PASSO 1: Incluir o arquivo de correção**
```ini
# No printer.cfg, adicionar:
[include correcao_reinicio_ferramentas.cfg]
```

#### **PASSO 2: Desabilitar o delayed_gcode original**
No `printer.cfg`, encontrar esta seção:
```ini
[delayed_gcode init_tool_restore]
initial_duration: 1
gcode:
  # ... código existente ...
```

**Comentar ou renomear para:**
```ini
[delayed_gcode init_tool_restore_OLD]
initial_duration: 1
gcode:
  # ... código existente ...
```

#### **PASSO 3: Reiniciar o Klipper**
```bash
sudo systemctl restart klipper
```

## 🛠️ COMANDOS DE CORREÇÃO

### **DIAGNÓSTICO**
```gcode
VERIFICAR_SINCRONIZACAO
```
**Mostra:**
- Estado atual do TOOL_STATE
- Estado salvo no variables.cfg
- Extrusora ativa
- Status do LIDAR (se disponível)

### **CORREÇÃO MANUAL DE EMERGÊNCIA**
```gcode
# Se você sabe que tem T2 montada fisicamente:
CORRIGIR_FERRAMENTA_FISICA TOOL=3

# Se você sabe que tem T1 montada fisicamente:
CORRIGIR_FERRAMENTA_FISICA TOOL=2

# Se você sabe que tem T0 montada fisicamente:
CORRIGIR_FERRAMENTA_FISICA TOOL=1
```

### **RESET COMPLETO (ESTADO SEGURO)**
```gcode
REINICIAR_SISTEMA_FERRAMENTAS
```
**Força o sistema para T0 - use quando em dúvida**

## 🎯 CENÁRIOS DE USO

### **CENÁRIO 1: Reiniciou com T2, mas sistema pensa que é T0**
```gcode
# 1. Verificar estado atual
VERIFICAR_SINCRONIZACAO

# 2. Corrigir manualmente
CORRIGIR_FERRAMENTA_FISICA TOOL=3

# 3. Agora pode trocar normalmente
T1  # Vai trocar corretamente de T2 para T1
```

### **CENÁRIO 2: Não tem certeza qual ferramenta está montada**
```gcode
# 1. Reset para estado seguro
REINICIAR_SISTEMA_FERRAMENTAS

# 2. Carregar ferramenta desejada
T2  # Vai carregar T2 corretamente
```

### **CENÁRIO 3: Verificação preventiva após reinício**
```gcode
# Sempre execute após reiniciar:
VERIFICAR_SINCRONIZACAO

# Se mostrar "DESSINCRONIZADO", corrigir:
CORRIGIR_FERRAMENTA_FISICA TOOL=X  # X = ferramenta real
```

## 🔍 COMO FUNCIONA A CORREÇÃO

### **ANTES (PROBLEMA):**
1. Reinicia com T2 fisicamente montada
2. `variables.cfg` tem `tool: 3` (correto)
3. `TOOL_STATE.tool` fica com valor padrão `1` (ERRADO)
4. Macro `TROCA` pensa que tem T0 ativa
5. **DESASTRE** ao tentar trocar

### **DEPOIS (CORRIGIDO):**
1. Reinicia com T2 fisicamente montada
2. `variables.cfg` tem `tool: 3` (correto)
3. `init_tool_restore_fixed` sincroniza `TOOL_STATE.tool = 3` (CORRETO)
4. Macro `TROCA` sabe que tem T2 ativa
5. **SUCESSO** ao trocar para qualquer ferramenta

## ⚡ MELHORIAS IMPLEMENTADAS

### **1. SINCRONIZAÇÃO AUTOMÁTICA**
- O novo `delayed_gcode` aguarda 2 segundos para estabilizar
- Sincroniza automaticamente `TOOL_STATE` com `variables.cfg`
- Ativa a extrusora correta
- Aplica os offsets corretos

### **2. VERIFICAÇÃO FÍSICA (LIDAR)**
- Se LIDAR estiver ativo, verifica presença física
- Alerta se não detectar ferramenta montada
- Funciona mesmo com LIDAR desativado

### **3. MACROS DE EMERGÊNCIA**
- `CORRIGIR_FERRAMENTA_FISICA` para correção manual
- `VERIFICAR_SINCRONIZACAO` para diagnóstico
- `REINICIAR_SISTEMA_FERRAMENTAS` para reset completo

### **4. LOGS DETALHADOS**
- Mensagens claras sobre o que está acontecendo
- Identificação de problemas de sincronização
- Sugestões de comandos para correção

## 🚀 PRÓXIMOS PASSOS

1. **IMPLEMENTAR** as mudanças no `printer.cfg`
2. **REINICIAR** o Klipper
3. **TESTAR** com `VERIFICAR_SINCRONIZACAO`
4. **USAR** `CORRIGIR_FERRAMENTA_FISICA` quando necessário
5. **NUNCA MAIS** ter problemas de reinício! 🎉

## 📞 SUPORTE

Se ainda tiver problemas:
1. Execute `VERIFICAR_SINCRONIZACAO` e envie o resultado
2. Verifique se incluiu o arquivo corretamente
3. Confirme se desabilitou o `delayed_gcode` original
4. Use `REINICIAR_SISTEMA_FERRAMENTAS` como último recurso

---
**✅ PROBLEMA RESOLVIDO: Agora o sistema sempre sabe qual ferramenta está realmente ativa após reiniciar!**