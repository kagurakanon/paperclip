class BlogPost {
  [string]   $Path
  [datetime] $Date
  [string]   $Title
  [string[]] $Tags
}

function Get-BlogPost {

  param (
    [Parameter(ValueFromPipeline, Position = 0)]
    [string] $Path
  )

  [blogpost] $local:post = New-Object BlogPost

  $local:post.Path = $Path

  try {
    $local:dateFormat = '(?s)(?<Date>\d{4}-\d{2}-\d{2}).*'
    if ((Split-Path -Path $Path -Leaf) -match $local:dateFormat) {
      $local:post.Date = Get-Date $Matches['Date']
    } else {
      return $null
    }
  } catch {
    return $null
  }

  $local:mdfile = Join-Path $post.Path "index.md"
  if (-not (Test-Path $local:mdfile -PathType Leaf)) {
    return $null
  }
  
  $local:content = Get-Content $local:mdfile -Encoding Utf8 -Raw

  # FIXME: This Regex can't handle horizontal rules (`---`) correctly.
  $local:format = "(?s)\A`-`-`-`n(?<Json>.*)`n`-`-`-`n(?<Md>.*)\Z"
  if (-not ($local:content -match $local:format)) {
    return $null
  }
  
  $local:json, $local:markdown = $Matches['Json'], $Matches['Md']

  try {
    $local:metadata = $local:json | ConvertFrom-Json -AsHashtable
  } catch {
    return $null
  }

  $local:post.Title = $local:metadata["title"] ?? "No Title"
  $local:post.Tags = $local:metadata["tags"] ?? @()

  $local:htmlfile = Join-Path $post.Path "index.html"
  $local:html = $local:markdown
    | ConvertFrom-Markdown
    | Select-Object -ExpandProperty Html

  @('<!DOCTYPE html>',
    '<html lang="en">',
    '<head>'
    '<meta charset="UTF-8">'
    "<title>$($local:post.Title)</title>"
    '</head>',
    '<body>',
    "<h1>$($local:post.Title)</h1>"
    "$($local:html)",
    '</body>',
    '</html>'
  ) -join "`n" | Out-File $local:htmlfile -Encoding Utf8

  return $local:post
}

$script:posts =
  Get-ChildItem -Path $env:PWD
    | Where-Object { $_.Name -match '(?s)\A\d{4}-\d{2}-\d{2}.*\Z' }
    | ForEach-Object { Get-BlogPost $_ }
    | Where-Object { $_ -ne $null }
    | Sort-Object -Property Date, Path -Descending

$script:indexfile = Join-Path $env:PWD "index.html"

$script:indexhtml = $script:posts | ForEach-Object {
  ("<li>$($_.Date) " +
   "<a href=`"$(Split-Path $_.Path -Leaf)/index.html`">$($_.Title)</a></li>")
} | Join-String -Separator "`n"

@('<!DOCTYPE html>',
  '<html lang="en">',
  '<head>'
  '<meta charset="UTF-8">'
  "<title>Index</title>"
  '</head>',
  '<body>',
  "<h1>Index</h1>"
  "$($script:indexhtml)",
  '</body>',
  '</html>'
) -join "`n" | Out-File $local:indexfile -Encoding Utf8
