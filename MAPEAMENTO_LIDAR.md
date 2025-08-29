# 📊 MAPEAMENTO COMPLETO DAS LEITURAS DO LIDAR

## 🎯 THRESHOLDS E INTERPRETAÇÕES

### 📏 Valores de Referência do LIDAR (VL53L0X)

| Distância (mm) | Interpretação | Ação do Sistema | Localização |
|----------------|---------------|-----------------|-------------|
| **≤ 110mm** | ✅ **FERRAMENTA PRESENTE** | Confirma presença física | `macros.cfg`, `tools.cfg`, `verificacao_ferramenta.cfg` |
| **> 110mm** | ❌ **FERRAMENTA AUSENTE** | Detecta ausência | `macros.cfg`, `tools.cfg` |
| **≤ 140mm** | ✅ **FERRAMENTA NO DOCK** | Confirma ferramenta disponível | `tools.cfg` |
| **> 140mm** | ❌ **DOCK VAZIO** | Ferramenta removida com sucesso | `tools.cfg` |
| **≤ 220mm** | ✅ **FERRAMENTA DETECTADA** | Ferramenta disponível para carregamento | `tools.cfg` |
| **> 220mm** | ❌ **FERRAMENTA AUSENTE** | Dock completamente vazio | `tools.cfg` |

---

## 🔍 ANÁLISE DETALHADA POR CONTEXTO

### 1. **INICIALIZAÇÃO DO SISTEMA** (`macros.cfg` - STARTUP)

```gcode
# Threshold: ≤ 110mm
{% if lidar <= 110 %}
  # ✅ FERRAMENTA FÍSICA DETECTADA
  # → Restaura estado salvo (T0, T1 ou T2)
  # → Confia que a ferramenta salva está realmente presente
{% else %}
  # ❌ NENHUMA FERRAMENTA DETECTADA
  # → Força T0 (estado seguro)
  # → Salva T0 no variables.cfg
{% endif %}
```

**Decisão**: Se há algo físico ≤ 110mm, assume que é a ferramenta salva.

---

### 2. **DETECÇÃO INICIAL NA TROCA** (`tools.cfg` - TROCA)

```gcode
# Threshold: > 110mm
{% if lidar > 110 %}
  # ❌ AUSÊNCIA DETECTADA
  # → Abre trava automaticamente
  # → Prepara para processo de troca
{% endif %}
```

**Decisão**: Se não há nada ≤ 110mm, abre trava preventivamente.

---

### 3. **VALIDAÇÃO DE REMOÇÃO** (`tools.cfg` - Após descarregamento)

```gcode
# Threshold: > 140mm
{% if lidar > 140 %}
  # ✅ FERRAMENTA REMOVIDA COM SUCESSO
  # → Confirma que descarregamento funcionou
  # → Prossegue para carregamento da nova ferramenta
{% else %}
  # ❌ FERRAMENTA AINDA PRESA
  # → Erro: ferramenta não foi removida
  # → Pausa processo para segurança
{% endif %}
```

**Decisão**: Precisa de > 140mm para confirmar remoção completa.

---

### 4. **VERIFICAÇÃO DE DISPONIBILIDADE NO DOCK** (`tools.cfg` - Antes do carregamento)

```gcode
# Threshold: ≤ 220mm
{% if lidar <= 220 %}
  # ✅ FERRAMENTA DISPONÍVEL NO DOCK
  # → Ferramenta está no dock e pode ser carregada
  # → Prossegue com carregamento
{% else %}
  # ❌ DOCK VAZIO
  # → Ferramenta não está disponível
  # → Pausa impressão
{% endif %}
```

**Decisão**: Até 220mm considera que há ferramenta no dock.

---

### 5. **CONFIRMAÇÃO FINAL DE CARREGAMENTO** (`tools.cfg` - Após carregamento)

```gcode
# Threshold: ≤ 110mm
{% if lidar_validacao <= 110 %}
  # ✅ FERRAMENTA CARREGADA COM SUCESSO
  # → Executa limpeza do bico
  # → Aplica offsets
  # → Confirma troca completa
{% else %}
  # ❌ FERRAMENTA NÃO CONFIRMADA
  # → Pula limpeza
  # → Aplica offsets mesmo assim (fallback)
{% endif %}
```

**Decisão**: ≤ 110mm confirma que ferramenta foi carregada corretamente.

---

### 6. **VERIFICAÇÃO DE ESTADO** (`verificacao_ferramenta.cfg`)

