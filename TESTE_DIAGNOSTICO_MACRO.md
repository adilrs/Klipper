# Diagnóstico do Erro 'Malformed command CALIBRAR_T0_REFERENCIA'

## Status do Problema

O erro `!! Malformed command 'CALIBRAR_T0_REFERENCIA'` persiste mesmo após:
- ✅ Verificação da sintaxe da macro
- ✅ Remoção de caracteres especiais (emojis)
- ✅ Simplificação do código
- ✅ Verificação da inclusão dos arquivos

## Testes para Diagnóstico

### 1. Teste de Macros Simples

Primeiro, teste se as macros básicas funcionam:

```gcode
TESTE_CALIBRAR_T0
```

Se funcionar, teste a versão simplificada:

```gcode
CALIBRAR_T0_REFERENCIA_SIMPLES
```

### 2. Verificar Dependências

Teste se a macro de medição funciona:

```gcode
MEDIR_DISTANCIA_BICO_TP223
```

### 3. Verificar Configuração

Teste a macro de configuração:

```gcode
CALIBRACO_MULTITOOLS_CONFIG
```

## Possíveis Causas

### 1. Problema de Encoding
- Arquivo pode ter caracteres invisíveis
- Encoding UTF-8 com BOM
- Quebras de linha incorretas

### 2. Dependências Circulares
- Macro referencia outra macro não carregada
- Ordem de carregamento incorreta

### 3. Conflito de Nomes
- Macro já definida em outro arquivo
- Conflito com comando nativo do Klipper

### 4. Problema de Sintaxe Jinja2
- Erro em template Jinja2 não detectado
- Variável não definida

## Soluções a Testar

### Solução 1: Recriar Arquivo Limpo

1. Fazer backup do arquivo atual
2. Criar novo arquivo com encoding UTF-8 sem BOM
3. Copiar código linha por linha

### Solução 2: Verificar Ordem de Carregamento

1. Mover include para o final do printer.cfg
2. Verificar se todas as dependências estão carregadas antes

### Solução 3: Renomear Macro

1. Renomear para `CALIBRAR_T0_REF`
2. Testar se funciona com nome mais curto

### Solução 4: Dividir Macro

1. Separar em macros menores
2. Testar cada parte individualmente

## Comandos de Diagnóstico

### Verificar se Macro Existe
```gcode
HELP CALIBRAR_T0_REFERENCIA
```

### Listar Todas as Macros
```gcode
HELP
```

### Verificar Status do Sistema
```gcode
STATUS
```

## Logs para Verificar

1. **klippy.log**: Erros de carregamento
2. **Console do Klipper**: Mensagens de erro em tempo real
3. **Mainsail/Fluidd**: Interface web para comandos

## Próximos Passos

1. **Teste as macros simples** criadas em `teste_macro_simples.cfg`
2. **Se funcionarem**: O problema está na complexidade da macro original
3. **Se não funcionarem**: O problema é mais fundamental (encoding, dependências)

### Se Macros Simples Funcionam:
- Reconstruir macro original gradualmente
- Adicionar uma funcionalidade por vez
- Identificar qual parte causa o erro

### Se Macros Simples Não Funcionam:
- Verificar encoding do arquivo
- Verificar ordem de includes
- Verificar conflitos de nomes

## Arquivo de Teste Criado

- **teste_macro_simples.cfg**: Contém macros básicas para teste
- **Incluído em**: printer.cfg (temporariamente)

## Comandos para Testar Agora

```gcode
# 1. Teste básico
TESTE_CALIBRAR_T0

# 2. Se funcionar, teste a versão simplificada
CALIBRAR_T0_REFERENCIA_SIMPLES

# 3. Verificar se a macro original ainda dá erro
CALIBRAR_T0_REFERENCIA
```

---
**Importante**: Após os testes, remover o include do arquivo de teste do printer.cfg