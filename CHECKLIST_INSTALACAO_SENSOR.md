# 📋 CHECKLIST DE INSTALAÇÃO - SISTEMA DE CALIBRAÇÃO AUTOMÁTICA XYZ

## 🎯 VISÃO GERAL
Este checklist garante uma instalação segura e funcional do sistema de calibração automática XYZ completos por toque.

---

## 📦 FASE 1: PREPARAÇÃO E COMPRAS

### Hardware Necessário
- [ ] **Sensor escolhido:**
  - [X] Sensor capacitivo LJ12A3-4-Z/BX (recomendado)
  - [ ] Sensor piezoelétrico
  - [ ] Microswitch de precisão
- [ ] **Cabos e conectores:**
  - [ ] Cabo blindado 3 vias (mínimo 1 metro)
  - [ ] Conector JST ou similar
  - [ ] Terminais para conexão
- [ ] **Fixação:**
  - [ ] Suporte para montagem do sensor
  - [ ] Parafusos M3 ou M4
  - [ ] Abraçadeiras para cabo
- [ ] **Superfície de referência:**
  - [ ] Placa metálica 50x50mm (para capacitivo)
  - [ ] Parafusos de fixação na mesa

### Ferramentas
- [ ] Chaves de fenda e Phillips
- [ ] Alicate desencapador
- [ ] Multímetro
- [ ] Furadeira (se necessário)
- [ ] Lima para ajustes

---

## ⚡ FASE 2: INSTALAÇÃO ELÉTRICA

### Conexões do Sensor
- [ ] **Identificar pinos do sensor:**
  - [ ] VCC (12V ou 24V)
  - [ ] GND (Terra)
  - [ ] Signal (Sinal)
- [ ] **Conectar na placa:**
  - [ ] VCC → Fonte 12V/24V
  - [ ] GND → Terra da placa
  - [ ] Signal → Pin de entrada (ex: PC4)
- [ ] **Testar continuidade:**
  - [ ] Verificar com multímetro
  - [ ] Confirmar isolamento

### Verificação Elétrica
- [ ] **Teste de alimentação:**
  - [ ] Medir tensão VCC
  - [ ] Verificar terra
- [ ] **Teste de sinal:**
  - [ ] Estado livre (HIGH/LOW)
  - [ ] Estado acionado (LOW/HIGH)
- [ ] **Isolamento:**
  - [ ] Verificar não há curto-circuito
  - [ ] Testar resistência de isolamento

---

## 🔧 FASE 3: MONTAGEM MECÂNICA

### Posicionamento do Sensor
- [ ] **Localização ideal:**
  - [ ] Próximo ao bico (máximo 50mm)
  - [ ] Acesso fácil para manutenção
  - [ ] Protegido de colisões
- [ ] **Alinhamento:**
  - [ ] Sensor perpendicular à mesa
  - [ ] Distância uniforme da superfície
  - [ ] Sem interferência com movimento

### Fixação da Superfície de Referência
- [ ] **Posicionamento:**
  - [ ] Centro da mesa ou área específica
  - [ ] Superfície nivelada
  - [ ] Fácil acesso para todas as ferramentas
- [ ] **Fixação segura:**
  - [ ] Parafusos bem apertados
  - [ ] Superfície estável
  - [ ] Sem movimento durante teste

---

## 💻 FASE 4: CONFIGURAÇÃO SOFTWARE

### Arquivos de Configuração
- [ ] **Copiar arquivos:**
  - [ ] `calibracao_automatica_toque.cfg`
  - [ ] `exemplo_implementacao_sensor.cfg`
- [ ] **Incluir no printer.cfg:**
  ```
  [include calibracao_automatica_toque.cfg]
  ```
- [ ] **Configurar sensor específico:**
  - [ ] Escolher configuração do tipo de sensor
  - [ ] Ajustar pin de conexão
  - [ ] Definir offsets iniciais

### Configuração Inicial
- [ ] **Definir parâmetros básicos:**
  ```
  [probe]
  pin: ^PC4                    # Ajustar conforme conexão
  x_offset: 0
  y_offset: 0
  z_offset: 0.5               # Calibrar posteriormente
  speed: 3
  samples: 3
  ```
- [ ] **Configurar posição de referência:**
  ```
  CALIBRACAO_AUTO_CONFIG X=100 Y=310
  ```

---

## 🧪 FASE 5: TESTES INICIAIS

### Teste de Conectividade
- [ ] **Reiniciar Klipper:**
  - [ ] Verificar se não há erros
  - [ ] Confirmar sensor reconhecido
- [ ] **Teste básico:**
  ```
  TESTE_SENSOR_BASICO
  ```
- [ ] **Verificar estados:**
  ```
  VERIFICAR_ESTADO_SENSOR
  ```

### Teste de Movimento
- [ ] **Homing seguro:**
  - [ ] G28 sem erros
  - [ ] Movimentos suaves
- [ ] **Posicionamento:**
  - [ ] Mover sobre superfície de referência
  - [ ] Verificar clearance

---

## 🎯 FASE 6: CALIBRAÇÃO

### Calibração do Offset
- [ ] **Aquecimento:**
  - [ ] Aquecer hotend para temperatura de trabalho
  - [ ] Aguardar estabilização
- [ ] **Calibração automática:**
  ```
  CALIBRAR_OFFSET_SENSOR
  ```
- [ ] **Verificação manual:**
  - [ ] Confirmar com papel
  - [ ] Ajustar se necessário

### Teste de Repetibilidade
- [ ] **Teste automático:**
  ```
  TESTE_AUTO_REPETIBILIDADE SAMPLES=10
  ```
