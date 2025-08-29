# 🔧 CORREÇÕES DO SISTEMA DE FERRAMENTAS

## 📋 PROBLEMAS IDENTIFICADOS E CORRIGIDOS

### 1. **Problema Principal: Troca Forçada de Ferramentas**
- **Causa**: A macro `TROCA` tinha `{% if true %}` em vez de `{% if active_tool != tool %}`
- **Efeito**: Sempre executava troca mesmo quando a ferramenta solicitada já estava ativa
- **Correção**: Restaurada a condição correta `{% if active_tool != tool %}`

### 2. **Problema de Inicialização: Estado vs Realidade Física**
- **Causa**: A macro `STARTUP` apenas restaurava o estado salvo sem verificar a realidade física
- **Efeito**: Sistema assumia que T2 estava carregada mesmo sem verificação física
- **Correção**: Adicionada verificação LIDAR para detectar presença física de ferramenta

### 3. **Problema de Sincronização de Extrusora**
- **Causa**: Extrusora não era ativada corretamente na inicialização
- **Efeito**: Comandos de extrusão podiam ir para extrusora errada
- **Correção**: Adicionado `ACTIVATE_EXTRUDER` na inicialização

## 🛠️ ARQUIVOS MODIFICADOS

### `tools.cfg`
- Corrigida condição na macro `TROCA`
- Linha 278: `{% if true %}` → `{% if active_tool != tool %}`

### `macros.cfg`
- Macro `STARTUP` completamente reescrita
- Adicionada verificação LIDAR para detecção física
- Adicionada ativação automática de extrusora
- Correção automática de estados inconsistentes

### `verificacao_ferramenta.cfg` (NOVO)
- `VERIFICAR_ESTADO_FERRAMENTA`: Diagnóstico completo
- `CORRIGIR_FERRAMENTA_FISICA`: Correção forçada
- `RESET_FERRAMENTA_SEGURO`: Reset para T0
- `PRE_PRINT_CHECK`: Verificação pré-impressão

### `printer.cfg`
- Adicionada inclusão do novo arquivo de verificação

## 🔍 NOVA LÓGICA DE INICIALIZAÇÃO

### Sequência na STARTUP:
1. **Verificação LIDAR**: Detecta se há ferramenta física carregada
2. **Análise de Estado**: Compara estado salvo vs realidade física
3. **Correção Automática**: 
   - Se há ferramenta física → restaura estado salvo
   - Se não há ferramenta → **AGUARDA comando manual** (T0, T1 ou T2)
   - **NUNCA força ferramenta automaticamente** - sempre aguarda decisão do usuário
4. **Ativação de Extrusora**: Ativa extrusora correspondente
5. **Aplicação de Offsets**: Aplica offsets corretos

## 🎯 MACROS DE DIAGNÓSTICO DISPONÍVEIS

### Para Verificação:
```gcode
VERIFICAR_ESTADO_FERRAMENTA  # Diagnóstico completo
PRE_PRINT_CHECK             # Verificação pré-impressão
DIAGNOSTICO_COMPLETO        # Diagnóstico do sistema de offsets
DIAGNOSTICO_TROMBAMENTO     # Diagnóstico específico para trombamento
```

### Para Correção:
```gcode
CORRIGIR_FERRAMENTA_FISICA TOOL=1  # Força correção para T0
CORRIGIR_FERRAMENTA_FISICA TOOL=2  # Força correção para T1
CORRIGIR_FERRAMENTA_FISICA TOOL=3  # Força correção para T2
RESET_FERRAMENTA_SEGURO           # Reset completo para T0
LIDAR_ON                          # Ativar detecção física
LIDAR_OFF                         # Desativar detecção física
```

### Para Situações de Trombamento:
```gcode
DIAGNOSTICO_TROMBAMENTO           # Análise completa do problema
LIDAR_ON                          # Ativar detecção para próximas vezes
STARTUP                           # Reinicializar com nova lógica
```

## Sistema de Calibração Multi-Ferramenta via KlipperScreen

### Novo Sistema Implementado

O sistema `klipperscreen_multitools.cfg` permite calibrar offsets de múltiplas ferramentas diretamente pelo KlipperScreen, salvando automaticamente no local correto:

- **T0**: Salva em `printer.cfg` [bltouch] z_offset (referência)
- **T1**: Salva em `variables.cfg` como `tool_0_offset_z`
- **T2**: Salva em `variables.cfg` como `tool_1_offset_z`

### Como Usar

