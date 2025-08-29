# 🔧 Instruções para Teste do Sensor Piezoelétrico

## 📋 Arquivos Criados

1. **`teste_sensor_piezo.cfg`** - Configuração básica e macros principais
2. **`monitor_gpio_avancado.cfg`** - Macros avançadas de monitoramento
3. **`INSTRUCOES_TESTE_SENSOR_PIEZO.md`** - Este arquivo de instruções

## ⚙️ Configuração Inicial

### 1. Adicionar ao printer.cfg

Adicione estas linhas ao seu `printer.cfg`:

```cfg
# Incluir arquivos de teste do sensor piezoelétrico
[include teste_sensor_piezo.cfg]
[include monitor_gpio_avancado.cfg]
```

### 2. Conexões Físicas

```
Raspberry Pi 3 B+ → Placa LM393:
├── Pino 2 (5V) → VCC da placa LM393
├── Pino 6 (GND) → GND da placa LM393
└── Pino 15 (GPIO22) → OUT da placa LM393

Placa LM393 → Sensor Piezoelétrico:
├── IN+ → Pastilha Central do Piezo (parte metálica menor)
└── GND → Anel Externo do Piezo (parte metálica maior)
```

### 3. Reiniciar o Klipper

Após adicionar os includes, reinicie o Klipper:
- No Mainsail/Fluidd: Botão "RESTART"
- Via console: `RESTART`

## 🚀 Guia de Teste Passo a Passo

### Passo 1: Menu Principal
```gcode
MENU_SENSOR_PIEZO
```
Este comando mostra todos os comandos disponíveis.

### Passo 2: Teste Básico
```gcode
TESTE_SENSOR_PIEZO
```
Teste inicial para verificar se o sensor está respondendo.

### Passo 3: Estado Atual
```gcode
QUERY_PROBE
```
Verifica o estado atual do sensor:
- **"open"** = Sensor livre (não pressionado)
- **"TRIGGERED"** = Sensor acionado (pressionado)

### Passo 4: Monitor em Tempo Real
```gcode
MONITOR_TEMPO_REAL DURACAO=30
```
Monitora o sensor por 30 segundos. Pressione e solte o sensor para ver as mudanças.

### Passo 5: Teste de Resposta Rápida
```gcode
TESTE_RESPOSTA_RAPIDA REPETICOES=10
```
Testa a velocidade de resposta com 10 leituras rápidas.

## 🎯 Macros Disponíveis

### Testes Básicos
- `TESTE_SENSOR_PIEZO` - Teste inicial
- `QUERY_PROBE` - Estado atual do sensor
- `AJUDA_SENSOR_PIEZO` - Lista de comandos

### Monitoramento
- `MONITOR_TEMPO_REAL DURACAO=X` - Monitor por X segundos
- `MONITOR_SENSOR_PIEZO DURATION=X INTERVAL=Y` - Monitor com intervalo personalizado
- `MONITOR_CONTINUO_PIEZO CICLOS=X` - X ciclos de monitoramento

### Calibração
- `CALIBRAR_SENSIBILIDADE_PIEZO TESTES=X` - X testes de sensibilidade
- `TESTE_SENSIBILIDADE_NIVEIS` - Teste com diferentes níveis de toque

### Diagnóstico
- `DIAGNOSTICO_SENSOR_PIEZO` - Diagnóstico completo
- `ANALISE_ESTABILIDADE CICLOS=X` - Análise de estabilidade
- `TESTE_RUIDO AMOSTRAS=X` - Detecta interferência
- `CONTADOR_EVENTOS DURACAO=X` - Conta eventos por X segundos

## 🔍 Interpretação dos Resultados

### Estados Normais
- **"Probe: open"** = ✅ Sensor funcionando, não pressionado
- **"Probe: TRIGGERED"** = ✅ Sensor funcionando, pressionado

### Problemas Comuns
- **Sempre "open"**: Sensor não conectado ou sensibilidade muito baixa
- **Sempre "TRIGGERED"**: Sensibilidade muito alta ou curto-circuito
- **Mudanças aleatórias**: Interferência ou conexão ruim

## ⚡ Sequência de Teste Recomendada

1. **Verificação inicial**:
   ```gcode
   MENU_SENSOR_PIEZO
   TESTE_SENSOR_PIEZO
   ```

2. **Teste de conectividade**:
   ```gcode
   QUERY_PROBE
   # Pressione o sensor
   QUERY_PROBE
   # Solte o sensor
   QUERY_PROBE
   ```

3. **Monitor em tempo real**:
   ```gcode
   MONITOR_TEMPO_REAL DURACAO=20
   # Pressione e solte o sensor várias vezes
   ```

4. **Teste de sensibilidade**:
   ```gcode
   TESTE_SENSIBILIDADE_NIVEIS
   # Siga as instruções na tela
   ```

5. **Análise de estabilidade**:
   ```gcode
   ANALISE_ESTABILIDADE CICLOS=20
   # Deixe o sensor em repouso
   ```

6. **Teste de ruído**:
   ```gcode
   TESTE_RUIDO AMOSTRAS=50
   # NÃO toque no sensor
   ```

## 🔧 Ajuste de Sensibilidade

### Placa LM393
- **Potenciômetro no sentido horário**: Aumenta sensibilidade
- **Potenciômetro no sentido anti-horário**: Diminui sensibilidade

### Sinais de Ajuste Necessário
- **Muito sensível**: Sensor dispara sem toque (sempre TRIGGERED)
- **Pouco sensível**: Sensor não dispara mesmo com toque forte (sempre open)
- **Ideal**: Dispara com toque leve, mas não com vibração da impressora

## 📊 Monitoramento Durante Impressão

Para testar durante uma impressão (cuidado!):
```gcode
MONITOR_SENSOR_PIEZO DURATION=10 INTERVAL=1
```

## ⚠️ Dicas Importantes

1. **Sempre teste sem impressão primeiro**
2. **Ajuste a sensibilidade gradualmente**
3. **Verifique as conexões se houver comportamento errático**
4. **O sensor deve ser estável quando não tocado**
5. **Use `EMERGENCY_STOP` se algo der errado**

## 🆘 Solução de Problemas

### Sensor não responde
- Verifique conexões físicas
- Confirme se o GPIO 22 está livre
- Teste com `QUERY_PROBE`

### Sensor sempre acionado
- Diminua a sensibilidade (potenciômetro)
- Verifique se não há curto-circuito
- Verifique a polaridade do piezo

### Leituras inconsistentes
- Execute `TESTE_RUIDO` para detectar interferência
- Verifique soldas e conexões
- Considere blindagem dos fios

## 📝 Log de Testes

Anote os resultados dos seus testes:

```
Data: ___________
Teste: TESTE_SENSOR_PIEZO
Resultado: ________________

Teste: MONITOR_TEMPO_REAL
Duração: _______ segundos
Comportamento: ____________

Ajuste de sensibilidade:
Posição do potenciômetro: ___
Sensibilidade: ____________

Observações:
_____________________________
_____________________________
```

---

**✅ Sistema pronto para teste!**

Comece com `MENU_SENSOR_PIEZO` para ver todas as opções disponíveis.