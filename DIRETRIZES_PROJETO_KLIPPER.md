# DIRETRIZES DO PROJETO KLIPPER - SISTEMA DUAL PROBE

## 🌐 INFORMAÇÕES DE REDE DA IMPRESSORA

**IP da Impressora:** `192.168.0.16`
- **Moonraker API:** `http://192.168.0.16:7125`
- **Interface Web:** `http://192.168.0.16`
- **KlipperScreen:** Interface local na impressora

### Comandos Úteis de Conexão
```bash
# Reiniciar firmware
curl -X POST http://192.168.0.16:7125/printer/firmware_restart

# Status da impressora
curl http://192.168.0.16:7125/printer/info

# Executar comando G-code
curl -X POST http://192.168.0.16:7125/printer/gcode/script -H "Content-Type: application/json" -d '{"script":"G28"}'
```

## 🚨 REGRAS FUNDAMENTAIS DE MODIFICAÇÃO

### ❌ PROIBIÇÕES ABSOLUTAS

1. **NÃO ALTERAR SETORES FUNCIONAIS**
   - Qualquer seção que esteja funcionando corretamente **NÃO DEVE SER MODIFICADA**
   - Configurações PID calibradas e funcionais **DEVEM PERMANECER ATIVAS**
   - Parâmetros de aquecedores validados **NÃO DEVEM SER COMENTADOS**

2. **NÃO COMENTAR CONFIGURAÇÕES ATIVAS**
   - Controles PID de extrusores funcionais
   - Configurações de mesa aquecida calibradas
   - Parâmetros de motores validados
   - Sensores termistores funcionais

3. **NÃO FAZER ALTERAÇÕES DESNECESSÁRIAS**
   - Se não está quebrado, **NÃO CONSERTE**
   - Mudanças devem ter justificativa técnica clara
   - Alterações experimentais devem ser feitas em arquivos separados

### ✅ PRÁTICAS RECOMENDADAS

1. **BACKUP OBRIGATÓRIO**
   - Sempre criar backup antes de qualquer alteração
   - Nomear backups com data/hora: `printer-YYYYMMDD_HHMMSS.cfg`
   - Manter histórico de pelo menos 3 backups funcionais

2. **TESTES ISOLADOS**
   - Novas funcionalidades em arquivos separados
   - Validar individualmente antes de integrar
   - Usar includes para modularizar configurações

3. **DOCUMENTAÇÃO OBRIGATÓRIA**
   - Documentar TODAS as alterações realizadas
   - Explicar o motivo de cada modificação
   - Manter log de mudanças com data e responsável

### 📋 CHECKLIST PRÉ-MODIFICAÇÃO

Antes de qualquer alteração, verificar:

- [ ] A seção está realmente com problema?
- [ ] A alteração é realmente necessária?
- [ ] Existe backup da configuração atual?
- [ ] A mudança foi testada em ambiente isolado?
- [ ] A documentação foi atualizada?

### 🔍 SETORES CRÍTICOS - MÁXIMA ATENÇÃO

1. **Controles PID**
   - `[extruder]`, `[extruder1]`, `[extruder2]`, `[extruder3]`
   - `[heater_bed]`
   - **NUNCA comentar se estão funcionando**

2. **Configurações de Motores**
   - Drivers TMC2209
   - Steps per mm calibrados
   - Correntes de operação validadas

3. **Sensores e Endstops**
   - Termistores calibrados
   - Endstops funcionais
   - Probes validados

### 📝 HISTÓRICO DE PROBLEMAS IDENTIFICADOS

**Data: 27/08/2025**
- **Problema**: Parâmetros PID de aquecedores foram comentados sem justificativa
- **Impacto**: Erro "Option 'control' in section 'heater_bed' must be specified"
- **Resolução**: Descomentados todos os controles PID funcionais
- **Lição**: Configurações funcionais NÃO devem ser alteradas

