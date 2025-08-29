# Posição do Sensor Instalado

## Coordenadas de Instalação

**Sensor instalado na posição:**
- **X**: 320mm
- **Y**: 100mm

## Configurações Relacionadas

### Limite Máximo do Eixo X
- **Anterior**: 315mm
- **Atual**: 325mm (aumentado 10mm para acomodar o sensor)
- **Arquivo**: `printer.cfg` - seção `[stepper_x]`

### Verificações de Segurança

✅ **Position_max atualizado**: 325mm permite acesso à posição X320
✅ **Margem de segurança**: 5mm além da posição do sensor
✅ **Coordenada Y**: 100mm está dentro dos limites padrão

## Comandos de Teste

### Teste de Movimento para a Posição do Sensor
```gcode
; Mover para a posição do sensor
G28                    ; Home all axes
G1 X320 Y100 Z10 F3000 ; Mover para posição do sensor
```

### Verificação de Limites
```gcode
; Verificar se a posição está acessível
G1 X325 Y100 Z10 F3000 ; Teste do limite máximo
G1 X320 Y100 Z10 F3000 ; Retornar à posição do sensor
```

## Macros Relacionadas

O sensor nesta posição pode ser usado para:
- Calibração automática de offsets Z
- Verificação de alinhamento de ferramentas
- Detecção de altura de bico
- Calibração de sistema multi-tool

## Notas Importantes

⚠️ **Atenção**: Sempre verificar que não há obstáculos na trajetória até X320 Y100
⚠️ **Segurança**: Confirmar que o sensor está firmemente fixado nesta posição
⚠️ **Calibração**: Após instalação, executar calibração do sistema de offsets

---

**Data da instalação**: $(Get-Date -Format 'dd/MM/yyyy HH:mm')
**Configuração aplicada**: Limite X aumentado de 315mm para 325mm