```gcode
# Threshold: ≤ 110mm
{% if lidar <= 110 %}
  # ✅ FERRAMENTA FÍSICA DETECTADA
  # → Verifica se estado salvo está correto
  # → Sincroniza estados se necessário
{% else %}
  # ❌ NENHUMA FERRAMENTA DETECTADA
  # → Força T0 se estado não estiver correto
  # → Corrige inconsistências
{% endif %}
```

---

## 🚨 VALORES SIMULADOS (LIDAR DESATIVADO)

| Contexto | Valor Simulado | Interpretação |
|----------|----------------|---------------|
| **Inicialização** | `100.0mm` | ≤ 110mm → "Ferramenta presente" |
| **Remoção** | `150.0mm` | > 140mm → "Removida com sucesso" |
| **Carregamento** | `110.0mm` | ≤ 110mm → "Carregada com sucesso" |
| **Dock vazio** | `150.0mm` | ≤ 220mm → "Ferramenta disponível" |

**⚠️ PROBLEMA**: Valores simulados podem causar interpretações incorretas!

---

## 🎯 LÓGICA DE DECISÃO RESUMIDA

### **Presença de Ferramenta Carregada**
- **≤ 110mm**: Ferramenta está carregada no cabeçote
- **> 110mm**: Cabeçote vazio

### **Estado do Dock**
- **≤ 140mm**: Ferramenta ainda no dock (não removida)
- **> 140mm e ≤ 220mm**: Ferramenta removida, dock ainda tem ferramenta
- **> 220mm**: Dock completamente vazio

### **Validação de Operações**
- **Remoção bem-sucedida**: > 140mm
- **Carregamento bem-sucedido**: ≤ 110mm
- **Ferramenta disponível para carregamento**: ≤ 220mm

---

## 🔧 RECOMENDAÇÕES PARA TOMADA DE DECISÃO

### 1. **Para Inicialização Segura**
```gcode
# Sempre ativar LIDAR antes de inicializar
LIDAR_ON
STARTUP
```

### 2. **Para Diagnóstico de Problemas**
```gcode
# Verificar leitura atual
STATUS_VL53

# Verificar estado do sistema
VERIFICAR_ESTADO_FERRAMENTA

# Diagnóstico específico para trombamento
DIAGNOSTICO_TROMBAMENTO
```

### 3. **Para Correção Manual**
```gcode
# Se LIDAR mostra ≤ 110mm mas sistema pensa que não há ferramenta
CORRIGIR_FERRAMENTA_FISICA TOOL=2  # Para T1
CORRIGIR_FERRAMENTA_FISICA TOOL=3  # Para T2

# Se LIDAR mostra > 110mm mas sistema pensa que há ferramenta
RESET_FERRAMENTA_SEGURO
```

### 4. **Para Monitoramento Contínuo**
```gcode
# Antes de cada impressão
PRE_PRINT_CHECK

# Se comportamento estranho
STATUS_VL53
VERIFICAR_ESTADO_FERRAMENTA
```

---

## 📊 TABELA DE TROUBLESHOOTING

| Leitura LIDAR | Estado Salvo | Estado Atual | Diagnóstico | Ação Recomendada |
|---------------|--------------|--------------|-------------|-------------------|
| ≤ 110mm | T1 (tool=2) | T0 (tool=1) | ⚠️ Dessincronizado | `CORRIGIR_FERRAMENTA_FISICA TOOL=2` |
| ≤ 110mm | T2 (tool=3) | T0 (tool=1) | ⚠️ Dessincronizado | `CORRIGIR_FERRAMENTA_FISICA TOOL=3` |
| > 110mm | T1 (tool=2) | T1 (tool=2) | ❌ Inconsistente | `RESET_FERRAMENTA_SEGURO` |
| > 110mm | T0 (tool=1) | T0 (tool=1) | ✅ Correto | Nenhuma ação necessária |
| ≤ 110mm | T0 (tool=1) | T0 (tool=1) | ✅ Correto | Nenhuma ação necessária |

---

## 🎯 CONCLUSÃO

O sistema usa **três thresholds principais**:
- **110mm**: Limite para presença de ferramenta carregada
- **140mm**: Limite para confirmação de remoção
- **220mm**: Limite para disponibilidade no dock

Com o **LIDAR sempre ativado** (`variable_status: True`), o sistema pode tomar decisões precisas baseadas na realidade física, evitando trombamentos e inconsistências de estado.