### 🎯 OBJETIVO DO PROJETO

**Sistema Dual Probe Funcional:**
- BLTouch para mesh bed leveling e homing
- Sensor piezoelétrico para calibração de offsets de ferramentas
- Toolchanger com 4 extrusores (T0-T3)
- Configuração estável e confiável

## 🔧 ERROS COMUNS DO JINJA2

### ❌ TAGS PROIBIDAS EM MACROS KLIPPER

1. **TAG `{% break %}` NÃO SUPORTADA**
   - **Erro:** `Encountered unknown tag 'break'`
   - **Causa:** Jinja2 no Klipper não suporta a tag `break` dentro de loops
   - **Solução:** Usar variáveis de controle para interromper loops

   ```jinja2
   # ❌ INCORRETO - Causa erro
   {% for i in range(10) %}
       {% if condicao %}
           {% break %}  # ERRO!
       {% endif %}
   {% endfor %}
   
   # ✅ CORRETO - Usar variável de controle
   {% set ns = namespace(continuar=true) %}
   {% for i in range(10) %}
       {% if ns.continuar and condicao %}
           {% set ns.continuar = false %}
       {% endif %}
       {% if ns.continuar %}
           # código do loop
       {% endif %}
   {% endfor %}
   ```

2. **OUTRAS TAGS NÃO SUPORTADAS**
   - `{% continue %}` - Use lógica condicional
   - `{% switch %}` - Use `{% if %}` / `{% elif %}` / `{% else %}`
   - `{% case %}` - Use `{% if %}` / `{% elif %}` / `{% else %}`

### ✅ ALTERNATIVAS RECOMENDADAS

1. **Para controle de fluxo:** Use variáveis namespace
2. **Para condições complexas:** Use `{% if %}` aninhados
3. **Para loops condicionais:** Use filtros Jinja2 como `selectattr()`

## 📏 NOMENCLATURA DE MACROS

### Nomes Longos Devem Ser Reduzidos
Nomes de macros muito longos podem causar problemas no Klipper, incluindo erros "Malformed command".

### ❌ Nomes Problemáticos (EVITAR)
```cfg
[gcode_macro CALIBRACAO_AUTOMATICA_COMPLETA_MULTITOOLS_TP223]
[gcode_macro TESTE_PRECISAO_SENSOR_PIEZOELETRICO_INDEPENDENTE]
[gcode_macro CONFIGURACAO_AVANCADA_SISTEMA_DUAL_PROBE_COMPLETO]
```

### ✅ Nomes Recomendados (USAR)
```cfg
[gcode_macro CAL_TP223]
[gcode_macro TST_PIEZO]
[gcode_macro CFG_DUAL]
```

### Diretrizes de Nomenclatura
1. **Máximo 10 caracteres** por nome de macro
2. **Evite raízes (prefixos) iguais** entre macros
3. **Use abreviações** quando necessário
4. **Mantenha clareza** mesmo com nomes curtos
5. **Evite underscores excessivos**
6. **Prefira nomes únicos** e distintos

### Abreviações Recomendadas
- `CALIBRACAO` → `CAL`
- `AUTOMATICA` → `AUTO`
- `CONFIGURACAO` → `CFG`
- `INDEPENDENTE` → `IND`
- `MULTITOOLS` → `MT`
- `PIEZOELETRICO` → `PZ`
- `TEMPERATURA` → `TMP`
- `TESTE` → `TST`
- `SENSOR` → `SNR`
- `OFFSET` → `OFS`

### ⚠️ RESPONSABILIDADES

- **Desenvolvedor**: Seguir estas diretrizes rigorosamente
- **Usuário**: Reportar problemas antes de fazer alterações
- **Sistema**: Manter funcionalidade e estabilidade

---

**LEMBRE-SE: A estabilidade do sistema é prioridade máxima!**

*Documento criado em: 27/08/2025*
*Última atualização: 27/08/2025*
*Versão: 1.1*