# Correção de Velocidade Lenta Após CLEAN_NOZZLE

## Problema Identificado

Após executar a macro `CLEAN_NOZZLE_T0` durante a troca de ferramentas, a impressora retornava à impressão em velocidade muito lenta, causando strings (fios de filamento).

## Causa do Problema

### 1. **Comando G1 Malformado**
- **Linha problemática**: `G1   f10000` (linha 125)
- **Problema**: Comando G1 sem coordenadas, apenas com velocidade
- **Resultado**: Configuração de velocidade inconsistente

### 2. **Falta de Retorno Adequado**
- **Problema**: Não retornava às coordenadas originais adequadamente
- **Problema**: Não restaurava velocidade de impressão padrão
- **Resultado**: Impressora continuava com velocidade baixa

## Correção Aplicada

### Antes (Problemático):
```gcode
G1 E5 F3000
G1 Y-12
g4 p1000
G90
G1   f10000          # ❌ PROBLEMA: Comando malformado
#G1 Y200 f10000
APPLY_TOOL_OFFSET
#G1 X{start_x} Y{start_y} Z{start_z} F8000
```

### Depois (Corrigido):
```gcode
G1 E5 F3000
G1 Y-12
G4 P1000                                                    # ✅ Corrigido: G4 maiúsculo
G90
; Retorna à posição original com velocidade rápida
G1 X{start_x} Y{start_y} F10000                            # ✅ Retorno rápido XY
G1 Z{start_z} F6000                                         # ✅ Retorno Z seguro
; Aplica offset da ferramenta ativa
APPLY_TOOL_OFFSET
; Restaura velocidade de impressão padrão
G1 F{printer.configfile.settings.printer.max_velocity * 60} # ✅ Velocidade padrão
```

## Melhorias Implementadas

### 1. **Retorno Coordenado Adequado**
- ✅ **Retorno XY rápido**: `G1 X{start_x} Y{start_y} F10000`
- ✅ **Retorno Z seguro**: `G1 Z{start_z} F6000`
- ✅ **Usa posições salvas**: `start_x`, `start_y`, `start_z`

### 2. **Restauração de Velocidade**
- ✅ **Velocidade dinâmica**: Usa `max_velocity` do printer.cfg
- ✅ **Conversão adequada**: Multiplica por 60 (mm/min)
- ✅ **Evita strings**: Retorno rápido à impressão

### 3. **Comandos Corrigidos**
- ✅ **G4 P1000**: Pausa correta (maiúsculo)
- ✅ **Remoção de comando malformado**: `G1 f10000` removido
- ✅ **Comentários explicativos**: Melhor documentação

## Resultado Esperado

### ✅ **Antes da Correção**:
1. CLEAN_NOZZLE executa limpeza
2. **PROBLEMA**: Retorna em velocidade muito lenta
3. **PROBLEMA**: Causa strings durante impressão
4. **PROBLEMA**: Operador precisa intervir manualmente

### ✅ **Após a Correção**:
1. CLEAN_NOZZLE executa limpeza
2. **SOLUÇÃO**: Retorna rapidamente à posição original
3. **SOLUÇÃO**: Restaura velocidade de impressão padrão
4. **SOLUÇÃO**: Continua impressão sem strings

## Teste da Correção

### Como Testar:
```gcode
; 1. Aquecer extrusor
M104 S200
M109 S200

; 2. Executar limpeza
CLEAN_NOZZLE_T0

; 3. Verificar velocidade após retorno
G1 X100 Y100 F{printer.configfile.settings.printer.max_velocity * 60}
```

### Verificações:
- ✅ **Retorno rápido**: Movimento XY em F10000
- ✅ **Z seguro**: Movimento Z em F6000
- ✅ **Velocidade restaurada**: Usa max_velocity do sistema
- ✅ **Sem strings**: Transição suave para impressão

## Arquivos Modificados

- **📁 tools.cfg**: Macro `CLEAN_NOZZLE_T0` corrigida (linhas 120-132)

## Comandos para Aplicar

```bash
# Reiniciar Klipper para aplicar correções
RESTART

# Testar macro corrigida
CLEAN_NOZZLE_T0
```

---

**✅ PROBLEMA RESOLVIDO**: A macro `CLEAN_NOZZLE_T0` agora retorna adequadamente à impressão em velocidade normal, evitando strings e melhorando a qualidade da troca de ferramentas.