- [ ] **Verificar resultados:**
  - [ ] Amplitude < 0.02mm (excelente)
  - [ ] Amplitude < 0.05mm (aceitável)

---

## ✅ FASE 7: VALIDAÇÃO FINAL

### Teste de Todas as Ferramentas
- [ ] **T0 (ferramenta principal):**
  ```
  CALIBRAR_AUTO_FERRAMENTA TOOL=0
  ```
- [ ] **T1:**
  ```
  CALIBRAR_AUTO_FERRAMENTA TOOL=1
  ```
- [ ] **T2:**
  ```
  CALIBRAR_AUTO_FERRAMENTA TOOL=2
  ```
- [ ] **T3:**
  ```
  CALIBRAR_AUTO_FERRAMENTA TOOL=3
  ```

### Testes de Calibração XYZ
- [ ] **Teste de calibração Z individual:**
  ```
  CALIBRAR_AUTO_FERRAMENTA TOOL=extruder
  ```

- [ ] **Teste de calibração X individual:**
  ```
  CALIBRAR_OFFSET_X_AUTO TOOL=extruder
  ```

- [ ] **Teste de calibração Y individual:**
  ```
  CALIBRAR_OFFSET_Y_AUTO TOOL=extruder
  ```

- [ ] **Teste de calibração XYZ completa:**
  ```
  CALIBRAR_XYZ_AUTO_COMPLETO TOOL=extruder
  ```

- [ ] **Teste de calibração todas as ferramentas XYZ:**
  ```
  CALIBRAR_TODAS_FERRAMENTAS_XYZ
  ```

### Teste de Impressão
- [ ] **Impressão de teste:**
  - [ ] Usar modelo simples
  - [ ] Verificar primeira camada
  - [ ] Confirmar aderência uniforme
- [ ] **Troca de ferramentas:**
  - [ ] Testar mudança T0→T1
  - [ ] Verificar offsets aplicados
  - [ ] Confirmar qualidade

---

## 🔧 FASE 8: OTIMIZAÇÃO

### Ajustes Finos
- [ ] **Velocidade de sondagem:**
  - [ ] Testar velocidades 1-5 mm/s
  - [ ] Encontrar melhor compromisso velocidade/precisão
- [ ] **Número de amostras:**
  - [ ] Testar 3, 5, 7 amostras
  - [ ] Balancear precisão vs tempo
- [ ] **Tolerância:**
  - [ ] Ajustar conforme repetibilidade
  - [ ] Valores típicos: 0.005-0.020mm

### Integração com Sistema Existente
- [ ] **Substituir comandos manuais:**
  - [ ] Atualizar macros de start
  - [ ] Modificar rotinas de troca
- [ ] **Criar atalhos:**
  - [ ] Adicionar botões no KlipperScreen
  - [ ] Configurar macros rápidas

---

## 📊 FASE 9: DOCUMENTAÇÃO

### Registro de Configuração
- [ ] **Anotar configurações finais:**
  - [ ] Tipo de sensor usado
  - [ ] Pin de conexão
  - [ ] Offsets calibrados
  - [ ] Parâmetros otimizados
- [ ] **Criar backup:**
  - [ ] Salvar configuração atual
  - [ ] Documentar alterações

### Manual de Operação
- [ ] **Comandos principais:**
  - [ ] Lista de macros disponíveis
  - [ ] Procedimentos de calibração
  - [ ] Solução de problemas
- [ ] **Manutenção:**
  - [ ] Rotina semanal
  - [ ] Verificações mensais
  - [ ] Sinais de problemas

---

## 🚨 SOLUÇÃO DE PROBLEMAS

### Problemas Comuns
- [ ] **Sensor não responde:**
  - [ ] Verificar alimentação
  - [ ] Testar continuidade
  - [ ] Confirmar configuração pin
- [ ] **Leituras inconsistentes:**
  - [ ] Verificar fixação
  - [ ] Limpar superfície
  - [ ] Ajustar sensibilidade
- [ ] **Erro de sondagem:**
  - [ ] Verificar altura inicial
  - [ ] Confirmar limites de movimento
  - [ ] Testar manualmente

### Contatos de Suporte
- [ ] **Documentação salva em:**
  - [ ] Local: `k:\GUIA_IMPLEMENTACAO_CALIBRACAO_AUTO.md`
  - [ ] Backup: [especificar local]
- [ ] **Configurações em:**
  - [ ] `k:\calibracao_automatica_toque.cfg`
  - [ ] `k:\exemplo_implementacao_sensor.cfg`

---

## 📈 RESULTADOS ESPERADOS

### Precisão
- [ ] **Repetibilidade:** < 0.02mm
- [ ] **Tempo de calibração:** < 2 minutos por ferramenta
- [ ] **Confiabilidade:** > 99% de sucessos

### Benefícios
- [ ] **Redução de tempo:** 80% menos tempo de setup
- [ ] **Consistência:** Eliminação de erro humano
- [ ] **Facilidade:** Operação com um comando

---

## ✅ INSTALAÇÃO CONCLUÍDA

**Data da instalação:** _______________

**Responsável:** _______________

**Sensor instalado:** _______________

**Configurações finais salvas:** [ ]

**Testes aprovados:** [ ]

**Sistema em produção:** [ ]

---

**🎉 PARABÉNS! Sistema de calibração automática instalado com sucesso!**

O sistema agora permite:
- ✅ Calibração automática de todas as ferramentas
- ✅ Precisão consistente e repetível
- ✅ Operação simplificada
- ✅ Redução significativa de tempo de setup

Para suporte adicional, consulte:
- `GUIA_IMPLEMENTACAO_CALIBRACAO_AUTO.md`
- `exemplo_implementacao_sensor.cfg`
- Documentação do Klipper sobre probes