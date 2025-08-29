# TESTE DA MACRO CALIBRAR_T0_REFERENCIA CORRIGIDA

## Status do Problema
- ❌ Erro original: `Malformed command 'CALIBRAR_T0_REFERENCIA'`
- ✅ Macro simplificada e corrigida
- ✅ Sintaxe Jinja2 otimizada
- ✅ Dependências reduzidas

## Alterações Realizadas

### 1. Simplificação da Macro
- Removidas variáveis complexas
- Sintaxe Jinja2 simplificada
- Coordenadas fixas (X320 Y100 Z10)
- Menos verificações condicionais

### 2. Correções Aplicadas
- Remoção de caracteres especiais
- Sintaxe mais limpa
- Menos dependências de configuração

## Como Testar

### 1. Reiniciar Klipper
```
restart
```

### 2. Fazer Home
```
G28
```

### 3. Testar a Macro
```
CALIBRAR_T0_REFERENCIA
```

### 4. Verificar se Funciona
- ✅ Macro executa sem erro "Malformed command"
- ✅ T0 é ativado
- ✅ Posicionamento em X320 Y100 Z10
- ✅ Chamada para MEDIR_DISTANCIA_BICO_TP223
- ✅ Salvamento em variables.cfg

## Resultados Esperados

### Se Funcionar:
```
===== CALIBRACAO T0 COMO REFERENCIA =====
T0 sera usado como base para comparacao
Iniciando medicao com TP223...
T0 calibrado: Z=X.XXXXmm
Referencia salva em variables.cfg
Calibracao T0 concluida!
```

### Se Ainda Falhar:
- Verificar se `calibracao_tp223_automatica.cfg` está carregado
- Verificar se macro `MEDIR_DISTANCIA_BICO_TP223` existe
- Verificar logs do Klipper para erros específicos

## Próximos Passos

1. **Se funcionar**: Testar `CALIBRAR_TODAS_FERRAMENTAS_COMPARATIVO`
2. **Se falhar**: Investigar dependências da macro `MEDIR_DISTANCIA_BICO_TP223`
3. **Após sucesso**: Remover arquivos de teste temporários

## Comandos de Diagnóstico

```bash
# Verificar se macro existe
HELP CALIBRAR_T0_REFERENCIA

# Verificar dependência
HELP MEDIR_DISTANCIA_BICO_TP223

# Listar todas as macros
HELP
```

---
**Data**: Macro simplificada e pronta para teste
**Status**: Aguardando teste após restart do Klipper