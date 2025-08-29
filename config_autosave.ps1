# Configurador do Sistema de Auto Salvamento
# Permite configurar e ativar o sistema rapidamente

Write-Host "🛠️  CONFIGURADOR DO SISTEMA DE AUTO SALVAMENTO" -ForegroundColor Cyan
Write-Host "="*50

# Verificar se já existe configuração
if (Test-Path "K:\backup") {
    Write-Host "✅ Sistema de backup já configurado" -ForegroundColor Green
} else {
    Write-Host "📁 Criando diretório de backup..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path "K:\backup" -Force | Out-Null
    Write-Host "✅ Diretório de backup criado" -ForegroundColor Green
}

# Opções de configuração
Write-Host ""
Write-Host "OPÇÕES DISPONÍVEIS:" -ForegroundColor White
Write-Host "1. Iniciar Auto Salvamento (Recomendado)" -ForegroundColor Green
Write-Host "2. Configurar Intervalo Personalizado"
Write-Host "3. Visualizar Backups Existentes"
Write-Host "4. Limpar Backups Antigos"
Write-Host "5. Sair"
Write-Host ""

do {
    $choice = Read-Host "Escolha uma opção (1-5)"
    
    switch ($choice) {
        "1" {
            Write-Host "🚀 Iniciando Auto Salvamento com configurações padrão..." -ForegroundColor Green
            Write-Host "   - Intervalo: 30 segundos"
            Write-Host "   - Auto Accept: ATIVADO"
            Write-Host "   - Monitorando: .cfg, .conf, .py, .md"
            Write-Host ""
            Write-Host "Para parar, pressione Ctrl+C" -ForegroundColor Yellow
            Write-Host "="*50
            
            # Executar em background
            Start-Job -ScriptBlock {
                & "K:\auto_save_system.ps1" -AutoAccept
            } -Name "AutoSaveSystem"
            
            Write-Host "✅ Sistema iniciado em background (Job: AutoSaveSystem)" -ForegroundColor Green
            Write-Host "Para verificar status: Get-Job -Name AutoSaveSystem"
            break
        }
        
        "2" {
            $interval = Read-Host "Digite o intervalo em segundos (padrão: 30)"
            if ([string]::IsNullOrEmpty($interval)) { $interval = 30 }
            
            Write-Host "🚀 Iniciando com intervalo de $interval segundos..." -ForegroundColor Green
            
            Start-Job -ScriptBlock {
                param($int)
                & "K:\auto_save_system.ps1" -IntervalSeconds $int -AutoAccept
            } -ArgumentList $interval -Name "AutoSaveSystem"
            
            Write-Host "✅ Sistema iniciado com intervalo personalizado" -ForegroundColor Green
            break
        }
        
        "3" {
            Write-Host "📦 BACKUPS EXISTENTES:" -ForegroundColor Cyan
            if (Test-Path "K:\backup\*.bak") {
                Get-ChildItem "K:\backup\*.bak" | Sort-Object LastWriteTime -Descending | 
                ForEach-Object {
                    Write-Host "   $($_.Name) - $($_.LastWriteTime)" -ForegroundColor White
                }
            } else {
                Write-Host "   Nenhum backup encontrado" -ForegroundColor Yellow
            }
            Write-Host ""
        }
        
        "4" {
            Write-Host "🗑️  Limpando backups antigos..." -ForegroundColor Yellow
            $backups = Get-ChildItem "K:\backup\*.bak" -ErrorAction SilentlyContinue
            if ($backups) {
                $backups | Remove-Item -Force
                Write-Host "✅ $($backups.Count) backups removidos" -ForegroundColor Green
            } else {
                Write-Host "ℹ️  Nenhum backup para remover" -ForegroundColor Blue
            }
            Write-Host ""
        }
        
        "5" {
            Write-Host "👋 Saindo..." -ForegroundColor Blue
            break
        }
        
        default {
            Write-Host "❌ Opção inválida. Escolha 1-5." -ForegroundColor Red
        }
    }
} while ($choice -ne "1" -and $choice -ne "2" -and $choice -ne "5")

Write-Host ""
Write-Host "📋 COMANDOS ÚTEIS:" -ForegroundColor Cyan
Write-Host "   Get-Job -Name AutoSaveSystem     # Verificar status"
Write-Host "   Stop-Job -Name AutoSaveSystem    # Parar sistema"
Write-Host "   Remove-Job -Name AutoSaveSystem  # Remover job"
Write-Host "   Get-Content K:\backup\autosave.log -Tail 10  # Ver últimos logs"
Write-Host ""
Write-Host "Sistema configurado com sucesso! 🎉" -ForegroundColor Green