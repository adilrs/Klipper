# Script de Inicialização do Sistema de Auto Salvamento
# Executa o sistema de backup automático em background

Write-Host "🔄 Iniciando Sistema de Auto Salvamento Automático..."
Write-Host "📁 Monitorando diretório: K:\"
Write-Host "⏱️  Intervalo de verificação: 30 segundos"
Write-Host "✅ Auto Accept: ATIVADO"
Write-Host "📦 Backups salvos em: K:\backup\"
Write-Host ""
Write-Host "Para parar o sistema, pressione Ctrl+C"
Write-Host "="*50

# Executar o sistema de auto salvamento
try {
    & "K:\auto_save_system.ps1" -AutoAccept
}
catch {
    Write-Host "❌ Erro ao iniciar sistema: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Pressione Enter para sair"
}