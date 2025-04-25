# strip-bom-dotnet.ps1
# À lancer depuis la racine de MeteoApp

Get-ChildItem -Path .\app\src\main\java -Filter *.java -Recurse | ForEach-Object {
    $path = $_.FullName
    # Lire tout le texte (en détectant automatiquement l'encodage existant)
    $text = [System.IO.File]::ReadAllText($path)
    # Réécrire en UTF8 sans BOM
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($path, $text, $utf8NoBom)
    Write-Host "✅ BOM removed: $path"
}
