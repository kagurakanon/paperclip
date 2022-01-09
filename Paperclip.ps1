#!/usr/bin/env pwsh

$cssVersion = 1

class BlogPost {
  [string]   $Path
  [datetime] $Date
  [string]   $Title
  [string[]] $Tags
  [string]   $Author
  [string]   $Mail
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
  $local:post.Author = $local:metadata["author"] ?? "No Author"
  $local:post.Mail = $local:metadata["mail"] ?? "No Mail"

  $local:htmlfile = Join-Path $post.Path "index.html"
  $local:html = $local:markdown
    | ConvertFrom-Markdown
    | Select-Object -ExpandProperty Html

  @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>$($local:post.Title)</title>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.15.1/dist/katex.min.css" integrity="sha384-R4558gYOUz8mP9YWpZJjofhk+zx0AS11p36HnD2ZKj/6JR5z27gSSULCNHIRReVs" crossorigin="anonymous">
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.15.1/dist/katex.min.js" integrity="sha384-z1fJDqw8ZApjGO3/unPWUPsIymfsJmyrDVWC8Tv/a1HeOtGmkwNd/7xUS0Xcnvsx" crossorigin="anonymous"></script>
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.15.1/dist/contrib/auto-render.min.js" integrity="sha384-+XBljXPPiv+OzfbB3cVmLHf4hdUFHlWNZN5spNQ7rmHTXpd7WvJum6fIACpNNfIR" crossorigin="anonymous" onload="renderMathInElement(document.body);"></script>

<link rel="stylesheet" href="../static/index.v$($cssVersion).css">
</head>
<body>
<div id="container">
<h1>$($local:post.Title)</h1>
<div id="metainfo">
<div id="author">$($local:post.Author)</div>
<div id="mail"><a href="mailto:$($local:post.Mail)">$($local:post.Mail)</a></div>
<div id="date">$($local:post.Date | Get-Date -Format "MMMM dd, yyyy" )</div>
</div>
$($local:html)
</div>
</body>
</html>
"@ -join "`n" | Out-File $local:htmlfile -Encoding Utf8

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
  ("<li>$($_.Date | Get-Date -Format "yyyy.mm.dd") &emsp;" +
   "<a href=`"$(Split-Path $_.Path -Leaf)/index.html`">$($_.Title)</a></li>")
} | Join-String -Separator "`n"

@"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Index</title>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.15.1/dist/katex.min.css" integrity="sha384-R4558gYOUz8mP9YWpZJjofhk+zx0AS11p36HnD2ZKj/6JR5z27gSSULCNHIRReVs" crossorigin="anonymous">
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.15.1/dist/katex.min.js" integrity="sha384-z1fJDqw8ZApjGO3/unPWUPsIymfsJmyrDVWC8Tv/a1HeOtGmkwNd/7xUS0Xcnvsx" crossorigin="anonymous"></script>
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.15.1/dist/contrib/auto-render.min.js" integrity="sha384-+XBljXPPiv+OzfbB3cVmLHf4hdUFHlWNZN5spNQ7rmHTXpd7WvJum6fIACpNNfIR" crossorigin="anonymous" onload="renderMathInElement(document.body);"></script>

<link rel="stylesheet" href="./static/index.v$($cssVersion).css">
</head>
<body>
<h1 style="text-align: left">Index</h1>
$($script:indexhtml)
</body>
</html>
"@ -join "`n" | Out-File $local:indexfile -Encoding Utf8
