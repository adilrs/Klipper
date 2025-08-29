# 🎯 GUIA: Teste de Offset Sensor Piezoelétrico vs BLTouch

## 📍 Situação Atual

- **BLTouch**: Configurado com offset `X40 Y-50` (relativo ao bico)
- **Sensor Piezoelétrico**: Instalado na posição absoluta `X320 Y100`
- **Z_Offset**: -0.9mm (sensor localizado 0.9mm abaixo da mesa)
- **Problema**: BLTouch fora do alcance da mesa na posição atual

## 🔧 Configuração Necessária

Para usar os arquivos de teste e configuração, adicione ao `printer.cfg`:

```ini
[include TESTE_OFFSET_PIEZO_BLTOUCH.cfg]
[include CONFIGURACAO_PIEZO_COMPLETA.cfg]
```

## 🚀 Procedimento de Teste

### 1. Teste Básico de Offset

```gcode
TESTE_OFFSET_PIEZO_BLTOUCH
```

**O que faz:**
- Executa G28 para estabelecer referência
- Calcula posição absoluta do BLTouch
- Calcula diferença para o sensor piezo
- Testa movimento para ambas as posições
- Exibe os offsets calculados

### 2. Medição Comparativa

```gcode
MEDIR_ALTURA_AMBOS_SENSORES
```

**O que faz:**
- Mede altura com BLTouch na posição de home
- Move para posição do sensor piezo
- Permite testar o sensor piezo
- Compara os resultados

### 3. Guia de Calibração

```gcode
CALIBRAR_OFFSET_PIEZO
```

**O que faz:**
- Exibe procedimento completo de calibração
- Lista comandos necessários
- Fornece template de configuração

## 📊 Interpretação dos Resultados

### Exemplo de Saída Esperada:

```
📌 Posição após G28: X150 Y150 Z10
📍 BLTouch em coordenadas absolutas: X190 Y100
🔧 OFFSET CALCULADO:
   Piezo X320 - BLTouch X190 = 130mm
   Piezo Y100 - BLTouch Y100 = 0mm
```

### Como Usar os Valores:

Se você quiser configurar o sensor piezo como probe principal:


[probe]
pin: !host:gpio22
x_offset: 130    # Valor calculado pelo teste
y_offset: 0      # Valor calculado pelo teste
z_offset: -0.9   # Sensor 0.9mm abaixo da mesa
speed: 5.0
samples: 3
sample_retract_dist: 2.0
samples_result: median
samples_tolerance: 0.01
```

## ⚠️ Considerações Importantes

### Opção 1: Sensor Piezo como Probe Principal
- Comente a seção `[bltouch]` no `printer.cfg`
- Configure `[probe]` com os offsets calculados
- Execute `PROBE_CALIBRATE` para ajustar z_offset

### Opção 2: Manter Ambos os Sensores
- Mantenha BLTouch para home e nivelamento
- Use sensor piezo para calibração de ferramentas
- Configure macros específicas para cada sensor

## 🔍 Comandos de Verificação

```gcode
# Verificar status do probe ativo
QUERY_PROBE

# Mover para posição do sensor piezo
G1 X320 Y100 Z10 F3000

# Testar sensor piezo (se configurado como probe)
PROBE

# Verificar precisão
PROBE_ACCURACY SAMPLES=10
```

## 🛠️ Solução de Problemas

### Se o BLTouch estiver fora da mesa:
1. Execute `TESTE_OFFSET_PIEZO_BLTOUCH` para calcular offsets
2. Configure sensor piezo como probe principal
3. Use BLTouch apenas para home (se necessário)

### Se houver conflito de GPIO:
- Verifique se apenas um sensor está ativo por vez
- Use `QUERY_PROBE` para confirmar qual está respondendo

### Se os offsets estiverem incorretos:
1. Verifique se G28 foi executado corretamente
2. Confirme as posições físicas dos sensores
3. Recalcule usando `TESTE_OFFSET_PIEZO_BLTOUCH`

## 📋 Checklist de Configuração

- [ ] Arquivo `TESTE_OFFSET_PIEZO_BLTOUCH.cfg` incluído no `printer.cfg`
- [ ] Executado `TESTE_OFFSET_PIEZO_BLTOUCH`
- [ ] Anotados os valores de offset X e Y
- [ ] Configurado `[probe]` com os offsets calculados
- [ ] Executado `RESTART`
- [ ] Executado `PROBE_CALIBRATE` para ajustar z_offset
- [ ] Testado `PROBE_ACCURACY` para verificar precisão

## 🎯 Próximos Passos

1. **Execute o teste**: `TESTE_OFFSET_PIEZO_BLTOUCH`
2. **Anote os resultados**: Valores de offset X e Y
3. **Configure o probe**: Use os valores no `[probe]`
4. **Calibre o Z**: Execute `PROBE_CALIBRATE`
5. **Teste a precisão**: Execute `PROBE_ACCURACY SAMPLES=10`

Com essa configuração, você terá um sistema de probe funcional mesmo com o BLTouch fora do alcance da mesa!