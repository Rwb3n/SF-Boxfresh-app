# Vault Content Inventory Script
# Purpose: Generate inventory data for all files in the project
# Usage: .\inventory_script.ps1 > inventory_results.csv

# Define project root folder paths - all directories at the root level
$legacyFolders = @(
    ".",
    "project",
    "consolidation", 
    "implementation",
    "overview",
    "reference",
    "core_abstraction"
)

# CSV header
Write-Output "Folder,Filename,Path,SizeKB,LastModified,LineCount,HasFrontmatter,HasHeadings,HasLists,ContentType,MigratedInSprint6"

# Previously migrated files from Sprint 6 (if applicable)
$migratedFiles = @(
    # Add any previously migrated files here if needed
)

# Process each folder
foreach ($folder in $legacyFolders) {
    # Check if the folder exists
    if (Test-Path -Path $folder) {
        # Get all files (not just markdown)
        Get-ChildItem -Path $folder -File -Recurse | ForEach-Object {
            $filePath = $_.FullName.Replace("$PWD\", "")
            $relativePath = $filePath
            $fileName = $_.Name
            $sizeKB = [math]::Round($_.Length / 1KB, 1)
            $lastModified = $_.LastWriteTime.ToString("yyyy-MM-dd")
            
            # Check if the file is already migrated in Sprint 6
            $isMigrated = $migratedFiles -contains $relativePath
            $migratedStatus = if ($isMigrated) { "Yes" } else { "No" }
            
            # Default values for non-markdown files
            $lineCount = 0
            $hasFrontmatter = "N/A"
            $hasHeadings = "N/A"
            $hasLists = "N/A"
            $contentType = "Unknown"
            
            # Process markdown files with content analysis
            if ($_.Extension -eq ".md") {
                # Read file content
                $content = Get-Content -Path $_.FullName -Raw -ErrorAction SilentlyContinue
                if ($content) {
                    # Count lines
                    $lineCount = ($content | Measure-Object -Line).Lines
                    
                    # Check for frontmatter
                    $hasFrontmatter = if ($content -match "^---\s*\n.*?\n---\s*\n") { "Yes" } else { "No" }
                    
                    # Check for headings
                    $hasHeadings = if ($content -match "#") { "Yes" } else { "No" }
                    
                    # Check for lists
                    $hasLists = if ($content -match "^\s*[-*+]|^\s*\d+\.") { "Yes" } else { "No" }
                    
                    # Try to determine content type based on patterns
                    if ($hasFrontmatter -eq "Yes" -and $content -match "tags:") {
                        if ($content -match "tags:.*?Foundation|Philosophy|Core|Manifesto") {
                            $contentType = "Foundation"
                        } elseif ($content -match "tags:.*?Process|Workflow|Procedure") {
                            $contentType = "Process"
                        } elseif ($content -match "tags:.*?Knowledge|Reference|Guide") {
                            $contentType = "Knowledge"
                        } elseif ($content -match "tags:.*?Project|Task|Todo") {
                            $contentType = "Project"
                        } elseif ($content -match "tags:.*?Research|Study|Analysis") {
                            $contentType = "Research"
                        } elseif ($content -match "tags:.*?Idea|Brainstorm|Concept") {
                            $contentType = "Idea"
                        } elseif ($content -match "tags:.*?Reflection|Journal|Diary") {
                            $contentType = "Reflection"
                        } elseif ($content -match "tags:.*?Template|Form|Framework") {
                            $contentType = "Template"
                        }
                    } else {
                        # Try to infer based on filename and content patterns
                        if ($fileName -match "manifesto|philosophy|principles") {
                            $contentType = "Foundation"
                        } elseif ($fileName -match "process|workflow|procedure|guide") {
                            $contentType = "Process"
                        } elseif ($fileName -match "project|task|todo") {
                            $contentType = "Project"
                        } elseif ($fileName -match "research|study|analysis") {
                            $contentType = "Research"
                        } elseif ($fileName -match "idea|concept|brainstorm") {
                            $contentType = "Idea"
                        } elseif ($fileName -match "journal|reflection|diary|\d{2}-\d{2}-\d{4}") {
                            $contentType = "Reflection"
                        } elseif ($fileName -match "template|form|framework") {
                            $contentType = "Template"
                        } elseif ($content -match "^#\s+.*?Vision|Plan|Strategy|Roadmap") {
                            $contentType = "Vision"
                        }
                    }
                }
            } else {
                # Non-markdown file type categorization
                $contentType = switch -Regex ($_.Extension) {
                    "\.json|\.yaml|\.yml" { "Configuration" }
                    "\.js|\.ts|\.py|\.java|\.cs|\.go|\.rb" { "Code" }
                    "\.html|\.css|\.scss" { "Web" }
                    "\.txt" { "Text" }
                    "\.pdf|\.docx|\.pptx" { "Document" }
                    "\.jpg|\.png|\.gif|\.svg" { "Image" }
                    "\.csv|\.xlsx" { "Data" }
                    default { "Other" }
                }
            }
            
            # Output CSV row
            Write-Output "$folder,$fileName,$relativePath,$sizeKB,$lastModified,$lineCount,$hasFrontmatter,$hasHeadings,$hasLists,$contentType,$migratedStatus"
        }
    } else {
        Write-Host "Warning: Folder $folder does not exist and will be skipped." -ForegroundColor Yellow
    }
}

# Output summary
Write-Host "Inventory script completed. Results output as CSV."
Write-Host "To use: .\inventory_script.ps1 > inventory_results.csv" 