1. **Calibrar T0 primeiro** (estabelece referência do BLTouch)
   - Ative T0
   - KlipperScreen → Settings → Calibrate → Probe Z Offset
   - Sistema salva automaticamente em `printer.cfg`

2. **Calibrar T1/T2** (calibração relativa ao T0)
   - Ative T1 ou T2
   - KlipperScreen → Settings → Calibrate → Probe Z Offset
   - Sistema detecta automaticamente a ferramenta
   - Faz calibração relativa ao T0
   - Salva automaticamente em `variables.cfg`

### Comandos de Diagnóstico

```gcode
STATUS_CALIBRACAO_MULTI    # Ver status de todas as calibrações
INFO_CALIBRACAO_MULTI      # Ajuda e informações do sistema
RESET_CALIBRACAO_MULTI     # Resetar todas as calibrações
BACKUP_CALIBRACOES_MULTI   # Fazer backup das calibrações
```

## 🔄 Sistema de Recarregamento de Ferramentas

### Nova Funcionalidade: Recarregamento Inteligente
Quando uma ferramenta já está ativa e o comando correspondente é chamado novamente:

- **T0** → Se já ativa, confirma estado
- **T1** → Se já ativa, executa `RECARREGAR_FERRAMENTA TOOL=2`
- **T2** → Se já ativa, executa `RECARREGAR_FERRAMENTA TOOL=3`

### Processo de Recarregamento
1. **Posicionamento**: Move para 1cm ANTES do estacionamento da ferramenta
2. **Abertura**: Abre servo para permitir reposicionamento
3. **Finalização**: Avança para posição final e fecha servo
4. **Validação**: Aplica offsets corretos da ferramenta

### 🔧 Melhoria na Macro TROCA
**Nova funcionalidade implementada**: Durante a **REMOÇÃO** de ferramentas, o sistema agora:
1. **Para a 1cm antes** do estacionamento (`tool_y - 10`)
2. **Abre o servo** automaticamente (facilita desconexão)
3. **Avança para posição final** de remoção
4. **Retorna com servo aberto** para buscar próxima ferramenta

**Benefícios da melhoria na remoção:**
- ✅ **Facilita desconexão** da ferramenta atual
- ✅ **Servo já aberto** para próximo carregamento
- ✅ **Reduz stress mecânico** no sistema de acoplamento
- ✅ **Processo mais suave** de troca de ferramentas

### Vantagens
- ✅ Permite correção de ferramentas mal posicionadas
- ✅ Sempre abre servo a distância segura (1cm)
- ✅ Mantém estado da ferramenta ativa
- ✅ Não força trocas desnecessárias

## 🔧 Comandos de Diagnóstico e Correção

### Comandos de Verificação
- `STATUS_CALIBRACAO_MULTI` - Status do sistema de calibração
- `INFO_CALIBRACAO_MULTI` - Informações detalhadas dos offsets
- `VERIFICAR_ESTADO_FERRAMENTA` - Verifica consistência entre estado salvo e físico
- `PRE_PRINT_CHECK` - Verificação completa antes da impressão
- `DIAGNOSTICO_COMPLETO` - Análise completa do sistema
- `DIAGNOSTICO_TROMBAMENTO` - Análise específica de risco de trombamento

### Comandos de Correção
- `RESET_CALIBRACAO_MULTI` - Reset completo do sistema
- `BACKUP_CALIBRACOES_MULTI` - Backup dos offsets atuais
- `CORRIGIR_FERRAMENTA_FISICA TOOL=X` - Força correção para ferramenta específica
- `RESET_FERRAMENTA_SEGURO` - Reset seguro para T0
- `RECARREGAR_FERRAMENTA TOOL=X` - Recarrega ferramenta com abertura a 1cm
- `LIDAR_ON` / `LIDAR_OFF` - Controle do LIDAR

## ⚡ Novo Comportamento do STARTUP

### Lógica Atualizada (v2.0)

**ANTES (Problemático):**
- Sem ferramenta física → Forçava T0 automaticamente
- Podia causar inconsistências e trombamentos

**AGORA (Seguro):**
- ✅ **Com ferramenta física detectada** → Restaura estado salvo normalmente
- ⏳ **Sem ferramenta física detectada** → **AGUARDA comando manual**
  - Sistema fica em estado "vazio" (TOOL=0)
  - Display mostra "Aguardando ferramenta..."
  - Usuário deve escolher: `T0`, `T1` ou `T2`
  - **NUNCA força ferramenta automaticamente**

