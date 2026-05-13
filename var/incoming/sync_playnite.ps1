# Nisaba Playnite Sync Script (High Fidelity Metadata)
$NisabaUrl = "http://192.168.3.174:8090/api/sync/playnite"
$ApiSecret = "booboo" 
$BatchSize = 25 # Balanced size

if ($null -eq $PlayniteApi) { $PlayniteApi = [Playnite.SDK.API]::Instance }
$allGames = $PlayniteApi.Database.Games
Write-Host "Total games to sync: $($allGames.Count)"

for ($i = 0; $i -lt $allGames.Count; $i += $BatchSize) {
    $batch = $allGames | Select-Object -Skip $i -First $BatchSize
    $payload = @{ games = @() }
    
    foreach ($g in $batch) {
        if ($null -eq $g) { continue }
        
        # Skip Steam Family Sharing
        if ($g.Categories -and ($g.Categories | Where-Object { $_.Name -eq "Steam Family Sharing" })) {
            continue
        }

        # 1. Basic Metadata
        $source = if ($g.Source) { $g.Source.Name.ToLower() } else { "playnite" }
        $lastPlayed = if ($g.LastActivity) { $g.LastActivity.ToString("yyyy-MM-ddTHH:mm:ssZ") } else { "" }
        
        # 2. Release Date Logic
        $releaseDate = ""
        if ($g.ReleaseDate) {
            $rd = $g.ReleaseDate
            $mm = if ($rd.Month) { $rd.Month } else { 1 }
            $dd = if ($rd.Day) { $rd.Day } else { 1 }
            $releaseDate = "{0:D4}-{1:D2}-{2:D2}" -f $rd.Year, $mm, $dd
        }

        # 3. Platform & Store Logic
        $platforms = if ($g.Platforms) { $g.Platforms | ForEach-Object { $_.Name.ToLower() } } else { @() }
        $storeUrl = ""
        if ($g.Links -and $g.Links.Count -gt 0) {
            $storeUrl = ($g.Links | Where-Object { $_.Name -match "Store|Steam|GOG|Epic" } | Select-Object -First 1).Url
            if (!$storeUrl) { $storeUrl = $g.Links[0].Url }
        }

        $payload.games += [PSCustomObject]@{
            id                = [string]$g.Id.ToString()
            title             = [string]$g.Name
            source            = [string]$source
            store_id          = [string]$g.GameId
            store_url         = [string]$storeUrl
            play_time_minutes = [int]($g.Playtime / 60)
            last_played       = [string]$lastPlayed
            windows           = [bool]($platforms -contains "pc (windows)" -or $platforms -contains "windows")
            mac               = [bool]($platforms -contains "macos" -or $platforms -contains "mac")
            linux             = [bool]($platforms -contains "linux")
            developer         = if ($g.Developers) { [string]($g.Developers | Select-Object -First 1).Name } else { "" }
            publisher         = if ($g.Publishers) { [string]($g.Publishers | Select-Object -First 1).Name } else { "" }
            release_date      = [string]$releaseDate
            description       = "" # Keeping empty to isolate metadata stability
            short_description = ""
        }
    }

    $json = $payload | ConvertTo-Json -Depth 10 -Compress
    Write-Host "Batch $([Math]::Floor($i / $BatchSize) + 1): " -NoNewline
    
    try {
        $headers = @{ "Content-Type" = "application/json" }
        if ($ApiSecret) { $headers.Add("X-Nisaba-Secret", $ApiSecret) }
        $resp = Invoke-RestMethod -Uri $NisabaUrl -Method Post -Body $json -Headers $headers
        Write-Host "OK (+ $($resp.added), ~ $($resp.updated))" -ForegroundColor Green
    } catch {
        Write-Host "FAILED" -ForegroundColor Red
        Write-Error "Error: $_"
        break
    }
}
Write-Host "`nSync Complete!" -ForegroundColor Cyan
