# Define the paths for the output files
$browsersListPath = "C:\Users\Yuval Kahan\Downloads\login app\DATABASE\broswers current user list.txt"
$defaultBrowserPath = "C:\Users\Yuval Kahan\Downloads\login app\DATABASE\default browser.txt"

# Define known registry paths for common browsers
$browserRegistryPaths = @{
    'Google Chrome' = 'HKLM:\SOFTWARE\Google\Chrome';
    'Mozilla Firefox' = 'HKLM:\SOFTWARE\Mozilla\Mozilla Firefox';
    'Microsoft Edge' = 'HKLM:\SOFTWARE\Microsoft\Edge';
    'Internet Explorer' = 'HKLM:\SOFTWARE\Microsoft\Internet Explorer';
    # Add other browsers and their registry paths as needed
}

$installedBrowsers = @()

foreach ($browser in $browserRegistryPaths.GetEnumerator()) {
    if (Test-Path $browser.Value) {
        $installedBrowsers += $browser.Key
    }
}

# Write the list of installed browsers to the file
$installedBrowsers | Out-File -Path $browsersListPath

# Get the default browser from the registry
$defaultBrowserProgId = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice' | 
    Select-Object -ExpandProperty ProgId

# Depending on the ProgId, determine the default browser's name
switch ($defaultBrowserProgId) {
    'FirefoxURL' { $defaultBrowser = 'Mozilla Firefox' }
    'ChromeHTML' { $defaultBrowser = 'Google Chrome' }
    'IE.HTTP' { $defaultBrowser = 'Internet Explorer' }
    'MSEdgeHTM' { $defaultBrowser = 'Microsoft Edge' }
    default { $defaultBrowser = 'Unknown Browser' }
}

# Write the default browser to the file
$defaultBrowser | Out-File -Path $defaultBrowserPath