### Vantagens da Nova Lógica
- 🛡️ **Segurança**: Elimina forçamento automático de ferramentas
- 🎯 **Controle**: Usuário sempre decide qual ferramenta usar
- 🔄 **Flexibilidade**: Permite recarregamento da mesma ferramenta
- ⚠️ **Prevenção**: Evita trombamentos por estados inconsistentes

### Vantagens

- **Simplicidade**: Usa interface familiar do KlipperScreen
- **Automático**: Detecta ferramenta ativa automaticamente
- **Organizado**: T0 em printer.cfg, T1/T2 em variables.cfg
- **Seguro**: Validações e verificações automáticas
- **Compatível**: Funciona com sistema existente

## ⚠️ CENÁRIO DO PROBLEMA ORIGINAL

### Situação Relatada:
1. Usuário finalizou impressão com T2 carregada (`tool = 3` salvo em variables.cfg)
2. Sistema foi reiniciado
3. Na inicialização, sistema assumiu T0 em vez de T2
4. Tentativa de usar T0 causou trombamento de ferramenta

### Causa Raiz Identificada:
- **LIDAR deve iniciar SEMPRE ATIVADO** (`variable_status: True`)
- `STARTUP` usava valor simulado (100.0mm) em vez de leitura real
- Valor simulado (100.0mm ≤ 110mm) fazia sistema pensar que havia ferramenta física
- Mas lógica original forçava T0 quando não detectava ferramenta
- **Contradição**: Sistema detectava "ferramenta" mas forçava T0

### Problema Anterior:
1. `STARTUP` com LIDAR desativado usava valor simulado inconsistente
2. Sistema forçava T0 mesmo com T2 salva
3. `T0` chamava `TROCA TOOL=1` 
4. `TROCA` sempre executava devido a `{% if true %}`
5. Sistema tentava descarregar ferramenta inexistente (T0) e carregar T0
6. **Resultado**: Trombamento por estado inconsistente

### Solução Implementada:
1. **Correção da condição TROCA**: `{% if true %}` → `{% if active_tool != tool %}`
2. **Nova lógica STARTUP**:
   - Se LIDAR ativo: verifica presença física real
   - Se LIDAR desativado: **confia no estado salvo** (T2)
   - Elimina contradições entre detecção e ação
3. **Diagnóstico específico**: Nova macro `DIAGNOSTICO_TROMBAMENTO`
4. **Verificação robusta**: Sistema agora detecta e corrige inconsistências

### Fluxo Correto Atual:
1. Sistema reinicia com T2 salva e LIDAR desativado
2. `STARTUP` confia no estado salvo e restaura T2
3. `T0` chama `TROCA TOOL=1`
4. `TROCA` verifica `active_tool (3) != tool (1)` e executa troca
5. T2 é corretamente descarregada, T0 é carregada
6. **Resultado**: Troca suave sem trombamento

## 🚀 PRÓXIMOS PASSOS

### 1. **Reiniciar Klipper**
```bash
sudo systemctl restart klipper
```

### 2. **Testar Inicialização**
```gcode
STARTUP                    # Verificar se detecta ferramenta correta
VERIFICAR_ESTADO_FERRAMENTA # Confirmar estados
```

### 3. **Testar Troca de Ferramentas**
```gcode
T0  # Deve verificar se já está ativa antes de trocar
T1  # Deve trocar apenas se necessário
T2  # Deve trocar apenas se necessário
```

### 4. **Testar Cenário Original**
1. Carregar T2 fisicamente
2. Executar `CORRIGIR_FERRAMENTA_FISICA TOOL=3`
3. Simular reinício com `STARTUP`
4. Executar `T0` e verificar se troca funciona corretamente

## 📊 BENEFÍCIOS DAS CORREÇÕES

✅ **Detecção Física**: Sistema verifica realidade física vs estado salvo
✅ **Prevenção de Erros**: Evita tentativas de troca desnecessárias
✅ **Sincronização**: Garante que extrusora correta está ativa
✅ **Diagnóstico**: Ferramentas completas para identificar problemas
✅ **Recuperação**: Capacidade de corrigir estados inconsistentes
✅ **Segurança**: Reset automático para estado seguro quando necessário

## 🔧 MANUTENÇÃO

### Logs Importantes:
- Mensagens de `STARTUP` mostram detecção LIDAR
- Mensagens de `TROCA` indicam se troca foi necessária
- Mensagens de verificação mostram estados detectados

### Monitoramento:
- Execute `PRE_PRINT_CHECK` antes de impressões importantes
- Use `VERIFICAR_ESTADO_FERRAMENTA` se houver comportamento estranho
- Mantenha `LIDAR_MODE` ativo para detecção precisa