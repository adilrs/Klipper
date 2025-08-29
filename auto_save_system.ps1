# Sistema de Auto Salvamento Automático - Segunda Ordem
# Criado para backup automático de arquivos de configuração Klipper

param(
    [string]$WatchPath = "K:\",
    [int]$IntervalSeconds = 30,
    [switch]$AutoAccept = $true
)

# Configurações
$BackupPath = "K:\backup"
$LogFile = "K:\backup\autosave.log"
$ConfigExtensions = @(".cfg", ".conf", ".py", ".md")

# Função para log
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $Message"
    Write-Host $logEntry
    Add-Content -Path $LogFile -Value $logEntry
}

# Função para criar backup
function Create-Backup {
    param([string]$FilePath)
    
    try {
        $fileName = Split-Path $FilePath -Leaf
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $backupFileName = "${fileName}.${timestamp}.bak"
        $backupFullPath = Join-Path $BackupPath $backupFileName
        
        Copy-Item $FilePath $backupFullPath -Force
        Write-Log "Backup criado: $backupFileName"
        
        # Manter apenas os últimos 10 backups por arquivo
        $baseFileName = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
        $extension = [System.IO.Path]::GetExtension($fileName)
        $pattern = "${baseFileName}${extension}.*.bak"
        
        $oldBackups = Get-ChildItem -Path $BackupPath -Filter $pattern | 
                     Sort-Object LastWriteTime -Descending | 
                     Select-Object -Skip 10
        
        foreach ($oldBackup in $oldBackups) {
            Remove-Item $oldBackup.FullName -Force
            Write-Log "Backup antigo removido: $($oldBackup.Name)"
        }
        
        return $true
    }
    catch {
        Write-Log "Erro ao criar backup de $FilePath : $($_.Exception.Message)"
        return $false
    }
}

# Função para verificar se arquivo deve ser monitorado
function Should-Monitor {
    param([string]$FilePath)
    
    $extension = [System.IO.Path]::GetExtension($FilePath).ToLower()
    return $ConfigExtensions -contains $extension
}

# Inicializar sistema
Write-Log "=== Sistema de Auto Salvamento Iniciado ==="
Write-Log "Monitorando: $WatchPath"
Write-Log "Intervalo: $IntervalSeconds segundos"
Write-Log "Auto Accept: $AutoAccept"
Write-Log "Backup Path: $BackupPath"

# Criar diretório de backup se não existir
if (!(Test-Path $BackupPath)) {
    New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null
    Write-Log "Diretório de backup criado: $BackupPath"
}

# Hashtable para rastrear últimas modificações
$lastModified = @{}

# Loop principal de monitoramento
Write-Log "Iniciando monitoramento automático..."

try {
    while ($true) {
        # Obter todos os arquivos de configuração
        $configFiles = Get-ChildItem -Path $WatchPath -Recurse -File | 
                      Where-Object { Should-Monitor $_.FullName }
        
        foreach ($file in $configFiles) {
            $filePath = $file.FullName
            $currentModified = $file.LastWriteTime
            
            # Verificar se arquivo foi modificado
            if ($lastModified.ContainsKey($filePath)) {
                if ($currentModified -gt $lastModified[$filePath]) {
                    Write-Log "Arquivo modificado detectado: $($file.Name)"
                    
                    if ($AutoAccept) {
                        # Auto accept - criar backup automaticamente
                        if (Create-Backup $filePath) {
                            Write-Log "✅ Auto backup realizado: $($file.Name)"
                            $lastModified[$filePath] = $currentModified
                        }
                    } else {
                        # Solicitar confirmação
                        $response = Read-Host "Arquivo $($file.Name) foi modificado. Criar backup? (S/n)"
                        if ($response -eq "" -or $response.ToLower() -eq "s" -or $response.ToLower() -eq "sim") {
                            if (Create-Backup $filePath) {
                                Write-Log "✅ Backup manual realizado: $($file.Name)"
                                $lastModified[$filePath] = $currentModified
                            }
                        } else {
                            Write-Log "❌ Backup cancelado pelo usuário: $($file.Name)"
                            $lastModified[$filePath] = $currentModified
                        }
                    }
                }
            } else {
                # Primeira vez vendo este arquivo
                $lastModified[$filePath] = $currentModified
                Write-Log "Arquivo adicionado ao monitoramento: $($file.Name)"
            }
        }
        
        # Aguardar próximo ciclo
        Start-Sleep -Seconds $IntervalSeconds
    }
}
catch {
    Write-Log "Erro no sistema de monitoramento: $($_.Exception.Message)"
}
finally {
    Write-Log "=== Sistema de Auto Salvamento Finalizado ==="
}